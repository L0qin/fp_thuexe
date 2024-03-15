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

  @override
  String toString() {
    return 'User{userId: $userId, username: $username, passwordHash: $passwordHash, fullName: $fullName, profilePicture: $profilePicture, birthDate: $birthDate, phoneNumber: $phoneNumber, address: $address}';
  }
}
