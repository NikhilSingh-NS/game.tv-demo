class UserLogInValidation {
  //returning dummy user id if valid else -1...
  int checkUserInfo(String phoneNumber, String password) {
    switch (phoneNumber) {
      case '9898989898':
        return "password123".compareTo(password) == 0 ? 1 : -1;
      case '9876543210':
        return "password123".compareTo(password) == 0 ? 2 : -1;
      default:
        return -1;
    }
  }
}
