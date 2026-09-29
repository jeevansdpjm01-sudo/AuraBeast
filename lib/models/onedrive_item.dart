class MicrosoftUserProfile {
  const MicrosoftUserProfile({
    required this.id,
    required this.displayName,
    required this.mail,
    required this.userPrincipalName,
  });

  final String id;
  final String displayName;
  final String? mail;
  final String userPrincipalName;

  factory MicrosoftUserProfile.fromJson(Map<String, dynamic> json) {
    return MicrosoftUserProfile(
      id: (json['id'] ?? '').toString(),
      displayName: (json['displayName'] ?? 'Microsoft User').toString(),
      mail: json['mail'] as String?,
      userPrincipalName: (json['userPrincipalName'] ?? '').toString(),
    );
  }
}

class DriveItemModel {
  const DriveItemModel({
    required this.id,
    required this.name,
    required this.size,
    required this.mimeType,
    required this.createdDateTime,
    required this.lastModifiedDateTime,
    required this.webUrl,
    required this.parentPath,
    required this.isFolder,
  });

  final String id;
  final String name;
  final int size;
  final String? mimeType;
  final DateTime createdDateTime;
  final DateTime lastModifiedDateTime;
  final String webUrl;
  final String parentPath;
  final bool isFolder;

  bool get isAudio {
    final lower = name.toLowerCase();
    return lower.endsWith('.mp3') ||
        lower.endsWith('.m4a') ||
        lower.endsWith('.wav') ||
        lower.endsWith('.flac') ||
        lower.endsWith('.aac') ||
        lower.endsWith('.ogg');
  }

  static DriveItemModel fromJson(Map<String, dynamic> json, {String parentPath = ''}) {
    final file = json['file'];
    final folder = json['folder'];

    return DriveItemModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      size: (json['size'] is int) ? json['size'] as int : int.tryParse('${json['size'] ?? 0}') ?? 0,
      mimeType: file != null ? (file['mimeType'] as String?) : null,
      createdDateTime: DateTime.tryParse('${json['createdDateTime'] ?? DateTime.now().toUtc().toIso8601String()}') ?? DateTime.now(),
      lastModifiedDateTime: DateTime.tryParse('${json['lastModifiedDateTime'] ?? DateTime.now().toUtc().toIso8601String()}') ?? DateTime.now(),
      webUrl: (json['webUrl'] ?? '').toString(),
      parentPath: parentPath,
      isFolder: folder != null,
    );
  }
}
