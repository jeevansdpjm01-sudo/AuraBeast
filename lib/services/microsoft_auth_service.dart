import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/microsoft_config.dart';

class MicrosoftAuthService {
  MicrosoftAuthService._();

  static final MicrosoftAuthService instance = MicrosoftAuthService._();

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static const String _accessTokenKey = 'aurabeast_ms_access_token';
  static const String _refreshTokenKey = 'aurabeast_ms_refresh_token';
  static const String _idTokenKey = 'aurabeast_ms_id_token';
  static const String _userIdKey = 'aurabeast_ms_user_id';
  static const String _userEmailKey = 'aurabeast_ms_user_email';

  String? _accessToken;
  DateTime? _accessTokenExpiry;

  Future<bool> get isSignedIn async =>
      (await _secureStorage.read(key: _accessTokenKey)) != null;

  Future<void> signIn() async {
    if (!MicrosoftConfig.isConfigured) {
      throw StateError(
        'Microsoft App Registration is not configured. Set the AURABEAST_CLIENT_ID and redirect URI values first.',
      );
    }

    final request = AuthorizationTokenRequest(
      MicrosoftConfig.clientId,
      MicrosoftConfig.redirectUri,
      serviceConfiguration: const AuthorizationServiceConfiguration(
        authorizationEndpoint:
            'https://login.microsoftonline.com/${MicrosoftConfig.tenantId}/oauth2/v2.0/authorize',
        tokenEndpoint:
            'https://login.microsoftonline.com/${MicrosoftConfig.tenantId}/oauth2/v2.0/token',
      ),
      scopes: MicrosoftConfig.scopes,
      additionalParameters: <String, String>{
        'prompt': 'select_account',
      },
    );

    final result = await _appAuth.authorizeAndExchangeCode(request);
    final accessToken = result?.accessToken ?? '';
    if (accessToken.isEmpty) {
      throw StateError('Microsoft sign-in was cancelled or failed.');
    }

    await _storeTokens(result!);
  }

  Future<void> signOut() async {
    await _secureStorage.deleteAll();
    _accessToken = null;
    _accessTokenExpiry = null;
  }

  Future<String> ensureAccessToken() async {
    if (_accessToken != null && _accessTokenExpiry != null && !_tokenExpired(_accessToken!)) {
      return _accessToken!;
    }

    final storedToken = await _secureStorage.read(key: _accessTokenKey);
    if (storedToken != null && !_tokenExpired(storedToken)) {
      _accessToken = storedToken;
      return storedToken;
    }

    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      await signIn();
      return (await _secureStorage.read(key: _accessTokenKey)) ?? '';
    }

    final tokenRequest = TokenRequest(
      MicrosoftConfig.clientId,
      MicrosoftConfig.redirectUri,
      refreshToken: refreshToken,
      serviceConfiguration: const AuthorizationServiceConfiguration(
        authorizationEndpoint:
            'https://login.microsoftonline.com/${MicrosoftConfig.tenantId}/oauth2/v2.0/authorize',
        tokenEndpoint:
            'https://login.microsoftonline.com/${MicrosoftConfig.tenantId}/oauth2/v2.0/token',
      ),
      scopes: MicrosoftConfig.scopes,
    );

    final refreshed = await _appAuth.token(tokenRequest);
    if (refreshed == null || refreshed.accessToken == null || refreshed.accessToken!.isEmpty) {
      throw StateError('Unable to refresh Microsoft access token. Please sign in again.');
    }

    await _storeTokens(refreshed);
    return refreshed.accessToken!;
  }

  Future<void> _storeTokens(TokenResponse response) async {
    final accessToken = response.accessToken ?? '';
    final refreshToken = response.refreshToken;
    final idToken = response.idToken;

    if (accessToken.isEmpty) {
      throw StateError('Microsoft access token was missing from the authentication response.');
    }

    _accessToken = accessToken;
    _accessTokenExpiry = _expiryFromJwt(accessToken);

    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
    if (idToken != null && idToken.isNotEmpty) {
      await _secureStorage.write(key: _idTokenKey, value: idToken);
    }

    final claims = _decodeJwtPayload(accessToken);
    final userId = claims['oid'] ?? claims['sub'];
    final email = claims['preferred_username'] ?? claims['email'];
    if (userId != null) {
      await _secureStorage.write(key: _userIdKey, value: userId.toString());
    }
    if (email != null) {
      await _secureStorage.write(key: _userEmailKey, value: email.toString());
    }
  }

  bool _tokenExpired(String token) {
    final expiry = _expiryFromJwt(token);
    if (expiry == null) {
      return false;
    }
    return DateTime.now().isAfter(expiry.subtract(const Duration(minutes: 2)));
  }

  DateTime? _expiryFromJwt(String token) {
    final claims = _decodeJwtPayload(token);
    final exp = claims['exp'];
    if (exp is int) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true).toLocal();
    }
    return null;
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length < 2) {
      return <String, dynamic>{};
    }

    try {
      final normalized = parts[1].padRight(
        parts[1].length + ((4 - parts[1].length % 4) % 4),
        '=',
      );
      final body = utf8.decode(base64Url.decode(normalized));
      return Map<String, dynamic>.from(jsonDecode(body) as Map<String, dynamic>);
    } on Exception {
      if (kDebugMode) {
        debugPrint('Could not decode JWT payload for Microsoft token.');
      }
      return <String, dynamic>{};
    }
  }
}
