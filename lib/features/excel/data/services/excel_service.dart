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
      final id = DataParsers.parseString(getCell('id'));
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
        id: id,
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

  /// Safely adds or updates a lead row in the workbook by LeadFlow_ID.
  Future<void> addOrUpdateLead(String sheetName, Lead lead) async {
    if (_workbook == null) throw Exception('Workbook not loaded.');
    var table = _workbook!.tables[sheetName];
    if (table == null) throw Exception('Worksheet "$sheetName" not found.');

    final rows = table.rows;
    if (rows.isEmpty) return;

    int headerRowIndex = -1;
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].any((cell) => cell != null && cell.value != null)) {
        headerRowIndex = i;
        break;
      }
    }
    if (headerRowIndex == -1) return;

    final headerRow = rows[headerRowIndex];
    final headers = headerRow.map((cell) => DataParsers.parseString(cell) ?? '').toList();
    final mapper = ColumnMapper(headers);

    int? idColIndex = mapper.getIndex('id');
    
    // If LeadFlow_ID column doesn't exist, append it to the header
    if (idColIndex == null) {
      idColIndex = table.maxColumns;
      table.updateCell(CellIndex.indexByColumnRow(columnIndex: idColIndex, rowIndex: headerRowIndex), TextCellValue('LeadFlow_ID'));
      mapper.setIndex('id', idColIndex);
    }

    int? targetRowIndex;
    for (int i = headerRowIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      if (idColIndex < row.length) {
        final idVal = DataParsers.parseString(row[idColIndex]);
        if (idVal == lead.id) {
          targetRowIndex = i;
          break;
        }
      }
    }

    if (targetRowIndex == null) {
      int? nameColIndex = mapper.getIndex('clientName');
      int? phoneColIndex = mapper.getIndex('phoneNumber');
      
      for (int i = headerRowIndex + 1; i < rows.length; i++) {
        final row = rows[i];
        final nameVal = nameColIndex != null && nameColIndex < row.length ? DataParsers.parseString(row[nameColIndex]) : null;
        final phoneVal = phoneColIndex != null && phoneColIndex < row.length ? DataParsers.parseString(row[phoneColIndex]) : null;
        
        bool nameMatches = (nameVal == lead.clientName);
        bool phoneMatches = (phoneVal == lead.phoneNumber);
        
        if (nameMatches && phoneMatches && (nameVal != null || phoneVal != null)) {
          targetRowIndex = i;
          break;
        }
      }
    }

    if (targetRowIndex == null) {
      targetRowIndex = table.maxRows;
    }
    
    // Always ensure the ID is explicitly written to the cell for this row!
    table.updateCell(CellIndex.indexByColumnRow(columnIndex: idColIndex, rowIndex: targetRowIndex), TextCellValue(lead.id));

    void setCell(String field, dynamic value) {
      int? colIdx = mapper.getIndex(field);
      if (colIdx == null) {
        colIdx = table.maxColumns;
        table.updateCell(CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: headerRowIndex), TextCellValue(field));
        mapper.setIndex(field, colIdx);
      }
      final cellIndex = CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: targetRowIndex!);
      
      if (value == null) {
         table.updateCell(cellIndex, TextCellValue(''));
      } else if (value is String) {
         table.updateCell(cellIndex, TextCellValue(value));
      } else if (value is double) {
         table.updateCell(cellIndex, DoubleCellValue(value));
      } else if (value is DateTime) {
         // Use DateTimeCellValue
         table.updateCell(cellIndex, DateTimeCellValue(year: value.year, month: value.month, day: value.day, hour: value.hour, minute: value.minute, second: value.second));
      }
    }

    setCell('clientName', lead.clientName);
    setCell('phoneNumber', lead.phoneNumber);
    setCell('email', lead.email);
    setCell('eventType', lead.eventType);
    setCell('eventDate', lead.eventDate);
    setCell('leadSource', lead.leadSource);
    setCell('status', lead.status);
    setCell('lastContactDate', lead.lastContactDate);
    setCell('nextFollowUpDate', lead.nextFollowUpDate);
    setCell('reminderDate', lead.reminderDate);
    setCell('notes', lead.notes);
    setCell('budget', lead.budget);
    setCell('assignedPerson', lead.assignedPerson);

    for (final entry in lead.customFields.entries) {
      setCell(entry.key, entry.value);
    }
  }

  /// Safely removes a lead row from the workbook.
  Future<void> removeLead(String sheetName, String leadId) async {
    if (_workbook == null) throw Exception('Workbook not loaded.');
    var table = _workbook!.tables[sheetName];
    if (table == null) throw Exception('Worksheet "$sheetName" not found.');

    final rows = table.rows;
    if (rows.isEmpty) return;

    int headerRowIndex = -1;
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].any((cell) => cell != null && cell.value != null)) {
        headerRowIndex = i;
        break;
      }
    }
    if (headerRowIndex == -1) return;

    final headerRow = rows[headerRowIndex];
    final headers = headerRow.map((cell) => DataParsers.parseString(cell) ?? '').toList();
    final mapper = ColumnMapper(headers);
    
    int? idColIndex = mapper.getIndex('id');
    if (idColIndex == null) return; // No ID column, cannot safely delete.

    for (int i = headerRowIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      if (idColIndex < row.length) {
        final idVal = DataParsers.parseString(row[idColIndex]);
        if (idVal == leadId) {
          table.removeRow(i);
          break; // Stop after first match
        }
      }
    }
  }
}