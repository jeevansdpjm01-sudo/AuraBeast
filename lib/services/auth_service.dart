import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aurabeast/models/user.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  final FlutterAppAuth _appAuth = FlutterAppAuth();
  SharedPreferences? _prefs;
  User? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  static const String _clientId = 'YOUR_CLIENT_ID_HERE'; // Set from Azure AD
  static const String _redirectUrl = 'com.example.aurabeast:/oauthredirect';
  static const String _scopes = 'Files.ReadWrite.All offline_access openid profile';
  static const String _authorizationEndpoint = 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize';
  static const String _tokenEndpoint = 'https://login.microsoftonline.com/common/oauth2/v2.0/token';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    final tokenJson = _prefs?.getString('token_data');
    if (tokenJson != null) {
      final map = jsonDecode(tokenJson);
      _accessToken = map['accessToken'];
      _refreshToken = map['refreshToken'];
      if (map.containsKey('expiry')) {
        _tokenExpiry = DateTime.parse(map['expiry']);
      }
      final userMap = map['user'];
      if (userMap != null) {
        _currentUser = User.fromJson(userMap);
      }
    }
  }

  Future<void> _saveTokenToStorage() async {
    await _prefs?.setString('token_data', jsonEncode({
      'accessToken': _accessToken,
      'refreshToken': _refreshToken,
      'expiry': _tokenExpiry?.toIso8601String(),
      'user': _currentUser?.toJson(),
    }));
  }

  Future<User?> signIn() async {
    final result = await _appAuth.authorizeAndExchangeToken(
      AuthorizationTokenRequest(
        _clientId,
        _redirectUrl,
        scopes: _scopes.split(' '),
        // For Azure AD v2 endpoint
        serviceConfiguration: const ServiceConfiguration(
          authorizationEndpoint: _authorizationEndpoint,
          tokenEndpoint: _tokenEndpoint,
        ),
        // Prompt for account selection each time to avoid shared account
        promptLogin: true,
      ),
    );

    if (result == null) return null;

    _accessToken = result.accessToken;
    _refreshToken = result.refreshToken;
    _tokenExpiry = DateTime.now().add(result.expiresIn ?? const Duration(hours: 1));

    // Optionally decode id token to get user info
    if (result.idToken != null) {
      final payload = result.idToken!.split('.')[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded);
      _currentUser = User.fromIdToken(map);
    } else {
      // Fallback: use minimal info
      _currentUser = User(
        id: '',
        displayName: 'Microsoft User',
        email: '',
        photoUrl: '',
      );
    }

    await _saveTokenToStorage();
    return _currentUser;
  }

  Future<void> signOut() async {
    await _appAuth.dismiss();
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    _currentUser = null;
    await _prefs?.remove('token_data');
  }

  bool get isAuthenticated => _accessToken != null && (_tokenExpiry?.isAfter(DateTime.now()) ?? false);

  String? get accessToken => _accessToken;
  User? get currentUser => _currentUser;

  Future<void> refreshTokenIfNeeded() async {
    if (!isAuthenticated) return;
    if (DateTime.now().isAfter(_tokenExpiry!.subtract(const Duration(minutes: 5)))) {
      // Attempt refresh
      final result = await _appAuth.authorizeAndExchangeToken(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          scopes: _scopes.split(' '),
          serviceConfiguration: const ServiceConfiguration(
            authorizationEndpoint: _authorizationEndpoint,
            tokenEndpoint: _tokenEndpoint,
          ),
          refreshToken: _refreshToken,
        ),
      );
      if (result != null) {
        _accessToken = result.accessToken;
        _refreshToken = result.refreshToken ?? _refreshToken;
        _tokenExpiry = DateTime.now().add(result.expiresIn ?? const Duration(hours: 1));
        await _saveTokenToStorage();
      } else {
        // Refresh failed, force re-login
        await signOut();
      }
    }
  }
}