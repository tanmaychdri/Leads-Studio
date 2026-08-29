import 'package:leads_studio/features/drive/data/models/connected_drive_file.dart';

class DriveState {
  final bool isLoading;
  final String? error;
  final ConnectedDriveFile? connectedFile;
  final List<ConnectedDriveFile> availableFiles;
  final String? downloadingFileId;

  const DriveState({
    this.isLoading = false,
    this.error,
    this.connectedFile,
    this.availableFiles = const [],
    this.downloadingFileId,
  });

  bool get isConnected => connectedFile != null;

  DriveState copyWith({
    bool? isLoading,
    String? error,
    ConnectedDriveFile? connectedFile,
    List<ConnectedDriveFile>? availableFiles,
    bool clearError = false,
    String? downloadingFileId,
    bool clearDownloadingFileId = false,
  }) {
    return DriveState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      connectedFile: connectedFile ?? this.connectedFile,
      availableFiles: availableFiles ?? this.availableFiles,
      downloadingFileId: clearDownloadingFileId ? null : (downloadingFileId ?? this.downloadingFileId),
    );
  }
}
