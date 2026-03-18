class AppValidators {

  static String? requiredField(String? value, {String fieldName = 'This field'}) {
    bool isRequired = (value == null || value.trim().isEmpty);
    if (isRequired) {
      return '$fieldName is required.';
    }
    return null;
  }


  static String? validateUsername(String? value) {
    bool isRequired = (value == null || value.trim().isEmpty);
    if (isRequired) {
      return 'Please enter your username.';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    bool isRequired = (value == null || value.isEmpty);

    if (isRequired) {
      return 'Please enter your email.';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 8) {
      return 'Your password must be at least 8 characters.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != original) return 'Passwords do not match.';
    return null;
  }

}
