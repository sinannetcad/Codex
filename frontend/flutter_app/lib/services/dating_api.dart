import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_response.dart';
import '../models/match.dart';
import '../models/swipe_result.dart';
import '../models/user_profile.dart';

class DatingApi {
  DatingApi({required this.baseUrl});

  final String baseUrl;

  Future<AuthResponse> register({
    required String name,
    required int age,
    required String bio,
    required String avatarUrl,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'age': age,
        'bio': bio,
        'avatarUrl': avatarUrl,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Register failed: ${response.body}');
    }

    return AuthResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Login failed');
    }

    return AuthResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<UserProfile>> fetchProfiles(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/profiles?userId=$userId'),
    );

    if (response.statusCode >= 400) {
      throw Exception('Profiles failed');
    }

    final payload = jsonDecode(response.body) as List<dynamic>;
    return payload
        .map((item) => UserProfile.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<SwipeResult> swipe({
    required String fromUserId,
    required String toUserId,
    required bool liked,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/swipes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'liked': liked,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Swipe failed');
    }

    return SwipeResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<MatchModel>> fetchMatches(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/matches?userId=$userId'),
    );

    if (response.statusCode >= 400) {
      throw Exception('Matches failed');
    }

    final payload = jsonDecode(response.body) as List<dynamic>;
    return payload
        .map((item) => MatchModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
