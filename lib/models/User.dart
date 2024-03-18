import 'dart:convert';

class User {
  int userId;
  String username;
  String passwordHash;
  String fullName;
  String profilePicture;
  DateTime birthDate;
  String phoneNumber;
  String address;

  User(this.userId, this.username, this.passwordHash, this.fullName,
      this.profilePicture, this.birthDate, this.phoneNumber, this.address);

  // Convert User object to a Map for serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'passwordHash': passwordHash,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'birthDate': birthDate.toIso8601String(),
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  // Factory method to create User object from a Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['userId'],
      json['username'],
      json['passwordHash'],
      json['fullName'],
      json['profilePicture'],
      DateTime.parse(json['birthDate']),
      json['phoneNumber'],
      json['address'],
    );
  }

  // Static method to convert JSON string to User object
  static User fromJsonToUser(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return User.fromJson(json);
  }

  // Static method to convert User object to JSON string
  static String toJsonString(User user) {
    return jsonEncode(user.toJson());
  }

  @override
  String toString() {
    return 'User{userId: $userId, username: $username, passwordHash: $passwordHash, fullName: $fullName, profilePicture: $profilePicture, birthDate: $birthDate, phoneNumber: $phoneNumber, address: $address}';
  }
}
