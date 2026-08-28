import 'package:excel/excel.dart';

class DataParsers {
  
  /// Parses an Excel cell value into a String.
  /// Handles numbers by stringifying them safely without decimals if they are whole.
  static String? parseString(Data? cell) {
    if (cell == null || cell.value == null) return null;
    
    final value = cell.value;
    if (value is TextCellValue) {
      final text = value.value.text ?? '';
      return text.trim().isEmpty ? null : text.trim();
    } else if (value is IntCellValue) {
      return value.value.toString();
    } else if (value is DoubleCellValue) {
      final double val = value.value;
      if (val == val.toInt()) {
        return val.toInt().toString(); // Strip trailing .0
      }
      return val.toString();
    } else if (value is BoolCellValue) {
      return value.value.toString();
    }
    
    return value.toString().trim();
  }

  /// Parses an Excel cell value into a DateTime object.
  /// Safely handles Excel serial dates (DoubleCellValue) and text dates.
  static DateTime? parseDate(Data? cell) {
    if (cell == null || cell.value == null) return null;
    
    final value = cell.value;
    
    if (value is DateTimeCellValue) {
      // The excel package already parsed it!
      return DateTime(
        value.year,
        value.month,
        value.day,
        value.hour,
        value.minute,
        value.second,
      );
    } else if (value is IntCellValue || value is DoubleCellValue) {
      // Excel serial date (days since Dec 30, 1899)
      final double serial = value is IntCellValue ? value.value.toDouble() : (value as DoubleCellValue).value;
      if (serial > 1 && serial < 2958465) {
        return DateTime(1899, 12, 30).add(Duration(days: serial.floor()));
      }
    } else if (value is TextCellValue) {
      // Try to parse string dates like "2026-08-12" or "12/08/2026"
      final text = value.value.text ?? '';
      try {
        return DateTime.parse(text.trim());
      } catch (_) {
        // Simple fallback for DD/MM/YYYY or MM/DD/YYYY
        final parts = text.trim().split(RegExp(r'[/.-]'));
        if (parts.length == 3) {
          try {
            int p1 = int.parse(parts[0]);
            int p2 = int.parse(parts[1]);
            int p3 = int.parse(parts[2]);
            if (p3 > 1900) {
              // Assume DD/MM/YYYY or MM/DD/YYYY, let's just pick one or return null if ambiguous and invalid
              if (p2 <= 12) {
                return DateTime(p3, p2, p1);
              } else if (p1 <= 12) {
                return DateTime(p3, p1, p2);
              }
            }
          } catch (_) {}
        }
      }
    }
    return null;
  }

  /// Parses a Budget or numeric value safely.
  static double? parseDouble(Data? cell) {
    if (cell == null || cell.value == null) return null;
    final value = cell.value;

    if (value is DoubleCellValue) return value.value;
    if (value is IntCellValue) return value.value.toDouble();
    if (value is TextCellValue) {
      final text = value.value.text ?? '';
      // Clean string of currency symbols and commas
      final cleaned = text.replaceAll(RegExp(r'[^0-9.-]'), '');
      return double.tryParse(cleaned);
    }
    return null;
  }
}