String? validatePassword(String value) {
  if (value.length != 5 && value.isNotEmpty) {
    return "Password harus lebih dari 5 characters";
  }
  return null;
}
