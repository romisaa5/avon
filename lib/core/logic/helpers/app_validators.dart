import 'app_regex.dart';

class AppValidators {
  /// Name
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  /// Email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!AppRegex.isEmailValid(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  /// Phone
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    if (!AppRegex.isPhoneNumberValid(value)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  /// Password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (!AppRegex.hasMinLength(value)) {
      return 'Must be at least 8 characters';
    }

    if (!AppRegex.hasUpperCase(value)) {
      return 'Must contain uppercase letter';
    }

    if (!AppRegex.hasLowerCase(value)) {
      return 'Must contain lowercase letter';
    }

    if (!AppRegex.hasNumber(value)) {
      return 'Must contain a number';
    }

    if (!AppRegex.hasSpecialCharacter(value)) {
      return 'Must contain special character';
    }

    return null;
  }

  /// Confirm Password
  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }
}
