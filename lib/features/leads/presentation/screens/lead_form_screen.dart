import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/data/models/lead_status.dart';
import 'package:leads_studio/features/leads/presentation/providers/lead_details_provider.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';

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
        
        final statusEnum = LeadStatus.fromString(_existingLead!.status);
        _selectedStatus = statusEnum.name;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading lead: $e')));
      }
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
    
    if (picked != null) {
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
        // Refresh details provider
        ref.invalidate(leadDetailsProvider(_existingLead!.id));
      }
      
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_existingLead == null ? 'Lead created!' : 'Lead updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_existingLead == null ? 'Add Lead' : 'Edit Lead'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(
              onPressed: _saveLead,
              child: const Text('SAVE'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Client Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                items: LeadStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status.name,
                    child: Text(status.displayName),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedStatus = val);
                },
              ),
              const SizedBox(height: 24),
              
              Text('Event Information', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _eventController,
                decoration: const InputDecoration(
                  labelText: 'Event Type (e.g. Wedding)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event),
                ),
              ),
              const SizedBox(height: 16),
              
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                leading: const Icon(Icons.calendar_month),
                title: Text(_eventDate == null ? 'Select Event Date' : DateFormat('dd MMM yyyy').format(_eventDate!)),
                trailing: _eventDate != null
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _eventDate = null))
                    : null,
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 16),
              
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                leading: const Icon(Icons.notification_important),
                title: Text(_followUpDate == null ? 'Set Follow-up Date' : DateFormat('dd MMM yyyy').format(_followUpDate!)),
                trailing: _followUpDate != null
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _followUpDate = null))
                    : null,
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}