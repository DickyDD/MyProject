import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TesSiswaController extends GetxController {
  final Map arguments = Get.arguments;
  var no = 0;
  
  var noUmum = 0;
  late String tahunAjaran = '2021-2022',
      jurusan = 'Bisnis Konstruksi dan Property',
      semester = 'semester 2',
      kelas = 'kelas X BKP 1',
      nip = '23423 452643 5 646',
      guru = 'Dicky1';
  final users = FirebaseFirestore.instance;
  final indexDataSiswa = SiswaData(
    '213321',
    'diki',
    '12313',
    [Pelajaran("type", "name", 0, "0", "0",)],
    [Pelajaran("type", "name", 0, "0", "0", )],
    0,
  ).obs;
  final onloading = false.obs;
  late Rx<List<SiswaData>> dataSiswa = Rx(<SiswaData>[]);
  late Rx<Pelajaran> dataPelajaranaUmum =
      Rx(Pelajaran("type", "name", 0, "0", "0", ));
  late Rx<Pelajaran> dataPelajaranaKhusus =
      Rx(Pelajaran("type", "name", 0, "0", "0", ));

  final nilaiKhusus = TextEditingController();
  final keterampilanKhusus = TextEditingController();
  final nilaiUmum = TextEditingController();
  final keterampilanUmum = TextEditingController();

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
            var dataListUmum = e.data()['nilai_umum'] as List;
            // dataListKhusus.sort(
            //     (a, b) => a['nama'].toString().compareTo(b['nama'].toString()));
            var dataListKhusus = e.data()['nilai_khusus'] as List;
            var listPelajaranDataUmum = <Pelajaran>[];
            var listPelajaranDataKhusus = <Pelajaran>[];
            dataListKhusus.forEach((element) {
              var val = element as Map;

              val.forEach((key, value) {
                // var noKhusus = 0;
                // print(noKhusus++);
                listPelajaranDataKhusus.add(
                  Pelajaran(
                    key,
                    value['nama'],
                    value['kkn'],
                    value['Pengetahuan'].toString(),
                    value['Keterampilan'].toString(),
                  
                  ),
                );
              });
            });
            dataListUmum.forEach((element) {
              var val = element as Map;

              val.forEach((key, value) {
                // print(key);
                // print(value['nama']);
                listPelajaranDataUmum.add(
                  Pelajaran(
                      key,
                      value['nama'],
                      value['kkn'],
                      value['Pengetahuan'].toString(),
                      value['Keterampilan'].toString(),
                    ),
                );
              });
            });

            return SiswaData(
              e.id,
              e.data()['nama'],
              e.data()['nis'],
              listPelajaranDataKhusus,
              listPelajaranDataUmum,
              no++,
            );
          }).toList(),
        )
        .whenComplete(() => onloading.value = !onloading.value);
  }

  Future<void> inputDataSiswa() async {
    // urlsSiswa

    var listNilaiKhusus = [];
    var listNilaiUmum = [];
    indexDataSiswa.value.pelajaranUmum.forEach((element) {
      listNilaiUmum.add({
        element.type: {
          'nama': element.name,
          'kkn': element.kkn,
          'Pengetahuan': element.name == dataPelajaranaUmum.value.name
              ? nilaiUmum.text
              : element.pengetahuan,
          'Keterampilan': element.name == dataPelajaranaUmum.value.name
              ? keterampilanUmum.text
              : element.keterampilan,
        }
      });
    });

    indexDataSiswa.value.pelajaranKhusus.forEach((element) {
      listNilaiKhusus.add({
        element.type: {
          'nama': element.name,
          'kkn': element.kkn,
          'Pengetahuan': element.name == dataPelajaranaKhusus.value.name
              ? nilaiKhusus.text
              : element.pengetahuan,
          'Keterampilan': element.name == dataPelajaranaKhusus.value.name
              ? keterampilanKhusus.text
              : element.keterampilan,
        }
      });
    });

    await users
        .collection("Siswa")
        .doc(indexDataSiswa.value.nama)
        .collection('nilai')
        .doc(
            "")
        .update(
      {
        "nilai_umum": listNilaiUmum,
        "nilai_khusus": listNilaiKhusus,
      },
    );

    await users
        .collection(tahunAjaran)
        .doc(jurusan)
        .collection(semester)
        .doc(kelas)
        .collection("Siswa")
        .doc(indexDataSiswa.value.id)
        .update(
      {
        "nilai_umum": listNilaiUmum,
        "nilai_khusus": listNilaiKhusus,
      },
    ).then((_) async {
      // dataSiswa.value = [];
      await getDataSiswa().whenComplete(() {
        indexDataSiswa.value = dataSiswa.value[indexDataSiswa.value.no];
        // onChangeSiswa();
        ganti();
        onChangePelajaranKhusus();
        onChangePelajaranUmum();
      });
    }).whenComplete(() {
      Get.defaultDialog(
        title: 'Berhasil',
        middleText: 'Nilai Berhasil Di Simpan',
      );
    });
  }

  void ganti() {
   var indexUmum = indexDataSiswa.value.pelajaranUmum.asMap().entries.where((entry) {
        return entry.value.type == dataPelajaranaUmum.value.type &&
            entry.value.name == dataPelajaranaUmum.value.name;
      }).map((val) => val.key).first;
      var indexKhusus = indexDataSiswa.value.pelajaranKhusus.asMap().entries.where((entry) {
        return entry.value.type == dataPelajaranaKhusus.value.type &&
            entry.value.name == dataPelajaranaKhusus.value.name;
      }).map((val) => val.key).first;
    dataPelajaranaUmum.value =
        indexDataSiswa.value.pelajaranUmum[indexUmum];
    dataPelajaranaKhusus.value =
        indexDataSiswa.value.pelajaranKhusus[indexKhusus];

    // print(dataPelajaranaUmum.value.no);
    // print(dataPelajaranaKhusus.value.no);
  }

  void onChangePelajaranKhusus() {
    nilaiKhusus.text = dataPelajaranaKhusus.value.pengetahuan;
    keterampilanKhusus.text = dataPelajaranaKhusus.value.keterampilan;
  }

  void onChangePelajaranUmum() {
    nilaiUmum.text = dataPelajaranaUmum.value.pengetahuan;
    keterampilanUmum.text = dataPelajaranaUmum.value.keterampilan;
  }

  void onChangeSiswa() {
    dataPelajaranaUmum.value = indexDataSiswa.value.pelajaranUmum.first;
    dataPelajaranaKhusus.value = indexDataSiswa.value.pelajaranKhusus.first;
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
      await getDataSiswa();
      dataSiswa.value.sort((a, b) => a.nama!.compareTo(b.nama!));
      indexDataSiswa.value = dataSiswa.value.first;
      onChangeSiswa();
      onChangePelajaranKhusus();
      onChangePelajaranUmum();
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
  final int no;
  final String? id;
  final String? nama;
  final String? nis;
  final List<Pelajaran> pelajaranKhusus;
  final List<Pelajaran> pelajaranUmum;
  SiswaData(this.id, this.nama, this.nis, this.pelajaranKhusus,
      this.pelajaranUmum, this.no);
}

class Pelajaran {
  //Hello
  
  final String type;
  final String name;
  final int kkn;
  final String pengetahuan;
  final String keterampilan;

  Pelajaran(this.type, this.name, this.kkn, this.pengetahuan, this.keterampilan,
      );
}
//  typeUmum: {
//           'nama': nameUmum,
//           'kkn': kknUmum,
//           'Pengetahuan': nilaiUmum.text,
//           'Keterampilan': keterampilanUmum.text,
//         }