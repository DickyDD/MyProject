String? validateNilai(String value) {
  var val = int.tryParse(value);
  if (value.isEmpty) {
    return "Tidak Boleh Kosong";
  } else if (val! > 100) {
    return "Nilai tidak boleh lebih dari 100";
  }
  return null;
}
