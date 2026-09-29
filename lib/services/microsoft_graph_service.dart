import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/microsoft_config.dart';
import '../models/onedrive_item.dart';
import 'microsoft_auth_service.dart';

class MicrosoftGraphService {
  MicrosoftGraphService._();

  static final MicrosoftGraphService instance = MicrosoftGraphService._();

  final http.Client _client = http.Client();

  Future<MicrosoftUserProfile> getProfile() async {
    final json = await _getJson('/me', query: 'select=id,displayName,mail,userPrincipalName');
    return MicrosoftUserProfile.fromJson(json);
  }

  Future<String> ensureAppFolder() async {
    final folderName = MicrosoftConfig.appFolderPath.replaceFirst(RegExp(r'^/'), '');
    final path = '/me/drive/root:/$folderName';
    try {
      await _getJson(path, query: 'select=id,name');
      return MicrosoftConfig.appFolderPath;
    } on GraphHttpException catch (error) {
      if (error.statusCode == 404) {
        await _getJson('/me/drive/root:/Apps', query: 'select=id,name');
        final created = await _putJson(
          '/me/drive/root:/Apps:/children',
          body: {
            'name': 'AuraBeast',
            'folder': {},
            '@microsoft.graph.conflictBehavior': 'fail',
          },
          query: 'select=id,name',
        );
        return (created['webUrl'] as String?) ?? MicrosoftConfig.appFolderPath;
      }
      rethrow;
    }
  }

  Future<List<DriveItemModel>> listFiles() async {
    await ensureAppFolder();

    final json = await _getJson(
      '/me/drive/root:/Apps/AuraBeast:/children',
      query:
          'select=id,name,size,file,mimeType,createdDateTime,lastModifiedDateTime,webUrl',
    );

    final items = json['value'] as List<dynamic>? ?? const <dynamic>[];
    return items
        .map((item) => DriveItemModel.fromJson(Map<String, dynamic>.from(item as Map), parentPath: MicrosoftConfig.appFolderPath))
        .toList();
  }

  Future<DriveItemModel> uploadAudioFile({
    required String fileName,
    required List<int> bytes,
  }) async {
    final accessToken = await MicrosoftAuthService.instance.ensureAccessToken();
    final path = '/me/drive/root:/Apps/AuraBeast/$fileName:/content';
    final uri = Uri.parse('${MicrosoftConfig.graphBaseUrl}$path');
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': _contentTypeFor(fileName),
      },
      body: bytes,
    );

    if (response.statusCode >= 400) {
      throw GraphHttpException(response.statusCode, response.body);
    }

    final item = jsonDecode(response.body) as Map<String, dynamic>;
    return DriveItemModel.fromJson(item, parentPath: MicrosoftConfig.appFolderPath);
  }

  Future<void> deleteFile(String fileId) async {
    final accessToken = await MicrosoftAuthService.instance.ensureAccessToken();
    final uri = Uri.parse('${MicrosoftConfig.graphBaseUrl}/me/drive/items/$fileId');
    final response = await http.delete(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 400) {
      throw GraphHttpException(response.statusCode, response.body);
    }
  }

  Future<Uint8List> downloadFile(String fileId) async {
    final accessToken = await MicrosoftAuthService.instance.ensureAccessToken();
    final uri = Uri.parse('${MicrosoftConfig.graphBaseUrl}/me/drive/items/$fileId/content');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 400) {
      throw GraphHttpException(response.statusCode, response.body);
    }

    return response.bodyBytes;
  }

  Future<Uri> streamUrlForDownload(String fileId) async {
    return Uri.parse('${MicrosoftConfig.graphBaseUrl}/me/drive/items/$fileId/content');
  }

  String _contentTypeFor(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.mp3')) return 'audio/mpeg';
    if (lower.endsWith('.m4a')) return 'audio/mp4';
    if (lower.endsWith('.wav')) return 'audio/wav';
    if (lower.endsWith('.flac')) return 'audio/flac';
    if (lower.endsWith('.aac')) return 'audio/aac';
    return 'application/octet-stream';
  }

  Future<Map<String, dynamic>> _getJson(String path, {required String query}) async {
    final accessToken = await MicrosoftAuthService.instance.ensureAccessToken();
    final uri = Uri.parse('${MicrosoftConfig.graphBaseUrl}$path').replace(
      queryParameters: <String, String>{'\$select': query.replaceFirst('select=', '')},
    );
    final response = await _client.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GraphHttpException(response.statusCode, response.body);
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return <String, dynamic>{};
  }

  Future<Map<String, dynamic>> _putJson(
    String path, {
    required Map<String, dynamic> body,
    required String query,
  }) async {
    final accessToken = await MicrosoftAuthService.instance.ensureAccessToken();
    final uri = Uri.parse('${MicrosoftConfig.graphBaseUrl}$path').replace(
      queryParameters: <String, String>{'\$select': query.replaceFirst('select=', '')},
    );
    final response = await _client.put(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GraphHttpException(response.statusCode, response.body);
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class GraphHttpException implements Exception {
  const GraphHttpException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'Graph request failed with status $statusCode: $body';
}
