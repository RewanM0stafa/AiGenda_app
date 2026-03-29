class ApiKeys {
  // Response Keys
  static const String id = "id"; //  confirm change email send( id + newemail + code)
  static const String firstName = 'firstName';
  // auth files
  static const String lastName = 'lastName';
  static const String secondName = "secondName";
  static const String email = 'email';
  static const String token = 'token';
  static const String refreshToken = "refreshToken";
  static const String expiredIn = "expiredIn";
  static const String expiryDate = "expiryDate";
  static const String message = "message";

  // Backward compatibility لو عندك ملفات قديمة بتستخدم lastName

  // Request Keys
  static const String userId = "userId"; //  confirm email send(userId + code)
  static const String code = "code";

  static const String password = 'password';
  static const String confirmPassword = "confirmPassword";

  static const String currentPassword = "currentPassword";
  static const String newPassword = "newPassword";

  static const String newEmail = "newemail";
  static const String confirmEmailId = "id";

  static const String jobTitle = "jobTitle";
  static const String dateOfBirth = "dateOfBirth";

  static const String avatarUrl = "avatarUrl";

  // workspace
  //static const id = "id";
  static const name = "name";
  static const description = "description";
  static const iconCode = "iconCode";
  static const visibility = "visibility";
  static const numberOfMembers = "numberofMembers";
  static const numberOfTasks = "numberofTasks";
  static const isOwnedByCurrentUser = "isOwnedByCurrentUser";

  // member
  static const fullName = "fullName";
  static const isOwner = "isOwner";
  static const joinedAt = "joinedAt";
  static const permissions = "permissions";

  }