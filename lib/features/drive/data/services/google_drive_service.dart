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

  /// Lists Excel files and Google Sheets in the user's Google Drive.
  Future<List<ConnectedDriveFile>> listExcelFiles() async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Not authenticated with Google');

    try {
      // Query for .xlsx files OR native Google Sheets
      final fileList = await api.files.list(
        q: "(mimeType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or name contains '.xlsx' or mimeType='application/vnd.google-apps.spreadsheet') and trashed=false",
        spaces: 'drive',
        orderBy: 'modifiedTime desc',
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
      // Check the mimeType of the file to see if it's a native Google Sheet
      final fileMeta = await api.files.get(fileId, $fields: 'mimeType') as drive.File;
      
      final saveFile = File(localSavePath);
      final sink = saveFile.openWrite();
      
      if (fileMeta.mimeType == 'application/vnd.google-apps.spreadsheet') {
        // Native Google Sheets MUST be exported to Excel format
        final drive.Media media = await api.files.export(
          fileId,
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          downloadOptions: drive.DownloadOptions.fullMedia,
        ) as drive.Media;
        
        await media.stream.forEach((chunk) {
          sink.add(chunk);
        });
      } else {
        // Raw .xlsx files can be downloaded directly
        final drive.Media media = await api.files.get(
          fileId,
          downloadOptions: drive.DownloadOptions.fullMedia,
        ) as drive.Media;
        
        await media.stream.forEach((chunk) {
          sink.add(chunk);
        });
      }
      
      await sink.flush();
      await sink.close();
    } catch (e) {
      throw Exception('Failed to download file from Google Drive: $e');
    }
  }

  /// Fetches the latest modifiedTime of a file without downloading it.
  Future<DateTime?> getFileModifiedTime(String fileId) async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Not authenticated with Google');

    try {
      final fileMeta = await api.files.get(
        fileId,
        $fields: 'modifiedTime',
      ) as drive.File;
      
      return fileMeta.modifiedTime;
    } catch (e) {
      throw Exception('Failed to fetch file metadata: $e');
    }
  }

  /// Uploads a local Excel file to update an existing Google Drive file.
  /// For Google Sheets, this seamlessly overwrites the content while preserving the ID.
  Future<void> updateExcelFile(String fileId, String localFilePath) async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Not authenticated with Google');

    try {
      final localFile = File(localFilePath);
      final media = drive.Media(
        localFile.openRead(),
        localFile.lengthSync(),
        contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );


      final driveFile = drive.File();
      // Update the file binary content
      await api.files.update(
        driveFile,
        fileId,
        uploadMedia: media,
      );
    } catch (e) {
      throw Exception('Failed to upload updated Excel file: $e');
    }
  }
}