import 'user_profile.dart';

class AuthResponse {
  AuthResponse({
    required this.userId,
    required this.token,
    required this.profile,
  });

  final String userId;
  final String token;
  final UserProfile profile;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] as String,
      token: json['token'] as String,
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
    );
  }
}
