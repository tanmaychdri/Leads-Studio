import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:leads_studio/features/drive/data/models/connected_drive_file.dart';

class DriveFileStorageService {
  final _storage = const FlutterSecureStorage();
  static const _key = 'connected_drive_file';

  /// Saves the connected file metadata to local storage
  Future<void> saveConnectedFile(ConnectedDriveFile file) async {
    await _storage.write(key: _key, value: file.toJson());
  }

  /// Retrieves the connected file metadata on app startup
  Future<ConnectedDriveFile?> getConnectedFile() async {
    final data = await _storage.read(key: _key);
    if (data == null) return null;
    
    try {
      return ConnectedDriveFile.fromJson(data);
    } catch (e) {
      // Data corrupted
      await clearConnectedFile();
      return null;
    }
  }

  /// Removes the connected file from storage (disconnects)
  Future<void> clearConnectedFile() async {
    await _storage.delete(key: _key);
  }
}
