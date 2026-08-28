import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:leads_studio/features/auth/data/services/auth_service.dart';
import 'package:leads_studio/features/auth/data/services/auth_client.dart';
import 'package:leads_studio/features/drive/data/models/connected_drive_file.dart';

class GoogleDriveService {
  final AuthService _authService;

  GoogleDriveService(this._authService);

  // Helper to get authenticated Drive API client
  Future<drive.DriveApi?> _getDriveApi() async {
    final token = await _authService.getAccessToken();
    if (token == null) return null;

    final client = AuthClient(token, http.Client());
    return drive.DriveApi(client);
  }

  /// Lists all Excel files in the user's Google Drive.
  Future<List<ConnectedDriveFile>> listExcelFiles() async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Not authenticated with Google');

    try {
      // Query for .xlsx files
      final fileList = await api.files.list(
        q: "mimeType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' and trashed=false",
        spaces: 'drive',
        $fields: 'files(id, name, mimeType, modifiedTime, size)',
      );

      final files = fileList.files;
      if (files == null) return [];

      return files.map((f) => ConnectedDriveFile(
        fileId: f.id ?? '',
        fileName: f.name ?? '',
        mimeType: f.mimeType ?? '',
        modifiedTime: f.modifiedTime,
        size: f.size != null ? int.tryParse(f.size!) : null,
      )).toList();
    } catch (e) {
      throw Exception('Failed to list Google Drive files: $e');
    }
  }

  /// Downloads the specified file to the given local path
  Future<void> downloadFile(String fileId, String localSavePath) async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Not authenticated with Google');

    try {
      final drive.Media media = await api.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final saveFile = File(localSavePath);
      final sink = saveFile.openWrite();
      
      await media.stream.forEach((chunk) {
        sink.add(chunk);
      });
      
      await sink.flush();
      await sink.close();
    } catch (e) {
      throw Exception('Failed to download file from Google Drive: $e');
    }
  }
}
