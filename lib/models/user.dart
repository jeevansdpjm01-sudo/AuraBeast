class User {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;

  User({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  factory User.fromIdToken(Map<String, dynamic> payload) {
    return User(
      id: payload['oid'] ?? payload['sub'] ?? '',
      displayName: payload['name'] ?? '',
      email: payload['preferred_username'] ?? payload['email'] ?? '',
      photoUrl: payload['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}