import 'dart:io';
import 'package:excel/excel.dart';
import 'package:leads_studio/features/excel/data/models/lead.dart';
import 'package:leads_studio/features/excel/data/models/parse_result.dart';
import 'package:leads_studio/features/excel/data/services/column_mapper.dart';
import 'package:leads_studio/features/excel/data/services/data_parsers.dart';

class ExcelService {
  Excel? _workbook;
  String? _loadedFilePath;

  /// Loads the Excel workbook from the local file path.
  Future<void> loadWorkbook(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('Excel file not found at path: $filePath');
    }

    final bytes = await file.readAsBytes();
    _workbook = Excel.decodeBytes(bytes);
    _loadedFilePath = filePath;
  }

  /// Returns the names of all worksheets in the loaded workbook.
  List<String> getWorksheetNames() {
    if (_workbook == null) throw Exception('Workbook not loaded.');
    return _workbook!.tables.keys.toList();
  }

  /// Parses the specified worksheet into Lead models.
  Future<ParseResult> parseWorksheet(String sheetName) async {
    if (_workbook == null) throw Exception('Workbook not loaded.');
    
    final table = _workbook!.tables[sheetName];
    if (table == null) throw Exception('Worksheet "$sheetName" not found.');

    final rows = table.rows;
    if (rows.isEmpty) {
      return ParseResult(leads: [], totalRows: 0, error: 'Worksheet is empty.');
    }

    // Find the header row (first non-empty row)
    int headerRowIndex = -1;
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].any((cell) => cell != null && cell.value != null)) {
        headerRowIndex = i;
        break;
      }
    }

    if (headerRowIndex == -1) {
      return ParseResult(leads: [], totalRows: 0, error: 'No data found in worksheet.');
    }

    // Extract headers
    final headerRow = rows[headerRowIndex];
    final headers = headerRow.map((cell) => DataParsers.parseString(cell) ?? '').toList();

    // Map columns
    final mapper = ColumnMapper(headers);
    final customFieldNames = mapper.getCustomFieldNames();

    final List<Lead> leads = [];
    final List<ParseWarning> warnings = [];

    // Parse data rows
    for (int i = headerRowIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      
      // Check if the row has any actual textual/numeric data
      bool hasData = false;
      for (final cell in row) {
        final val = DataParsers.parseString(cell);
        if (val != null && val.isNotEmpty) {
          hasData = true;
          break;
        }
      }

      // Silently skip completely empty rows (or rows with just formatting/dropdowns but no text)
      if (!hasData) {
        continue; 
      }

      // Safe getter
      Data? getCell(String field) {
        final idx = mapper.getIndex(field);
        if (idx == null || idx >= row.length) return null;
        return row[idx];
      }

      // Read standard fields
      final clientName = DataParsers.parseString(getCell('clientName'));
      final phoneNumber = DataParsers.parseString(getCell('phoneNumber'));
      
      if (clientName == null && phoneNumber == null) {
        warnings.add(ParseWarning(rowIndex: i + 1, message: 'Row missing both name and phone number.'));
      }

      // Read custom fields
      final Map<String, dynamic> customFields = {};
      for (final customName in customFieldNames) {
        final val = DataParsers.parseString(getCell(customName));
        if (val != null && val.isNotEmpty) {
          customFields[customName] = val;
        }
      }

      // Build Lead
      leads.add(Lead(
        clientName: clientName,
        phoneNumber: phoneNumber,
        email: DataParsers.parseString(getCell('email')),
        eventType: DataParsers.parseString(getCell('eventType')),
        eventDate: DataParsers.parseDate(getCell('eventDate')),
        leadSource: DataParsers.parseString(getCell('leadSource')),
        status: DataParsers.parseString(getCell('status')),
        lastContactDate: DataParsers.parseDate(getCell('lastContactDate')),
        nextFollowUpDate: DataParsers.parseDate(getCell('nextFollowUpDate')),
        reminderDate: DataParsers.parseDate(getCell('reminderDate')),
        notes: DataParsers.parseString(getCell('notes')),
        budget: DataParsers.parseDouble(getCell('budget')),
        assignedPerson: DataParsers.parseString(getCell('assignedPerson')),
        customFields: customFields,
      ));
    }

    return ParseResult(
      leads: leads,
      totalRows: rows.length - (headerRowIndex + 1),
      warnings: warnings,
    );
  }

  /// Safe write architecture: Save modifications back to the Excel file.
  Future<void> saveWorkbook() async {
    if (_workbook == null || _loadedFilePath == null) {
      throw Exception('No active workbook to save.');
    }

    final fileBytes = _workbook!.encode();
    if (fileBytes == null) {
      throw Exception('Failed to encode workbook.');
    }

    // Write to safe temp file first
    final tempPath = '$_loadedFilePath.temp';
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(fileBytes, flush: true);

    // Overwrite original
    final originalFile = File(_loadedFilePath!);
    if (await originalFile.exists()) {
      await originalFile.delete();
    }
    await tempFile.rename(_loadedFilePath!);
  }
}