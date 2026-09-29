# AuraBeast Microsoft / OneDrive architecture

This app is designed so each user signs in with their own Microsoft account and keeps uploads in their own OneDrive storage. A single shared account is never used.

## 1. Microsoft Entra / App Registration setup

1. Open Microsoft Entra admin center.
2. Go to App registrations > New registration.
3. Set the app name to `AuraBeast`.
4. Choose: `Accounts in this organizational directory only` for a company-only app, or `Multitenant` if you want multiple organizations.
5. Save the application.
6. Copy the Application (client) ID.
7. In Authentication, add a mobile redirect URI such as:
   - `com.aurabeast.app://oauth/callback`
8. Enable public client/native flows if needed for mobile apps.
9. Under API permissions, add the least-privilege Graph permissions listed below.

## 2. Required Microsoft Graph permissions

Recommended minimum for a music/file app:

- `User.Read`
- `Files.ReadWrite`
- `Files.ReadWrite.All`
- `offline_access`

Use least privilege. Do not request broad permissions like `Directory.Read.All` or app-only access unless you absolutely need them for a server backend. For this app, user-delegated access is the correct pattern.

## 3. Redirect URI configuration

Set the redirect URI in both the app registration and the Flutter app config:

- Android and iOS native app: `com.aurabeast.app://oauth/callback`
- Android manifest / iOS URL schemes must match exactly.

Do not hardcode secrets or access tokens in the app source.

## 4. Flutter package dependencies

Add the following dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter_appauth: ^8.0.0
  flutter_secure_storage: ^9.2.2
  http: ^1.2.2
  connectivity_plus: ^6.1.0
  just_audio: ^0.10.4
```

## 5. Android configuration

1. Add the custom scheme to `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW"/>
  <category android:name="android.intent.category.DEFAULT"/>
  <category android:name="android.intent.category.BROWSABLE"/>
  <data android:scheme="com.aurabeast.app" android:host="oauth" android:path="/callback"/>
</intent-filter>
```

2. Ensure the app uses HTTPS or valid native redirect configuration for app auth.
3. Set the client ID in `AURABEAST_CLIENT_ID` or a secure config loader.

## 6. iOS configuration

1. Add the URL scheme to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>com.aurabeast.app</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.aurabeast.app</string>
    </array>
  </dict>
</array>
```

2. Configure the same redirect URI in the Microsoft app registration.

## 7. How to configure the client ID

Use environment variables or a config file instead of storing it in code:

```dart
static const String clientId = String.fromEnvironment(
  'AURABEAST_CLIENT_ID',
  defaultValue: 'REPLACE_WITH_APP_REGISTRATION_CLIENT_ID',
);
```

Pass it when running the app:

```bash
flutter run --dart-define=AURABEAST_CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

## 8. How to sign in

1. Call `MicrosoftAuthService.instance.signIn()`.
2. The app opens Microsoft sign-in.
3. Microsoft returns an access token and refresh token.
4. Tokens are stored in `flutter_secure_storage`, not in plain text logs or UI.
5. The app uses the current user's access token for all OneDrive calls.

## 9. How to upload to OneDrive

The code uses the current authenticated user's token and writes to:

```text
/Apps/AuraBeast/
```

Upload flow:

1. Ensure the `AuraBeast` folder exists.
2. Upload file bytes using Graph `PUT /me/drive/root:/Apps/AuraBeast/<filename>:/content`.
3. Save metadata only if needed.
4. Keep this folder in the current user's OneDrive only.

## 10. How to list files

Use a Graph API call like:

```text
GET /me/drive/root:/Apps/AuraBeast:/children
```

This returns only the files in the signed-in user's own storage.

## 11. How to play audio

1. List files from the user's OneDrive.
2. When the user taps a track, request a Graph content URL.
3. Open a stream URL with the `Authorization: Bearer ${token}` header.
4. Use `just_audio` to play the stream.
5. Use the app's player service for pause, seek, next, previous, shuffle, repeat, and buffering states.

Do not download the entire library permanently. Stream the selected track only when needed. This avoids unnecessary storage use and respects user data isolation.

## 12. How to test with two different Microsoft accounts

1. Register two separate Microsoft accounts (for example, user1@contoso.com and user2@contoso.com).
2. Sign in with user1 and upload one file.
3. Sign out.
4. Sign in with user2.
5. Confirm that user2 cannot see or access user1's file set.
6. Verify the list shows only what is in user2's own OneDrive.
7. Repeat upload and delete operations to confirm full user isolation.

## Safety rules

- Never use one shared Microsoft account.
- Never allow file IDs or URLs to be reused across users.
- Never log access tokens.
- Store only metadata in app databases, not the actual audio files.
- Restrict every Graph request to the currently authenticated user's account.

## Where the code lives

The implementation is split as follows:

- `lib/config/microsoft_config.dart` — app registration config and tenant settings
- `lib/services/microsoft_auth_service.dart` — OAuth and token refresh handling
- `lib/services/microsoft_graph_service.dart` — OneDrive file operations
- `lib/services/music_player_service.dart` — playback controls
- `lib/models/onedrive_item.dart` — user and OneDrive item metadata
- `lib/screens/microsoft_connect_screen.dart` — Microsoft sign-in UI

This architecture keeps authentication, Graph access, and playback isolated and user-specific.
