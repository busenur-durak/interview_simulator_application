class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final bool isGuest;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.isGuest,
  });

  factory UserModel.guest() {
    return const UserModel(
      uid: 'guest',
      email: '',
      displayName: 'Guest',
      isGuest: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'isGuest': isGuest,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      isGuest: map['isGuest'] as bool,
    );
  }
}
