import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_provider.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_state.dart';
import 'package:leads_studio/features/excel/data/models/parse_result.dart';
import 'package:leads_studio/features/excel/data/services/excel_service.dart';

final excelServiceProvider = Provider((ref) => ExcelService());

final excelProvider = StateNotifierProvider<ExcelNotifier, ExcelState>((ref) {
  return ExcelNotifier(
    ref.watch(excelServiceProvider),
    ref.watch(driveProvider),
  );
});

class ExcelState {
  final bool isLoading;
  final String? error;
  final List<String> availableWorksheets;
  final String? selectedWorksheet;
  final ParseResult? parseResult;

  const ExcelState({
    this.isLoading = false,
    this.error,
    this.availableWorksheets = const [],
    this.selectedWorksheet,
    this.parseResult,
  });

  ExcelState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<String>? availableWorksheets,
    String? selectedWorksheet,
    ParseResult? parseResult,
  }) {
    return ExcelState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      availableWorksheets: availableWorksheets ?? this.availableWorksheets,
      selectedWorksheet: selectedWorksheet ?? this.selectedWorksheet,
      parseResult: parseResult ?? this.parseResult,
    );
  }
}

class ExcelNotifier extends StateNotifier<ExcelState> {
  final ExcelService _excelService;
  final DriveState driveState;

  ExcelNotifier(this._excelService, this.driveState) : super(const ExcelState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final connectedFile = driveState.connectedFile;
    if (connectedFile == null || connectedFile.localPath == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // 1. Load Workbook
      await _excelService.loadWorkbook(connectedFile.localPath!);
      
      // 2. Get sheets
      final sheets = _excelService.getWorksheetNames();
      
      if (sheets.isEmpty) {
        throw Exception('No worksheets found in the Excel file.');
      }

      // If only 1 sheet, auto-select and parse
      if (sheets.length == 1) {
        state = state.copyWith(availableWorksheets: sheets, selectedWorksheet: sheets.first);
        await _parseSelectedWorksheet(sheets.first);
      } else {
        // Need user to select a sheet
        state = state.copyWith(isLoading: false, availableWorksheets: sheets);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> selectWorksheet(String sheetName) async {
    state = state.copyWith(selectedWorksheet: sheetName);
    await _parseSelectedWorksheet(sheetName);
  }

  Future<void> _parseSelectedWorksheet(String sheetName) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _excelService.parseWorksheet(sheetName);
      state = state.copyWith(isLoading: false, parseResult: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}