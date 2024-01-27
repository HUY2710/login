class ValidHelper {
  ValidHelper._();

  static bool containsSpecialCharacters(String input) {
    // Sử dụng biểu thức chính quy để kiểm tra chuỗi không chứa ký tự đặc biệt
    return RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(input);
  }

  static String removeExtraSpaces(String input) {
    // Sử dụng biểu thức chính quy để giữ lại một khoảng trắng duy nhất giữa các từ
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
