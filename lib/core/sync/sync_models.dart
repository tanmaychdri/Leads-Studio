enum SyncStatus {
  idle,
  syncing,
  success,
  failed,
  conflict,
}

class SyncState {
  final SyncStatus status;
  final String? errorMessage;
  final DateTime? lastSyncTime;
  final int pendingChangesCount;
  final List<SyncConflict>? activeConflicts;
  final Set<String> resolvedLocalWins;

  const SyncState({
    this.status = SyncStatus.idle,
    this.errorMessage,
    this.lastSyncTime,
    this.pendingChangesCount = 0,
    this.activeConflicts,
    this.resolvedLocalWins = const {},
  });

  SyncState copyWith({
    SyncStatus? status,
    String? errorMessage,
    DateTime? lastSyncTime,
    int? pendingChangesCount,
    List<SyncConflict>? activeConflicts,
    Set<String>? resolvedLocalWins,
  }) {
    return SyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      pendingChangesCount: pendingChangesCount ?? this.pendingChangesCount,
      activeConflicts: activeConflicts ?? this.activeConflicts,
      resolvedLocalWins: resolvedLocalWins ?? this.resolvedLocalWins,
    );
  }
}

class SyncConflict {
  final String leadId;
  final String clientName;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;

  const SyncConflict({
    required this.leadId,
    required this.clientName,
    required this.localData,
    required this.remoteData,
  });
}
