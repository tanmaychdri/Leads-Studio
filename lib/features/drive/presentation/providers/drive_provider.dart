import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/drive/data/models/connected_drive_file.dart';
import 'package:leads_studio/features/drive/data/services/drive_file_storage_service.dart';
import 'package:leads_studio/features/drive/data/services/google_drive_service.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_state.dart';

final driveStorageProvider = Provider((ref) => DriveFileStorageService());

final googleDriveServiceProvider = Provider((ref) {
  final authService = ref.watch(authServiceProvider);
  return GoogleDriveService(authService);
});

final driveProvider = StateNotifierProvider<DriveNotifier, DriveState>((ref) {
  return DriveNotifier(
    ref.watch(googleDriveServiceProvider),
    ref.watch(driveStorageProvider),
    ref.watch(authProvider.notifier),
  );
});

class DriveNotifier extends StateNotifier<DriveState> {
  final GoogleDriveService _driveService;
  final DriveFileStorageService _storageService;
  final AuthNotifier _authNotifier;

  DriveNotifier(this._driveService, this._storageService, this._authNotifier) : super(const DriveState()) {
    _loadPersistedFile();
  }

  Future<void> _loadPersistedFile() async {
    state = state.copyWith(isLoading: true);
    final file = await _storageService.getConnectedFile();
    state = state.copyWith(
      isLoading: false,
      connectedFile: file,
      clearError: true,
    );
  }

  Future<bool> connectDriveAndFetchFiles() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // 1. Request the full drive scope to allow uploading and modifying files
      final success = await _authNotifier.requestScopes(['https://www.googleapis.com/auth/drive']);
      if (!success) {
        state = state.copyWith(isLoading: false, error: 'Google Drive permission denied.');
        return false;
      }

      // 2. Fetch available Excel files
      final files = await _driveService.listExcelFiles();
      state = state.copyWith(isLoading: false, availableFiles: files);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> selectAndDownloadFile(ConnectedDriveFile file) async {
    state = state.copyWith(isLoading: true, downloadingFileId: file.fileId, clearError: true);
    try {
      // Get the local app documents directory
      final directory = await getApplicationDocumentsDirectory();
      
      // Ensure a leads_studio folder exists
      final appDir = Directory('${directory.path}/leads_studio_data');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }
      
      final localPath = '${appDir.path}/${file.fileName}';

      // Download it
      await _driveService.downloadFile(file.fileId, localPath);

      // Update the file model with local path
      final connectedFile = file.copyWith(localPath: localPath);

      // Save to persistence
      await _storageService.saveConnectedFile(connectedFile);

      // Update state
      state = state.copyWith(
        isLoading: false,
        connectedFile: connectedFile,
        availableFiles: [], // clear list
        clearDownloadingFileId: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString(), clearDownloadingFileId: true);
    }
  }

  Future<void> refreshConnectedFile() async {
    final currentFile = state.connectedFile;
    if (currentFile == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Just re-download it to the same local path
      await _driveService.downloadFile(currentFile.fileId, currentFile.localPath!);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> disconnectFile() async {
    state = state.copyWith(isLoading: true);
    
    // Optionally delete the local file
    if (state.connectedFile?.localPath != null) {
      final file = File(state.connectedFile!.localPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await _storageService.clearConnectedFile();
    state = const DriveState(); // Reset entirely
  }
}
