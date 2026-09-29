class MicrosoftConfig {
  /// Tenant ID for the Microsoft Entra app registration.
  /// Use a specific tenant GUID in production, not the public "common" tenant
  /// unless you intentionally want multi-tenant sign-in.
  static const String tenantId = String.fromEnvironment(
    'AURABEAST_TENANT_ID',
    defaultValue: 'common',
  );

  /// Client ID from the Microsoft Entra app registration.
  static const String clientId = String.fromEnvironment(
    'AURABEAST_CLIENT_ID',
    defaultValue: 'REPLACE_WITH_APP_REGISTRATION_CLIENT_ID',
  );

  /// Redirect URI configured in the Microsoft Entra app registration.
  /// Example: com.aurabeast.app://oauth/callback
  static const String redirectUri = String.fromEnvironment(
    'AURABEAST_REDIRECT_URI',
    defaultValue: 'com.aurabeast.app://oauth/callback',
  );

  /// Least-privilege Graph scopes for this app.
  static const List<String> scopes = <String>[
    'User.Read',
    'Files.ReadWrite',
    'Files.ReadWrite.All',
    'offline_access',
  ];

  /// OneDrive folder dedicated to this app. Each user gets their own OneDrive account.
  static const String appFolderPath = '/Apps/AuraBeast';

  static const String graphBaseUrl = 'https://graph.microsoft.com/v1.0';

  static bool get isConfigured =>
      clientId != 'REPLACE_WITH_APP_REGISTRATION_CLIENT_ID' &&
      clientId.trim().isNotEmpty;
}
