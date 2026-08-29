class ColumnMapper {
  final Map<String, int> _fieldIndices = {};
  final List<String> _customFieldNames = [];
  
  static const Map<String, List<String>> _knownAliases = {
    'id': ['leadflow_id', '_leadflow_id_', 'leadflow id'],
    'clientName': ['name', 'client name', 'customer name', 'lead name', 'client'],
    'phoneNumber': ['phone', 'mobile', 'mobile number', 'phone number', 'contact', 'contact no', 'cell'],
    'email': ['email', 'e-mail', 'email address'],
    'eventType': ['event', 'event type', 'type of event', 'occasion'],
    'eventDate': ['event date', 'date of event'],
    'leadSource': ['source', 'lead source', 'platform', 'referred by'],
    'status': ['status', 'lead status', 'stage'],
    'lastContactDate': ['last contact', 'last contacted', 'last contact date'],
    'nextFollowUpDate': ['next follow-up', 'next follow up', 'follow up date', 'follow-up', 'followup'],
    'reminderDate': ['reminder', 'reminder date'],
    'notes': ['notes', 'remarks', 'comments', 'description'],
    'budget': ['budget', 'amount', 'price', 'quote'],
    'assignedPerson': ['assigned to', 'assignee', 'owner', 'handled by'],
  };

  ColumnMapper(List<String> headers) {
    for (int i = 0; i < headers.length; i++) {
      final header = headers[i].trim();
      if (header.isEmpty) continue;
      
      final normalizedHeader = _normalize(header);
      
      bool matched = false;
      for (final entry in _knownAliases.entries) {
        if (entry.value.contains(normalizedHeader) || entry.key.toLowerCase() == normalizedHeader) {
          _fieldIndices.putIfAbsent(entry.key, () => i);
          _fieldIndices.putIfAbsent(header, () => i); // Map exact string so legacy custom fields correctly resolve
          matched = true;
          break;
        }
      }
      
      // If it doesn't match a standard field, store it by its exact original name for customFields
      if (!matched) {
        _fieldIndices[header] = i; 
        _customFieldNames.add(header);
      }
    }
  }

  String _normalize(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  int? getIndex(String field) => _fieldIndices[field];
  
  void setIndex(String field, int index) {
    _fieldIndices[field] = index;
  }

  /// Returns all column names that were mapped as custom fields (not in standard aliases)
  List<String> getCustomFieldNames() => _customFieldNames;
}