import 'user_profile.dart';

class MatchModel {
  MatchModel({
    required this.matchId,
    required this.user,
    required this.matchedWith,
    required this.matchedAt,
  });

  final String matchId;
  final UserProfile user;
  final UserProfile matchedWith;
  final DateTime matchedAt;

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['matchId'] as String,
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      matchedWith: UserProfile.fromJson(json['matchedWith'] as Map<String, dynamic>),
      matchedAt: DateTime.parse(json['matchedAt'] as String),
    );
  }
}
