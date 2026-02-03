import 'user_profile.dart';

class SwipeResult {
  SwipeResult({
    required this.isMatch,
    required this.matchedProfile,
  });

  final bool isMatch;
  final UserProfile? matchedProfile;

  factory SwipeResult.fromJson(Map<String, dynamic> json) {
    return SwipeResult(
      isMatch: json['isMatch'] as bool,
      matchedProfile: json['matchedProfile'] == null
          ? null
          : UserProfile.fromJson(
              json['matchedProfile'] as Map<String, dynamic>,
            ),
    );
  }
}
