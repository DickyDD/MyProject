import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SiswaDataController extends GetxController {
  // final Map arguments = Get.arguments;
  var no = 0;

  var noUmum = 0;
  var adaDataBiodata = 0;
  late String tahunAjaran = '2021-2022',
      jurusan = 'Bisnis Konstruksi dan Property',
      semester = 'semester 1',
      kelas = 'kelas X BKP 1',
      nip = '23423 452643 5 646',
      guru = 'Dicky1';
  final users = FirebaseFirestore.instance;

  final onloading = false.obs;

  Future getDataSiswa() async {
    onloading.value = !onloading.value;
    await users
        .collection("Siswa")
        .doc('ADRIAN MARWANTO LOLO')
        .collection('nilai')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
      });
    }).whenComplete(() => onloading.value = !onloading.value);
  }

  @override
  void onInit() async {
    await getDataSiswa();
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
