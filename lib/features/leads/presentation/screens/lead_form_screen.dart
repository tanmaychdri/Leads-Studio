import 'package:leads_studio/core/widgets/glass/glass_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/data/models/lead_status.dart';
import 'package:leads_studio/features/leads/presentation/providers/lead_details_provider.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';
import 'package:leads_studio/core/widgets/glass/glass_text_field.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/widgets/glass/glass_button.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class LeadFormScreen extends ConsumerStatefulWidget {
  final String? existingLeadId;
  const LeadFormScreen({super.key, this.existingLeadId});

  @override
  ConsumerState<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends ConsumerState<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _eventController;
  late TextEditingController _notesController;
  
  DateTime? _eventDate;
  DateTime? _followUpDate;
  String _selectedStatus = LeadStatus.newLead.name;
  
  bool _isLoading = true;
  bool _isSaving = false;
  Lead? _existingLead;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _eventController = TextEditingController();
    _notesController = TextEditingController();
    
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.existingLeadId == null) {
      setState(() => _isLoading = false);
      return;
    }
    
    final leadService = ref.read(leadServiceProvider);
    try {
      _existingLead = await leadService.getLeadById(widget.existingLeadId!);
      if (_existingLead != null) {
        _nameController.text = _existingLead!.clientName ?? '';
        _phoneController.text = _existingLead!.phoneNumber ?? '';
        _emailController.text = _existingLead!.email ?? '';
        _eventController.text = _existingLead!.eventType ?? '';
        _notesController.text = _existingLead!.notes ?? '';
        _eventDate = _existingLead!.eventDate;
        _followUpDate = _existingLead!.nextFollowUpDate;
        
        try {
          _selectedStatus = LeadStatus.values.firstWhere(
            (e) => e.displayName == _existingLead!.status
          ).name;
        } catch (_) {}
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _eventController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isEventDate) async {
    final initialDate = isEventDate ? _eventDate : _followUpDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && mounted) {
      setState(() {
        if (isEventDate) {
          _eventDate = picked;
        } else {
          _followUpDate = picked;
        }
      });
    }
  }

  Future<void> _saveLead() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      final leadService = ref.read(leadServiceProvider);
      final user = ref.read(authProvider).user;
      
      if (user == null) throw Exception('User not authenticated');
      
      final statusString = LeadStatus.values.firstWhere((e) => e.name == _selectedStatus).displayName;

      if (_existingLead == null) {
        await leadService.createLead(
          userId: user.id,
          clientName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          eventType: _eventController.text.trim(),
          eventDate: _eventDate,
          status: statusString,
          nextFollowUpDate: _followUpDate,
          notes: _notesController.text.trim(),
        );
      } else {
        await leadService.updateLead(
          _existingLead!,
          clientName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          eventType: _eventController.text.trim(),
          eventDate: _eventDate,
          status: statusString,
          nextFollowUpDate: _followUpDate,
          notes: _notesController.text.trim(),
        );
        ref.invalidate(leadDetailsProvider(_existingLead!.id));
      }
      
      if (mounted) {
        context.pop();
        GlassSnackBar.show(context, _existingLead == null ? 'Lead created!' : 'Lead updated!', isSuccess: true);
      }
    } catch (e) {
      if (mounted) {
        GlassSnackBar.show(context, 'Failed to save: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(backgroundColor: Colors.transparent, body: Center(child: CircularProgressIndicator()));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(_existingLead == null ? 'Add Lead' : 'Edit Lead', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GlassButton(
                onPressed: _saveLead,
                isPrimary: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text('SAVE'),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 120.0, top: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'CLIENT INFORMATION'),
              const SizedBox(height: 12),
              GlassContainer(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    GlassTextField(
                      controller: _nameController,
                      labelText: 'Client Name *',
                      prefixIcon: Icon(Icons.person, color: isDark ? Colors.white70 : Colors.black54),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    GlassTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone, color: isDark ? Colors.white70 : Colors.black54),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    GlassTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email, color: isDark ? Colors.white70 : Colors.black54),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: GlassTheme.getSurfaceColor(context, opacity: 0.5),
                        borderRadius: GlassTheme.radiusSmall,
                        border: Border.all(color: GlassTheme.getBorderColor(context, opacity: 0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white70 : Colors.black54),
                          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
                          items: LeadStatus.values.map((status) {
                            return DropdownMenuItem(
                              value: status.name,
                              child: Row(
                                children: [
                                  Icon(Icons.label, size: 20, color: isDark ? Colors.white70 : Colors.black54),
                                  const SizedBox(width: 12),
                                  Text(status.displayName),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedStatus = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              _buildSectionHeader(context, 'EVENT INFORMATION'),
              const SizedBox(height: 12),
              GlassContainer(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    GlassTextField(
                      controller: _eventController,
                      labelText: 'Event Type (e.g. Wedding)',
                      prefixIcon: Icon(Icons.event, color: isDark ? Colors.white70 : Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    _buildDateSelector(
                      context: context,
                      title: _eventDate == null ? 'Select Event Date' : DateFormat('dd MMM yyyy').format(_eventDate!),
                      icon: Icons.calendar_month,
                      onTap: () => _selectDate(context, true),
                      onClear: _eventDate != null ? () => setState(() => _eventDate = null) : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDateSelector(
                      context: context,
                      title: _followUpDate == null ? 'Set Follow-up Date' : DateFormat('dd MMM yyyy').format(_followUpDate!),
                      icon: Icons.notification_important,
                      onTap: () => _selectDate(context, false),
                      onClear: _followUpDate != null ? () => setState(() => _followUpDate = null) : null,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              _buildSectionHeader(context, 'ADDITIONAL NOTES'),
              const SizedBox(height: 12),
              GlassTextField(
                controller: _notesController,
                labelText: 'Notes',
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
      ),
    );
  }

  Widget _buildDateSelector({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    VoidCallback? onClear,
    bool isHighlight = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isHighlight ? AppColors.warning : (isDark ? Colors.white70 : Colors.black54);
    
    return InkWell(
      onTap: onTap,
      borderRadius: GlassTheme.radiusSmall,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: GlassTheme.getSurfaceColor(context, opacity: 0.5),
          borderRadius: GlassTheme.radiusSmall,
          border: Border.all(color: GlassTheme.getBorderColor(context, opacity: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.clear, size: 20, color: isDark ? Colors.white54 : Colors.black54),
              ),
          ],
        ),
      ),
    );
  }
}