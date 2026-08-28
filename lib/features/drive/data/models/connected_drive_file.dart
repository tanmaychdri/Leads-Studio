import 'dart:convert';

class ConnectedDriveFile {
  final String fileId;
  final String fileName;
  final String mimeType;
  final DateTime? modifiedTime;
  final int? size;
  final String? localPath;

  ConnectedDriveFile({
    required this.fileId,
    required this.fileName,
    required this.mimeType,
    this.modifiedTime,
    this.size,
    this.localPath,
  });

  ConnectedDriveFile copyWith({
    String? fileId,
    String? fileName,
    String? mimeType,
    DateTime? modifiedTime,
    int? size,
    String? localPath,
  }) {
    return ConnectedDriveFile(
      fileId: fileId ?? this.fileId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      modifiedTime: modifiedTime ?? this.modifiedTime,
      size: size ?? this.size,
      localPath: localPath ?? this.localPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileId': fileId,
      'fileName': fileName,
      'mimeType': mimeType,
      'modifiedTime': modifiedTime?.toIso8601String(),
      'size': size,
      'localPath': localPath,
    };
  }

  factory ConnectedDriveFile.fromMap(Map<String, dynamic> map) {
    return ConnectedDriveFile(
      fileId: map['fileId'] ?? '',
      fileName: map['fileName'] ?? '',
      mimeType: map['mimeType'] ?? '',
      modifiedTime: map['modifiedTime'] != null ? DateTime.tryParse(map['modifiedTime']) : null,
      size: map['size'],
      localPath: map['localPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConnectedDriveFile.fromJson(String source) => ConnectedDriveFile.fromMap(json.decode(source));
}
