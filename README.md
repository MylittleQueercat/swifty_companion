# Swifty Companion

A 42 school project: a mobile app to search 42 students by login and view their public profile information, using the 42 API and OAuth2.

## Features

- **Search screen**: enter a 42 login to look up a student.
- **Profile screen**: displays login, email, phone, level, location, wallet, correction points, avatar, skills (with level and percentage), and completed/failed projects.
- **Error handling**: shows a clear message when a login doesn't exist or a network error occurs.
- **OAuth2 (intra)**: uses the `client_credentials` grant. The access token is cached in memory and automatically refreshed once expired — no new token is requested on every API call.

## Tech stack

- **Framework**: Flutter (Dart)
- **HTTP**: `http` package
- **OAuth2**: `oauth2` / manual `client_credentials` flow against `https://api.intra.42.fr/oauth/token`
- **Target platform**: Android

## Project structure

lib/
├── config.dart # API credentials (gitignored, see setup below)
├── config.example.dart # Template for config.dart
├── main.dart # App entry point
├── models/
│ └── user_model.dart # UserModel, SkillModel, ProjectModel + JSON parsing
├── screens/
│ ├── search_screen.dart # First view: login search
│ └── profile_screen.dart # Second view: user details
└── services/
├── auth_service.dart # OAuth2 token fetching & caching
└── api_service.dart # 42 API calls (fetch user by login)


## Setup

### 1. Register a 42 API application

1. Go to `https://profile.intra.42.fr/oauth/applications`
2. Click **New application**
3. Fill in a name, description, and a placeholder redirect URI (e.g. `swiftycompanion://callback`)
4. Scope: only **Access the user public data**
5. Copy the generated **UID** and **SECRET**

### 2. Configure credentials

Copy the template and fill in your own credentials:

```bash
cp lib/config.example.dart lib/config.dart
```

Edit `lib/config.dart`:

```dart
class Config {
  static const String clientId = "YOUR_42_API_UID";
  static const String clientSecret = "YOUR_42_API_SECRET";
  static const String redirectUri = "swiftycompanion://callback";
}
```

`lib/config.dart` is gitignored and must never be committed.

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run

Connect an Android device (USB debugging enabled) or start an emulator, then:

```bash
flutter run
```

## Notes for evaluation

- The `phone` field is often returned as the literal string `"hidden"` by the 42 API due to privacy rules — this is expected behavior, not a bug, and is displayed as "N/A" in the app.
- The main cursus (skills/level) is selected by matching `cursus.kind == "main"` (i.e. `42cursus`), not simply the last entry in `cursus_users`, since users may also have Piscine or external cursus entries.
- Token caching/refresh logic is in `lib/services/auth_service.dart` — `getAccessToken()` checks expiry before deciding whether to reuse the cached token or fetch a new one.
