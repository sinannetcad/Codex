class UserProfile {
  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.avatarUrl,
    required this.city,
    required this.interests,
  });

  final String id;
  final String name;
  final int age;
  final String bio;
  final String avatarUrl;
  final String city;
  final List<String> interests;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      bio: json['bio'] as String,
      avatarUrl: json['avatarUrl'] as String,
      city: json['city'] as String,
      interests: List<String>.from(json['interests'] as List<dynamic>),
    );
  }
}
