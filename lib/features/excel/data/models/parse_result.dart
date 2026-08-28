import 'package:leads_studio/features/excel/data/models/lead.dart';

class ParseWarning {
  final int rowIndex;
  final String message;
  
  ParseWarning({required this.rowIndex, required this.message});
}

class ParseResult {
  final List<Lead> leads;
  final int totalRows;
  final List<ParseWarning> warnings;
  final String? error;

  ParseResult({
    required this.leads,
    required this.totalRows,
    this.warnings = const [],
    this.error,
  });

  bool get isSuccess => error == null;
}