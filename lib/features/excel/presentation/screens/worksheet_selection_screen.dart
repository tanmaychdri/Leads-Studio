import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/excel/presentation/providers/excel_provider.dart';

class WorksheetSelectionScreen extends ConsumerWidget {
  const WorksheetSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excelState = ref.watch(excelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Excel Data Parser')),
      body: excelState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : excelState.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(excelState.error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                )
              : excelState.parseResult != null
                  ? _buildResultView(excelState)
                  : _buildSheetSelection(context, ref, excelState),
    );
  }

  Widget _buildSheetSelection(BuildContext context, WidgetRef ref, ExcelState state) {
    if (state.availableWorksheets.isEmpty) {
      return const Center(child: Text('No worksheets found.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Multiple worksheets detected. Please select the one containing your leads:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...state.availableWorksheets.map((sheet) => Card(
              child: ListTile(
                leading: const Icon(Icons.table_chart),
                title: Text(sheet),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ref.read(excelProvider.notifier).selectWorksheet(sheet);
                },
              ),
            )),
      ],
    );
  }

  Widget _buildResultView(ExcelState state) {
    final result = state.parseResult!;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 64),
        const SizedBox(height: 16),
        const Text(
          'Spreadsheet Parsed Successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildStatCard('Total Rows Found', result.totalRows.toString(), Colors.blue),
        const SizedBox(height: 12),
        _buildStatCard('Leads Extracted', result.leads.length.toString(), Colors.green),
        const SizedBox(height: 12),
        if (result.leads.isNotEmpty)
          _buildStatCard('Custom Fields Found', result.leads.first.customFields.keys.length.toString(), Colors.orange),
        
        const SizedBox(height: 32),
        if (result.warnings.isNotEmpty) ...[
          const Text('Warnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 8),
          ...result.warnings.take(10).map((w) => ListTile(
                dense: true,
                leading: const Icon(Icons.warning, color: Colors.orange, size: 20),
                title: Text('Row ${w.rowIndex}: ${w.message}'),
              )),
          if (result.warnings.length > 10)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('...and ${result.warnings.length - 10} more warnings.', style: const TextStyle(color: Colors.grey)),
            )
        ]
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}