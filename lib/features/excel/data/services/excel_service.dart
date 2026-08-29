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
  Future<Map<String, dynamic>?> addOrUpdateLead(String sheetName, Lead lead) async {
    if (_workbook == null) throw Exception('Workbook not loaded.');
    var table = _workbook!.tables[sheetName];
    if (table == null) throw Exception('Worksheet "$sheetName" not found.');

    final rows = table.rows;
    if (rows.isEmpty) return null;

    int headerRowIndex = -1;
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].any((cell) => cell != null && cell.value != null)) {
        headerRowIndex = i;
        break;
      }
    }
    if (headerRowIndex == -1) return null;

    final headerRow = rows[headerRowIndex];
    final headers = headerRow.map((cell) => DataParsers.parseString(cell) ?? '').toList();
    final mapper = ColumnMapper(headers);

    int actualMaxCol = 0;
    for (int i = 0; i < headerRow.length; i++) {
      if (headerRow[i] != null && headerRow[i]!.value != null && headerRow[i]!.value.toString().isNotEmpty) {
        actualMaxCol = i + 1;
      }
    }

    int? idColIndex = mapper.getIndex('id');
    
    // If LeadFlow_ID column doesn't exist, append it directly after the last actual header
    if (idColIndex == null) {
      idColIndex = actualMaxCol;
      table.updateCell(CellIndex.indexByColumnRow(columnIndex: idColIndex, rowIndex: headerRowIndex), TextCellValue('LeadFlow_ID'));
      mapper.setIndex('id', idColIndex);
      actualMaxCol++;
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

    bool isNewRow = false;
    if (targetRowIndex == null) {
      // Find the first truly empty row to prevent skipping rows if maxRows is artificially high due to formatting
      int firstEmptyRow = headerRowIndex + 1;
      for (int i = headerRowIndex + 1; i < rows.length; i++) {
        bool hasData = false;
        for (final cell in rows[i]) {
          if (cell != null && cell.value != null && cell.value.toString().isNotEmpty) {
            hasData = true;
            break;
          }
        }
        if (!hasData) {
          firstEmptyRow = i;
          break;
        }
        firstEmptyRow = i + 1;
      }
      targetRowIndex = firstEmptyRow;
      isNewRow = true;
    }
    
    // Always ensure the ID is explicitly written to the cell for this row!
    table.updateCell(CellIndex.indexByColumnRow(columnIndex: idColIndex, rowIndex: targetRowIndex), TextCellValue(lead.id));

    // Auto-populate Lead No and Date for newly appended rows if the user has those columns
    final Map<String, dynamic> mutableCustomFields = Map.from(lead.customFields);
    bool customFieldsUpdated = false;
    if (isNewRow) {
       String? leadNoHeader;
       String? dateHeader;
       for (final h in headers) {
          final norm = h.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
          if (norm == 'lead no') {
              leadNoHeader = h;
          } else if (norm == 'date') {
              dateHeader = h;
          }
       }
       
       if (leadNoHeader != null && !mutableCustomFields.containsKey(leadNoHeader)) {
          mutableCustomFields[leadNoHeader] = (targetRowIndex - headerRowIndex).toString();
          customFieldsUpdated = true;
       }
       if (dateHeader != null && !mutableCustomFields.containsKey(dateHeader)) {
          final now = DateTime.now();
          final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
          mutableCustomFields[dateHeader] = dateStr;
          customFieldsUpdated = true;
       }
    }

    int referenceRowIndex = targetRowIndex - 1;
    // Do not copy style from header row to avoid copying bold/background colors
    if (referenceRowIndex <= headerRowIndex) {
      referenceRowIndex = -1;
    }

    void setCell(String field, dynamic value) {
      int? colIdx = mapper.getIndex(field);
      if (colIdx == null) {
        colIdx = actualMaxCol;
        table.updateCell(CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: headerRowIndex), TextCellValue(field));
        mapper.setIndex(field, colIdx);
        actualMaxCol++;
      }
      
      final cellIndex = CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: targetRowIndex!);
      
      // Check if the cell already has the exact same value. If it does, DO NOT overwrite it.
      // This preserves original Formulas and custom font styles (like Lexend) applied by the user in Google Sheets.
      final existingData = targetRowIndex < rows.length && colIdx < rows[targetRowIndex].length ? rows[targetRowIndex][colIdx] : null;
      final existingStringValue = DataParsers.parseString(existingData);
      
      String newValueStr = '';
      if (value != null) {
        if (value is DateTime) {
           newValueStr = value.toIso8601String(); // Approximate string for comparison, but we should probably just compare accurately
        } else {
           newValueStr = value.toString();
        }
      }
      
      // We need a smart comparison. If the old value matches the new value, skip update.
      bool isChanged = true;
      if (existingStringValue == newValueStr || (existingStringValue == null && newValueStr.isEmpty)) {
        isChanged = false;
      }

      // Special handling for DateTime comparison to prevent false positives due to formatting
      if (value is DateTime && existingData?.value is DateTimeCellValue) {
         final d = existingData!.value as DateTimeCellValue;
         if (d.year == value.year && d.month == value.month && d.day == value.day && d.hour == value.hour && d.minute == value.minute) {
            isChanged = false;
         }
      }

      if (!isChanged) return; // Safely skip!

      // Retain existing style if possible
      CellStyle? styleToApply = existingData?.cellStyle;
      if (styleToApply == null && referenceRowIndex >= 0 && referenceRowIndex < rows.length && colIdx < rows[referenceRowIndex].length) {
         styleToApply = rows[referenceRowIndex][colIdx]?.cellStyle;
      }
      
      // The user explicitly requested Lexend for all added info, EXCEPT eventDate.
      // They also want all info to be vertically and horizontally centered.
      if (styleToApply != null) {
        if (field != 'eventDate') {
          styleToApply = styleToApply.copyWith(
            fontFamilyVal: 'Lexend',
            horizontalAlignVal: HorizontalAlign.Center,
            verticalAlignVal: VerticalAlign.Center,
          );
        } else {
          styleToApply = styleToApply.copyWith(
            horizontalAlignVal: HorizontalAlign.Center,
            verticalAlignVal: VerticalAlign.Center,
          );
        }
      } else {
        if (field != 'eventDate') {
          styleToApply = CellStyle(
            fontFamily: 'Lexend',
            horizontalAlign: HorizontalAlign.Center,
            verticalAlign: VerticalAlign.Center,
          );
        } else {
          styleToApply = CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            verticalAlign: VerticalAlign.Center,
          );
        }
      }

      if (value == null) {
         table.updateCell(cellIndex, TextCellValue(''), cellStyle: styleToApply);
      } else if (value is String) {
         table.updateCell(cellIndex, TextCellValue(value), cellStyle: styleToApply);
      } else if (value is double) {
         table.updateCell(cellIndex, DoubleCellValue(value), cellStyle: styleToApply);
      } else if (value is DateTime) {
         // Use DateTimeCellValue
         table.updateCell(cellIndex, DateTimeCellValue(year: value.year, month: value.month, day: value.day, hour: value.hour, minute: value.minute, second: value.second), cellStyle: styleToApply);
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

    for (final entry in mutableCustomFields.entries) {
      setCell(entry.key, entry.value);
    }
    
    return customFieldsUpdated ? mutableCustomFields : null;
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