String? validatePassword(String value) {
  if (value.isEmpty) {
    return "Password tidak boleh kosong";
  } else if (!(value.length > 5)) {
    return "Password harus lebih dari 5 characters";
  }
  return null;
}

String? validateUser(String value) {
  if (value.isEmpty) {
    return "NIP tidak boleh kosong";
  } else if (!(value.length > 5)) {
    return "NIP harus lebih dari 5 characters";
  }
  return null;
}
