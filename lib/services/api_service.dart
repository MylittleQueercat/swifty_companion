import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/user_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.intra.42.fr/v2';
  final AuthService _authService = AuthService();

  Future<UserModel> fetchUser(String login) async {
    final token = await _authService.getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/users/$login'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 404) {
      throw UserNotFoundException(login);
    }

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}

class UserNotFoundException implements Exception {
  final String login;
  UserNotFoundException(this.login);

  @override
  String toString() => 'User "$login" not found';
}
