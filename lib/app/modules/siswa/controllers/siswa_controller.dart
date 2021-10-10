import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SiswaController extends GetxController {
  final Map data = Get.arguments;

  late int jumlah;

  late String tahunAjaran, jurusan, semester, kelas, guru;

  final users = FirebaseFirestore.instance;

  final List<DataSiswa> listDataSiswa = [];

  final List<Map> siswa = [];

  late List<TextEditingController> name = [];
  late List<TextEditingController> id = [];
  late List<TextEditingController> noOrtu = [];
  late List<Rx<File>> images = [];
  final ImagePicker _picker = ImagePicker();

  void getImages(Rx<File?> index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    index.value = File(image!.path);
  }

  Future<void> getData() async {
    for (var i = 0; i < jumlah; i++) {
      listDataSiswa.add(DataSiswa(
        noOrtu[i].text,
        name[i].text,
        id[i].text,
        images[i].value,
      ));
    }
    listDataSiswa.forEach((element) async {
      String imageUrl = '';

      try {
        await FirebaseStorage.instance
            .ref('foto_siswa/${element.nama}')
            .putFile(element.image)
            .then((val) async {
          imageUrl = await val.ref.getDownloadURL();
        });
      } on FirebaseException catch (e) {
        print(e.message);
      }
      siswa.add(
        {
          'nama': element.nama,
          'id': element.id,
          'noOrtu': element.noOrtu,
          'imageUrl': imageUrl,
        },
      );
    });
    // print(siswa);
    tesInput(tahunAjaran, jurusan, semester, kelas, guru);
  }

  Future tesInput(String tahunAjaran, String jurusan, String semester,
      String kelas, String guru) async {
    await users
        .collection(tahunAjaran)
        .doc(jurusan)
        .collection(kelas)
        .doc(semester)
        .set({
      'Wali kelas': {'nama': guru},
      'Siswa': siswa
    });
  }

  @override
  void dispose() {
    name.forEach((c) => c.dispose());
    id.forEach((c) => c.dispose());
    noOrtu.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  void onInit() {
    jumlah = int.parse(data['jumlah']);
    tahunAjaran = data['tahunAjaran'];
    jurusan = data['jurusan'];
    semester = data['semester'];
    kelas = data['kelas'];
    guru = data['guru'];

    name = List.generate(jumlah, (i) => TextEditingController());
    id = List.generate(jumlah, (i) => TextEditingController());
    noOrtu = List.generate(jumlah, (i) => TextEditingController());
    images = List.generate(jumlah, (i) => Rx(File('')));

    super.onInit();
  }
}

class DataSiswa {
  final String noOrtu;
  final String nama;
  final String id;
  final File image;

  DataSiswa(
    this.noOrtu,
    this.nama,
    this.id,
    this.image,
  );
}
