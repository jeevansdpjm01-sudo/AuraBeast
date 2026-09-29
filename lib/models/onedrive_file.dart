class OneDriveFile {
  final String id;
  final String name;
  final String? webUrl;
  final int? size;
  final DateTime? createdDateTime;
  final DateTime? lastModifiedDateTime;
  final String? fileType; // e.g., 'audio', 'video'
  final Map<String, dynamic>? audioMetadata; // From Microsoft Graph audio metadata if available

  OneDriveFile({
    required this.id,
    required this.name,
    this.webUrl,
    this.size,
    this.createdDateTime,
    this.lastModifiedDateTime,
    this.fileType,
    this.audioMetadata,
  });

  factory OneDriveFile.fromGraph(Map<String, dynamic> json) {
    return OneDriveFile(
      id: json['id'],
      name: json['name'],
      webUrl: json['webUrl'],
      size: json['size'],
      createdDateTime: json['createdDateTime'] != null
          ? DateTime.parse(json['createdDateTime'])
          : null,
      lastModifiedDateTime: json['lastModifiedDateTime'] != null
          ? DateTime.parse(json['lastModifiedDateTime'])
          : null,
      fileType: json['file'] != null ? json['file']['mimeType'] : null,
      audioMetadata: json['audio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'webUrl': webUrl,
      'size': size,
      'createdDateTime': createdDateTime?.toIso8601String(),
      'lastModifiedDateTime': lastModifiedDateTime?.toIso8601String(),
      'fileType': fileType,
      'audioMetadata': audioMetadata,
    };
  }

  bool get isAudio => fileType?.startsWith('audio/') ?? false;
}