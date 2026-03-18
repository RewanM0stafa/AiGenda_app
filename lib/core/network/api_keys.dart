// constant Fields

class ApiKeys {
  // ── Response Keys (من السيرفر) ──
  static const String id = "id";
  static const String firstName = 'firstName';
  static const String secondName = "secondName";
  static const String email = 'email';
  static const String token = 'token';
  static const String refreshToken = "refreshToken";
  static const String expiredIn = "expiredIn";
  static const String expiryDate = "expiryDate";
  static const String message = "message";

  // ── Request Keys (للسيرفر) ──
  static const String userId = "userId";      // ← للـ confirmEmail request
  static const String code = "code";
  static const String password = 'password';
  static const String confirmPassword = "confirmPassword";
  static const String newPassword = "newpassword"; // ← lowercase كما في الـ API
  static const String lastName = "lastName";
}