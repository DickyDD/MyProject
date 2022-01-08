import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/model/dataDiri.dart';

class BiodataSiswaController extends GetxController {
  final Map arguments = Get.arguments;
  var no = 0;

  var noUmum = 0;
  var adaDataBiodata = 0;
  late String tahunAjaran = '2021-2022',
      jurusan = 'Bisnis Konstruksi dan Property',
      semester = 'semester 2',
      kelas = 'kelas X BKP 1',
      nip = '23423 452643 5 646',
      guru = 'Dicky1';
  final users = FirebaseFirestore.instance;
  final onChange = false.obs;

  final pertanyaan = [
    'Nama Peserta Didik (Lengkap)',
    'Nomor Induk',
    'Tempat Tanggal Lahir',
    'Jenis Kelamin',
    'Agama',
    'Status dalam Keluarga',
    'Anak ke',
    'Alamat Peserta Didik',
    'Nomor Telepon Rumah',
    'Sekolah Asal',
    '',
    '',
    '',
    '',
    'Nama Wali Peserta Didik',
    '',
    'Pekerjaan Wali  Peserta Didik',
  ];
  final pertanyaan2 = [
    DatanyaDua(
      pertanyaan: 'Diterima di sekolah ini',
      subPertanyaan1: 'Di kelas',
      subPertanyaan2: 'Pada tanggal',
    ),
    DatanyaDua(
      pertanyaan: 'Nama Orang Tua',
      subPertanyaan1: 'a. Ayah',
      subPertanyaan2: 'b. Ibu',
    ),
    DatanyaDua(
      pertanyaan: 'Pekerjaan Orang Tua',
      subPertanyaan1: 'a. Ayah',
      subPertanyaan2: 'b. Ibu',
    ),
  ];

  final petanyaan1 = [
    DatanyaSatu(
      pertanyaan: 'Alamat Orang Tua',
      subPertanyaan1: 'Nomor Telepon Rumah',
    ),
    DatanyaSatu(
      pertanyaan: 'Alamat Wali Peserta Didik',
      subPertanyaan1: 'Nomor Telpon Rumah',
    ),
    // DatanyaSatu(pertanyaan: '', subPertanyaan1: 'subPertanyaan1'),
  ];

  late List jawaban = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  final indexDataSiswa = SiswaData(
    '213321',
    'diki',
    '12313',
    [''],
  ).obs;

  final onloading = false.obs;
  late Rx<List<SiswaData>> dataSiswa = Rx(<SiswaData>[]);
  Future getDataSiswa() async {
    onloading.value = !onloading.value;
    await users
        .collection(tahunAjaran)
        .doc(jurusan)
        .collection(semester)
        .doc(kelas)
        .collection('Siswa')
        .orderBy('nama', descending: false)
        .get()
        .then(
          (value) => dataSiswa.value = value.docs.map((e) {
            var biodata = e.data()['Bioadata'] ?? jawaban;
            // //
            // if (biodata != null) {
            //   jawaban = biodata as List<String>;

            // }
            return SiswaData(
              e.id,
              e.data()['nama'],
              e.data()['nis'],
              biodata,
            );
          }).toList(),
        )
        .whenComplete(() => onloading.value = !onloading.value);
  }

  Future<void> inputDataSiswa() async {
    await users
        .collection(tahunAjaran)
        .doc(jurusan)
        .collection(semester)
        .doc(kelas)
        .collection("Siswa")
        .doc(indexDataSiswa.value.id)
        .update(
      {
        "Bioadata": jawaban,
      },
    )
        // .then((_) async {})
        .whenComplete(() {
      Get.defaultDialog(
        title: 'Berhasil',
        middleText: 'Nilai Berhasil Di Simpan',
      );
    });
  }

  void dropdownBerubah(SiswaData data) {
    onChange.value = true;
    jawaban = data.biodata!;
    jawaban[0] = data.nama!;
    jawaban[1] = data.nis!;
    onChange.value = false;
  }

  @override
  void onInit() async {
    if (Get.arguments != null) {
      tahunAjaran = arguments['tahun'];
      jurusan = arguments['jurusan'];
      semester = arguments['semester'];
      kelas = arguments['kelas'];
      guru = arguments['guru'];
      nip = arguments['nip'];
      // 'tahun': controller.tahunAjaran,
      //                   'jurusan': controller.jurusan,
      //                   'semester': controller.semester,
      //                   'kelas': controller.kelas,
      //                   'guru': controller.guru,
      //                   'nip': controller.nip,
      await getDataSiswa();
      dataSiswa.value.sort((a, b) => a.nama!.compareTo(b.nama!));
      indexDataSiswa.value = dataSiswa.value.first;
      dropdownBerubah(indexDataSiswa.value);
    } else {
      Get.offAllNamed('/');
    }

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

class SiswaData {
  final String? id;
  final String? nama;
  final String? nis;
  final List<dynamic>? biodata;

  SiswaData(
    this.id,
    this.nama,
    this.nis,
    this.biodata,
  );
}
