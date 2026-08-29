import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/excel/presentation/providers/excel_provider.dart';
import 'package:leads_studio/core/widgets/glass/ambient_background.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';

class WorksheetSelectionScreen extends ConsumerWidget {
  const WorksheetSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excelState = ref.watch(excelProvider);

    return Stack(
      children: [
        const AmbientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Excel Data Parser', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
          ),
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
        ),
      ],
    );
  }

  Widget _buildSheetSelection(BuildContext context, WidgetRef ref, ExcelState state) {
    if (state.availableWorksheets.isEmpty) {
      return const Center(child: Text('No worksheets found.'));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Multiple worksheets detected. Please select the one containing your leads:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
        ),
        const SizedBox(height: 16),
        ...state.availableWorksheets.map((sheet) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GlassContainer(
                onTap: () {
                  ref.read(excelProvider.notifier).selectWorksheet(sheet);
                },
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.table_chart, color: Colors.blue),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(sheet, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white54 : Colors.black54),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildResultView(ExcelState state) {
    final result = state.parseResult!;
    final importSummary = state.importSummary;
    
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 64),
        const SizedBox(height: 16),
        const Text(
          'Spreadsheet Parsed Successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        
        GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildStatCard('Total Rows Found', result.totalRows.toString(), Colors.blue),
              const SizedBox(height: 16),
              _buildStatCard('Leads Extracted', result.leads.length.toString(), Colors.green),
              if (result.leads.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildStatCard('Custom Fields Found', result.leads.first.customFields.keys.length.toString(), Colors.orange),
              ]
            ],
          ),
        ),
        
        if (importSummary != null) ...[
          const SizedBox(height: 32),
          const Text('Database Import Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
          const SizedBox(height: 12),
          GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildStatCard('Successfully Imported', importSummary.successfullyImported.toString(), Colors.purple),
                const SizedBox(height: 16),
                _buildStatCard('Skipped (Local Changes Protected)', importSummary.skippedDueToLocalChanges.toString(), Colors.orange),
              ],
            ),
          ),
        ],
        const SizedBox(height: 32),
        if (result.warnings.isNotEmpty) ...[
          const Text('Warnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 12),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...result.warnings.take(10).map((w) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning, color: Colors.orange, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text('Row ${w.rowIndex}: ${w.message}'),
                          ),
                        ],
                      ),
                    )),
                if (result.warnings.length > 10)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('...and ${result.warnings.length - 10} more warnings.', style: const TextStyle(color: Colors.grey)),
                  )
              ],
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }
}