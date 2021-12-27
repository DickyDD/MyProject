import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TesSiswaController extends GetxController {
  late String tahunAjaran = '2021-2022',
      jurusan = 'Bisnis Konstruksi dan Property',
      semester = 'semester 2',
      kelas = 'kelas X BKP 1',
      nip = '23423 452643 5 646',
      guru = 'Dicky1';
  final users = FirebaseFirestore.instance;
  final indexDataSiswa = SiswaData('213321', 'diki', '12313').obs;
  final onloading = false.obs;
  late Rx<List<SiswaData>> dataSiswa = Rx(<SiswaData>[]);
  late Rx<ListPelajaran> dataNilaiUmum = Rx(ListPelajaran('type', 'name', 0));
  late Rx<ListPelajaran> dataNilaiKhusus = Rx(ListPelajaran('type', 'name', 0));
  late List<ListPelajaran> listGabunganKhusus = [];
  // late List<ListPelajaran> listKhususC3 = [];
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
        .get()
        .then(
          (value) => dataSiswa.value = value.docs
              .map(
                (e) => SiswaData(
                  e.id,
                  e.data()['nama'],
                  e.data()['nis'],
                ),
              )
              .toList(),
        )
        .whenComplete(() => onloading.value = !onloading.value);
  }

  var pelajranKhususC1;
  var pelajranKhususC2;
  var pelajranKhususC3;
  var nilaiKknKhususC1;
  var nilaiKknKhususC2;
  var nilaiKknKhususC3;

  Future getDataPelajaranKhusus() async {
    var data = await users
        .collection('Data Sekolah')
        .doc('Data Pelajaran')
        .collection('Pelajaran Khusus')
        .doc(jurusan)
        .get();
    data.data()!.forEach((key, value) {
      pelajranKhususC1 = value['C1'];
      pelajranKhususC2 = value['C2'];
      pelajranKhususC3 = value['C3'];
      nilaiKknKhususC1 = value['kknC1'];
      nilaiKknKhususC2 = value['kknC2'];
      nilaiKknKhususC3 = value['kknC3'];
    });
    print(data.data()!);
    print(pelajranKhususC1);
    print(pelajranKhususC2);
    print(pelajranKhususC3);
  }

  Future addNilaiPelajaran() async {
    onloading.value = !onloading.value;
    await users
        .collection(tahunAjaran)
        .doc(jurusan)
        .collection(semester)
        .doc(kelas)
        .collection('Siswa')
        .doc(indexDataSiswa.value.id)
        .update({
      'nilai': jurusan,
    });
  }

  Future<void> inputDataSiswa() async {
    // urlsSiswa

    var listNilaiKhusus = [];
    var listNilaiUmum = [];

    var typeUmum = dataNilaiUmum.value.type;
    var nameUmum = dataNilaiUmum.value.name;
    var kknUmum = dataNilaiUmum.value.kkn;
    var typeKhusus = dataNilaiKhusus.value.type;
    var nameKhusus = dataNilaiKhusus.value.name;
    var kknKhusus = dataNilaiKhusus.value.kkn;

    listNilaiKhusus.add(
      {
        typeKhusus: {
          'nama': nameKhusus,
          'kkn': kknKhusus,
          'Pengetahuan': nilaiKhusus.text,
          'Keterampilan': keterampilanKhusus.text,
        }
      },
    );

    listNilaiUmum.add(
      {
        typeUmum: {
          'nama': nameUmum,
          'kkn': kknUmum,
          'Pengetahuan': nilaiUmum.text,
          'Keterampilan': keterampilanUmum.text,
        }
      },
    );

    // if (nilaiBlmTuntas != 0) {
    //     Get.defaultDialog(title: tidakLulus);
    //   }

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

        // "namaOrtu": namaOrtu.text,
        // "catatanAkademik": catatanAkademik.text,
      },
    ).whenComplete(() {
      nilaiKhusus.clear();
      keterampilanKhusus.clear();
      nilaiUmum.clear();
      keterampilanUmum.clear();
    });
  }

  late List<ListPelajaran> listGabunganUmum = [];
  late List<PelajaranUmum> listPelajaranUmum = <PelajaranUmum>[];
  late RxList<int> panjangListUmum = <int>[].obs;
  Future getPelajaranUmum() async {
    await users
        .collection('Data Sekolah')
        .doc('Data Pelajaran')
        .collection('Pelajaran Umum')
        .get()
        .then((value) {
      print(value.size);
      value.docs.forEach((element) {
        element.data().forEach(
              (key, value) => listPelajaranUmum.add(
                PelajaranUmum(
                  key,
                  value['umum'] as List,
                  value['kknUmum'] as List,
                  element.id,
                ),
              ),
            );
      });
    });
    listPelajaranUmum.forEach((element) {
      print(element.namaSingkat);
      panjangListUmum.add(element.pelajaran.length);
    });
  }

  @override
  void onInit() async {
    await getDataSiswa();
    await getDataPelajaranKhusus();
    await getPelajaranUmum();
    if (kelas.split(' ')[1] != 'X') {
      var listC3 = <ListPelajaran>[];
      var list3 = pelajranKhususC3 as List;
      var listNilai3 = nilaiKknKhususC3 as List;
      for (var i = 0; i < list3.length; i++) {
        listC3.add(
          ListPelajaran(
            'C3',
            list3[i],
            int.parse(listNilai3[i]),
          ),
        );
      }
      listGabunganKhusus = [...listC3];
    } else {
      var list1 = pelajranKhususC1 as List;
      var list2 = pelajranKhususC2 as List;
      var listNilai1 = nilaiKknKhususC1 as List;
      var listNilai2 = nilaiKknKhususC2 as List;
      var listC1 = <ListPelajaran>[];
      var listC2 = <ListPelajaran>[];

      for (var i = 0; i < list1.length; i++) {
        listC1.add(
          ListPelajaran(
            'C1',
            list1[i],
            int.parse(listNilai1[i]),
          ),
        );
      }
      for (var i = 0; i < list2.length; i++) {
        listC2.add(
          ListPelajaran(
            'C2',
            list2[i],
            int.parse(listNilai2[i]),
          ),
        );
      }
      listGabunganKhusus = [...listC1, ...listC2];
      listGabunganKhusus.forEach((element) {
        print(element.name);
        print(element.kkn);
      });
    }
    listPelajaranUmum.forEach((element) {
      for (var i = 0; i < element.pelajaran.length; i++) {
        listGabunganUmum.add(
          ListPelajaran(
            element.id,
            element.pelajaran[i],
            int.parse(element.kkn[i]),
          ),
        );
      }
      listGabunganUmum.forEach((element) {
        print(element.name);
        print(element.kkn);
      });
    });
    indexDataSiswa.value = dataSiswa.value.first;
    dataNilaiUmum.value = listGabunganUmum.first;
    dataNilaiKhusus.value = listGabunganKhusus.first;
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
  SiswaData(this.id, this.nama, this.nis);
}

class PelajaranUmum {
  final String id;
  final String namaSingkat;
  late final List pelajaran;
  late final List kkn;

  PelajaranUmum(
    this.namaSingkat,
    this.pelajaran,
    this.kkn,
    this.id,
  );
}

class ListPelajaran {
  //Hello
  final String type;
  final String name;
  final int kkn;

  ListPelajaran(this.type, this.name, this.kkn);
}
