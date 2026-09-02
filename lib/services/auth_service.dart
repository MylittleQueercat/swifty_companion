import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class AuthService {
  static const String _tokenUrl = 'https://api.intra.42.fr/oauth/token';

  String? _accessToken;
  DateTime? _expiresAt;

  Future<String> getAccessToken() async {
    if (_accessToken != null &&
        _expiresAt != null &&
        DateTime.now().isBefore(_expiresAt!)) {
      return _accessToken!;
    }
    return _fetchNewToken();
  }

  Future<String> _fetchNewToken() async {
    final response = await http.post(
      Uri.parse(_tokenUrl),
      body: {
        'grant_type': 'client_credentials',
        'client_id': Config.clientId,
        'client_secret': Config.clientSecret,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to obtain access token: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    _accessToken = data['access_token'] as String;
    final expiresIn = data['expires_in'] as int? ?? 7200;
    _expiresAt = DateTime.now().add(Duration(seconds: expiresIn - 60));

    return _accessToken!;
  }
}
