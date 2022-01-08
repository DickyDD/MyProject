// ignore_for_file: public_member_api_docs, sort_constructors_first

class DataDiri {
  final List<String> pertanyaan;
  final List<String> jawaban;
  final List<DatanyaDua> pertanyaan1;
  final List<DatanyaSatu> pertanyaan2;
  final List<DatanyaDua> jawaban1;
  final List<DatanyaSatu> jawaban2;
  final String tanggal;
  final String namaKepalaSekolah;
  final String nip;
  final String jawaban15;
  final String jawaban17;
  // final String nip;
  const DataDiri({
    required this.jawaban,
    required this.jawaban1,
    required this.jawaban2,
    required this.pertanyaan,
    required this.pertanyaan1,
    required this.pertanyaan2,
    required this.tanggal,
    required this.namaKepalaSekolah,
    required this.nip,
    required this.jawaban15,
    required this.jawaban17,
  });
}

class DatanyaDua {
  final String pertanyaan;
  final String subPertanyaan1;
  final String subPertanyaan2;
  DatanyaDua({
    required this.pertanyaan,
    required this.subPertanyaan1,
    required this.subPertanyaan2,
  });
}

class DatanyaSatu {
  final String pertanyaan;
  final String subPertanyaan1;
  DatanyaSatu({
    required this.pertanyaan,
    required this.subPertanyaan1,
  });
}
