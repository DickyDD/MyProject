import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  void saveData({String nama = "Telah Tersimpan"}) {
    Get.defaultDialog(middleText: "Data $nama", title: "Berhasil");
  }

  void infowalikelas() {
    Get.defaultDialog(
      middleText: """Akun wali kelas yaitu :
NIP : Berdasarkan nip masing-masing walikelas
Password : Berdasarkan "kelas+romawi kelas+jurusan+urutan kelas+tahun ajaran+semester 

contoh pengisian :
 NIP : 23423 452643 5 646
 Password : kelas X BKP 1 2021-2022 semester 1""",
      title: "Info",
    );
  }

  final formKey = GlobalKey<FormState>();
  final users = FirebaseFirestore.instance;

  // Index List For left Nav
  final indexList = 0.obs;

  // Tahun Ajaran

  // Semester
  final semester = 'Semester 1'.obs;
  late final sizeKhusus = 0;
  final sizeUmum = 0;

  final pelajaran = false.obs;
  final listInputPelajaran = ["Pelajaran Umum", "Pelajaran Khusus"];
  final valuePelajaran = "Pelajaran Umum".obs;

  final valueKelas = ["X", "XI", "XII"];

  // List Jurusan
  // late List<Rx<String>> Perubahan tahun = [];
  late List<String> tahun = [];
  late List<Rx<TextEditingController>> ListTahun = [
    Rx(TextEditingController(text: 'dsdsd'))
  ];

  late List<TextEditingController> listJurusan = [];
  late List<TextEditingController> listSingkatanJurusan = [];
  late List<Jurusan> listNamaJurusan = [];

  late Rx<String> panjangList = Rx('2021-2022');

  final onLoading = false.obs;

  // PKL
  late List<TextEditingController> listMitra = [];
  late List<TextEditingController> listLokasi = [];

  // Extrakurikuler
  late List<Rx<TextEditingController>> extrakurikuler = [
    Rx(TextEditingController(text: 'dsdsd'))
  ];

  // ex
  late List<Rx<String>> listEXR = [];

  // kelas
  late Rx<Jurusan> jurusan;
  List<NamaKelas> listKelas9 = [];
  List<NamaKelas> listKelas10 = [];
  List<NamaKelas> listKelas11 = [];
  late List<TextEditingController> listWaliKelas9 = [];
  late List<TextEditingController> listWaliKelas10 = [];
  late List<TextEditingController> listWaliKelas11 = [];
  late List<bool> listWaliKelasActive9 = [];
  late List<bool> listWaliKelasActive10 = [];
  late List<bool> listWaliKelasActive11 = [];
  late List<TextEditingController> listWaliKelasGmail9 = [];
  late List<TextEditingController> listWaliKelasGmail10 = [];
  late List<TextEditingController> listWaliKelasGmail11 = [];
  late List<List<TextEditingController>>? listWalikelas;
  late List<List<TextEditingController>>? listWalikelasGmail;
  // final List<Kelas> listKelas = [];
  late Rx<Kelas> kelas =
      Rx(Kelas('Teknik Jaringan dan Komputer', 'TJk', 3, 2, 1, true));

  late final nilaiKKN = <TextEditingController>[];

  // Pelajran
  late RxList<int> panjangListUmum = <int>[].obs;
  late RxList<int> panjangListUmumKKN = <int>[].obs;
  late RxList<int> panjangListKhususC1 = <int>[].obs;
  late RxList<int> panjangListKhususC2 = <int>[].obs;
  late RxList<int> panjangListKhususC3 = <int>[].obs;
  late RxList<int> panjangListKhususKKNC2 = <int>[].obs;
  late RxList<int> panjangListKhususKKNC1 = <int>[].obs;
  late RxList<int> panjangListKhususKKNC3 = <int>[].obs;
  // late List<int>  = [];

  // final  = <TextEditingController>[];

  late List<PelajaranUmum> listPelajaranUmum = <PelajaranUmum>[];
  late List<PelajaranKhusus> listPelajaranKhusus = <PelajaranKhusus>[];

  // Kepala Sekolah
  final kepalaSekolahNama = TextEditingController();
  final kepalaSekolahNIP = TextEditingController();

  Future inputkepalaSekolah() async {
    await users.collection('Data Sekolah').doc('Data Kepala Sekolah').set({
      'Nama': kepalaSekolahNama.text,
      'NIP': kepalaSekolahNIP.text,
    });
  }

  Future getKepalaSekolah() async {
    await users
        .collection('Data Sekolah')
        .doc('Data Kepala Sekolah')
        .get()
        .then((value) {
      kepalaSekolahNama.text = value.data()!['Nama'];
      kepalaSekolahNIP.text = value.data()!['NIP'];
    });
    // .set({
    //   'Nama': kepalaSekolahNama.text,
    //   'NIP': kepalaSekolahNIP.text,
    // });
  }

  Future inputTahun() async {
    await users
        .collection('Data Sekolah')
        .doc('Data Tahun')
        .set({'Tahun': tahun});
  }

  // Jurusan

  Future getTahun() async {
    onLoading.value = true;
    tahun = [];
    ListTahun = [];

    await users.collection('Data Sekolah').get().then((value) {
      value.docs.forEach((element) {
        if (element.id == 'Data Tahun') {
          var listTahun = element.data()['Tahun'] as List;
          listTahun.forEach((element) {
            tahun.add(element.toString());
          });
        }
      });
    }).whenComplete(() => ListTahun =
        List.generate(tahun.length, (index) => TextEditingController().obs));
  }

  Future getJurusan() async {
    try {
      onLoading.value = true;
      await users.collection('Data Sekolah').get().then((value) {
        value.docs.forEach(
          (element) {
            if (element.id == 'Data Tahun') {
              var listTahun = element.data()['Tahun'] as List;
              listTahun.forEach((element) {
                tahun.add(element.toString());
              });
            } else if (element.id == 'Data Extrakurikuler') {
              var mapEKR = element.data()['data'];

              mapEKR.forEach((value) {
                if (value != null) {
                  var val = "$value".obs;
                  // var mitra = key.toString().obs;
                  listEXR.add(val);
                }
              });
              print(mapEKR);
            }
          },
        );

        if (value.size != 0) {
          listNamaJurusan.sort((a, b) {
            return a.namaSingkat.value.compareTo(b.namaSingkat.value);
          });
          print(listNamaJurusan[0]
            ..namaLengkap
            ..namaSingkat);
          buildJurusan(listNamaJurusan.length);

          panjangList.value = tahun[0];
        }

        onLoading.value = false;
      });
    } on FirebaseException catch (e) {
      print("FirebaseException $e");
      onLoading.value = false;
    } catch (e) {
      print("catch $e");
      onLoading.value = false;
    }
  }

  void addJurusan(
    RxInt sizeJurusan,
  ) {
    onLoading.value = true;
    listNamaJurusan = [...listNamaJurusan, Jurusan(''.obs, ''.obs)];
    listJurusan = [...listJurusan, TextEditingController()];
    listSingkatanJurusan = [...listSingkatanJurusan, TextEditingController()];
    sizeJurusan.value = listJurusan.length;
    onLoading.value = false;
  }

  void addEXR(
    RxInt sizeJurusan,
  ) {
    onLoading.value = true;
    listEXR = [...listEXR, "".obs];

    extrakurikuler = [...extrakurikuler, TextEditingController().obs];
    sizeJurusan.value = listEXR.length;
    onLoading.value = false;
  }

  void addTahun(
    RxInt sizeJurusan,
  ) {
    onLoading.value = true;
    tahun = [...tahun, ""];

    ListTahun = [...ListTahun, TextEditingController().obs];
    sizeJurusan.value = tahun.length;
    onLoading.value = false;
  }

  void lessTahun(
    RxInt sizeJurusan,
    int value,
  ) {
    onLoading.value = true;
    tahun.removeAt(value);
    ListTahun.removeAt(value);
    sizeJurusan.value = tahun.length;
    onLoading.value = false;
  }

  void lessEXR(
    RxInt sizeJurusan,
    String value,
  ) {
    onLoading.value = true;
    listEXR.remove(value);

    extrakurikuler.remove(value);
    sizeJurusan.value = listEXR.length;
    onLoading.value = false;
  }

  void lessJurusan(
    Jurusan namaLengkap,
    RxInt sizeJurusan,
    TextEditingController jurusanC,
    TextEditingController jsingkatanC,
  ) {
    onLoading.value = true;
    listNamaJurusan.removeWhere(
      (item) => item == namaLengkap,
    );
    listJurusan.removeWhere((item) => item == jurusanC);
    listSingkatanJurusan.removeWhere((item) => item == jsingkatanC);

    sizeJurusan.value = listJurusan.length;
    onLoading.value = false;
  }

  void buildJurusan(int data) {
    listJurusan = List.generate(
      data,
      (i) => TextEditingController(),
    );
    listSingkatanJurusan = List.generate(
      data,
      (i) => TextEditingController(),
    );
    print(listJurusan.length);
  }

  void changeDrobdown() {
    listJurusan = [];
    listNamaJurusan = [];
    print('removeeee..');
  }

  void removeClassJurusan() {
    tahun = [];

    print('removeeee.. Jurusan');
  }

  Future inputJurusan() async {
    var data = {};
    for (var i = 0; i < listNamaJurusan.length; i++) {
      data.addAll(
          {listSingkatanJurusan[i].text.trim(): listJurusan[i].text.trim()});
    }
    await users
        .collection('Data Sekolah')
        .doc('Data Jurusan')
        .set({'Jurusan': data});
    data.forEach((key, value) async {
      await users
          .collection('Data Sekolah')
          .doc('Data Pelajaran')
          .collection('Pelajaran Khusus')
          .doc(value)
          .set({
        key: {
          "C1": [''],
          "C2": [''],
          "C3": [''],
          "kknC1": [''],
          "kknC2": [''],
          "kknC3": [''],
        }
      });
    });
    for (var i = 0; i < listPelajaranKhusus.length; i++) {
      await users
          .collection('Data Sekolah')
          .doc('Data Pelajaran')
          .collection('Pelajaran Khusus')
          .doc(listPelajaranKhusus[i].id)
          .set({
        listPelajaranKhusus[i].namaSingkat: {
          "C1": listPelajaranKhusus[i].pelajaranC1,
          "C2": listPelajaranKhusus[i].pelajaranC2,
          "C3": listPelajaranKhusus[i].pelajaranC3,
          "kknC1": listPelajaranKhusus[i].nilaiKKNC1,
          "kknC2": listPelajaranKhusus[i].nilaiKKNC2,
          "kknC3": listPelajaranKhusus[i].nilaiKKNC3,
        },
      });
    }
  }

  Future inputEXR() async {
    var data = [];
    for (var i = 0; i < listEXR.length; i++) {
      data.add(listEXR[i].value);
    }
    try {
      await users
          .collection('Data Sekolah')
          .doc('Data Extrakurikuler')
          .set({'data': data});
    } catch (e) {
      print(e);
    }
  }

  // kelas
  Future getDataKelas() async {
    onLoading.value = true;
    var collection = panjangList.value;

    await users
        .collection(collection)
        .doc(jurusan.value.namaLengkap.value)
        .collection(semester.value.toLowerCase())
        .get()
        .then((value) async {
      if (value.size != 0) {
        var jumlahKelas9 = 0, jumlahKelas10 = 0, jumlahKelas11 = 0;
        value.docs.forEach((element) {
          print(element.id);
          var kelas = element.id.split(' ');
          if ("${kelas[0] + kelas[1]}" == "kelasXII") {
            jumlahKelas11++;
            listKelas11.add(NamaKelas(element.id, element.data()['walikelas'],
                element.data()['nip'], element.data()['aktif'] ?? false));
            print(listKelas11);
          } else if ("${kelas[0] + kelas[1]}" == 'kelasXI') {
            jumlahKelas10++;
            listKelas10.add(NamaKelas(element.id, element.data()['walikelas'],
                element.data()['nip'], element.data()['aktif'] ?? false));
            print(listKelas10);
          } else {
            jumlahKelas9++;
            listKelas9.add(
              NamaKelas(element.id, element.data()['walikelas'],
                  element.data()['nip'], element.data()['aktif'] ?? false),
            );
            print(listKelas9[0].aktif);
          }
        });

        kelas.value = Kelas(
            jurusan.value.namaLengkap.value,
            jurusan.value.namaSingkat.value,
            jumlahKelas9,
            jumlahKelas10,
            jumlahKelas11,
            false);

        listKelas9.sort((a, b) => a.namaKelas.compareTo(b.namaKelas));
        listKelas10.sort((a, b) => a.namaKelas.compareTo(b.namaKelas));
        listKelas11.sort((a, b) => a.namaKelas.compareTo(b.namaKelas));
        buildKelas(
          kelas.value.jumlahKelas9,
          kelas.value.jumlahKelas10,
          kelas.value.jumlahKelas11,
        );
      } else if (value.size == 0) {
        kelas.value = Kelas(jurusan.value.namaLengkap.value,
            jurusan.value.namaSingkat.value, 1, 1, 1, true);

        buildKelas(
          kelas.value.jumlahKelas9,
          kelas.value.jumlahKelas10,
          kelas.value.jumlahKelas11,
        );
        // onLoading.value = false;
      }
    }).whenComplete(() {
      for (var i = 0; i < listKelas9.length; i++) {
        listWaliKelas9[i].text = listKelas9[i].namaWaliKelas;
        listWaliKelasGmail9[i].text = listKelas9[i].gmailWaliKelas;
        kelas9Aktif[i].value = listKelas9[i].aktif;
      }
      for (var i = 0; i < listKelas10.length; i++) {
        listWaliKelas10[i].text = listKelas10[i].namaWaliKelas;
        listWaliKelasGmail10[i].text = listKelas10[i].gmailWaliKelas;
        kelas10Aktif[i].value = listKelas10[i].aktif;
      }
      for (var i = 0; i < listKelas11.length; i++) {
        listWaliKelas11[i].text = listKelas11[i].namaWaliKelas;
        listWaliKelasGmail11[i].text = listKelas11[i].gmailWaliKelas;
        kelas11Aktif[i].value = listKelas11[i].aktif;
      }
      buildListKelasC();
      onLoading.value = false;
    });
  }

  var kelas9Aktif = [false.obs];
  var kelas10Aktif = [false.obs];
  var kelas11Aktif = [false.obs];
  var gabungangKelasAktif = [<RxBool>[]];

  Future inputKelas() async {
    for (var j = 0; j < listWaliKelasGmail9.length; j++) {
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc('kelas X ${kelas.value.singkatanJurusan} ${j + 1}')
          .set(
        {
          'walikelas': listWaliKelas9[j].text,
          'nip': listWaliKelasGmail9[j].text,
          'aktif': kelas9Aktif[j].value,
        },
      );
      await users
          .collection('auth users')
          .doc(
              'kelas X ${kelas.value.singkatanJurusan} ${j + 1} ${panjangList.value} ${semester.value.toLowerCase()}')
          .set(
        {
          'aktif': kelas9Aktif[j].value,
          'password':
              'kelas X ${kelas.value.singkatanJurusan} ${j + 1} ${panjangList.value} ${semester.value.toLowerCase()}',
          'tahun': panjangList.value,
          'jurusan': kelas.value.namaJurusan,
          'semester': semester.value.toLowerCase(),
          'kelas': 'kelas X ${kelas.value.singkatanJurusan} ${j + 1}',
          'walikelas': listWaliKelas9[j].text,
          'nip': listWaliKelasGmail9[j].text,
        },
      );
      // : print("No Input Auth 9");

      print(listWaliKelas9[j].text);
    }
    for (var j = 0; j < listWaliKelas10.length; j++) {
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc('kelas XI ${kelas.value.singkatanJurusan} ${j + 1}')
          .set({
        'walikelas': listWaliKelas10[j].text,
        'nip': listWaliKelasGmail10[j].text,
        'aktif': kelas10Aktif[j].value,
      });
      await users
          .collection('auth users')
          .doc(
              'kelas XI ${kelas.value.singkatanJurusan} ${j + 1} ${panjangList.value} ${semester.value.toLowerCase()}')
          .set(
        {
          'aktif': kelas10Aktif[j].value,
          'password':
              'kelas XI ${kelas.value.singkatanJurusan} ${j + 1} ${panjangList.value} ${semester.value.toLowerCase()}',
          'tahun': panjangList.value,
          'semester': semester.value.toLowerCase(),
          'jurusan': kelas.value.namaJurusan,
          'kelas': 'kelas XI ${kelas.value.singkatanJurusan} ${j + 1}',
          'walikelas': listWaliKelas10[j].text,
          'nip': listWaliKelasGmail10[j].text,
        },
      );
      // : print("No Input Auth 10");
      print(listWaliKelas10[j].text);
    }
    for (var j = 0; j < listWaliKelas11.length; j++) {
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc('kelas XII ${kelas.value.singkatanJurusan} ${j + 1}')
          .set({
        'walikelas': listWaliKelas11[j].text,
        'nip': listWaliKelasGmail11[j].text,
        'aktif': kelas11Aktif[j].value,
      });
      await users
          .collection('auth users')
          .doc(
              'kelas XII ${kelas.value.singkatanJurusan} ${j + 1} ${panjangList.value} ${semester.value.toLowerCase()}')
          .set(
        {
          'aktif': kelas11Aktif[j].value,
          'password':
              'kelas XII ${kelas.value.singkatanJurusan} ${j + 1} ${panjangList.value} ${semester.value.toLowerCase()}',
          'tahun': panjangList.value,
          'jurusan': kelas.value.namaJurusan,
          'semester': semester.value.toLowerCase(),
          'kelas': 'kelas XII ${kelas.value.singkatanJurusan} ${j + 1}',
          'walikelas': listWaliKelas11[j].text,
          'nip': listWaliKelasGmail11[j].text,
        },
      );
      // : print("No Input Auth 11");

      print(listWaliKelas11[j].text);
    }
  }

  // Future delete

  void buildKelas(
    int kelas9,
    int kelas10,
    int kelas11,
  ) {
    buildKelas9(kelas9);
    buildKelas10(kelas10);
    buildKelas11(kelas11);
    buildListKelasC();

    onLoading.value = false;
  }

  void buildListKelasC() {
    listWalikelas = [listWaliKelas9, listWaliKelas10, listWaliKelas11];
    // gabungangKelasAuth = [kelas9Auth, kelas10Auth, kelas11Auth];
    gabungangKelasAktif = [kelas9Aktif, kelas10Aktif, kelas11Aktif];
    listWalikelasGmail = [
      listWaliKelasGmail9,
      listWaliKelasGmail10,
      listWaliKelasGmail11
    ];
  }

  void buildKelas9(
    int kelas9,
  ) {
    listWaliKelas9 = List.generate(
      kelas9,
      (i) => TextEditingController(),
    );
    // kelas9Auth = List.generate(kelas9, (index) => kelas.value.auth.obs);
    kelas9Aktif = List.generate(kelas9, (index) => kelas.value.auth.obs);
    listWaliKelasGmail9 = List.generate(
      kelas9,
      (i) => TextEditingController(),
    );
  }

  void buildKelas10(
    int kelas10,
  ) {
    listWaliKelas10 = List.generate(
      kelas10,
      (i) => TextEditingController(),
    );
    // kelas10Auth = List.generate(kelas10, (index) => kelas.value.auth.obs);
    kelas10Aktif = List.generate(kelas10, (index) => kelas.value.auth.obs);
    listWaliKelasGmail10 = List.generate(
      kelas10,
      (i) => TextEditingController(),
    );
  }

  void buildKelas11(
    int kelas11,
  ) {
    listWaliKelas11 = List.generate(
      kelas11,
      (i) => TextEditingController(),
    );
    // kelas11Auth = List.generate(kelas11, (index) => kelas.value.auth.obs);
    kelas11Aktif = List.generate(kelas11, (index) => kelas.value.auth.obs);
    listWaliKelasGmail11 = List.generate(
      kelas11,
      (i) => TextEditingController(),
    );
  }

  void changeDrobdownKelas() {
    onLoading.value = true;
    listKelas9 = [];
    listKelas10 = [];
    listKelas11 = [];
    listWalikelas = [];
    listWalikelasGmail = [];
    listWaliKelas9 = [];
    listWaliKelas10 = [];
    listWaliKelas11 = [];
    listWaliKelasGmail9 = [];
    listWaliKelasGmail10 = [];
    listWaliKelasGmail11 = [];
    kelas9Aktif = [];
    kelas10Aktif = [];
    kelas11Aktif = [];
    // kelas9Auth = [];
    // kelas10Auth = [];
    // kelas11Auth = [];
    print('removeeee.. Kelas');
  }

  Future<void> lessKelas(
    List<TextEditingController> listWaliKelas,
    List<TextEditingController> listWaliKelasGmail,
    TextEditingController itemKelas,
    TextEditingController itemKelasGmail,
    int i,
    String namaKelas,
  ) async {
    if (i == 0) {
      listWaliKelasGmail9.remove(itemKelasGmail);
      listWaliKelas9.remove(itemKelas);
      listWalikelas![i] = listWaliKelas9;
      listWalikelasGmail![i] = listWaliKelasGmail9;
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc(namaKelas)
          .delete();
      await users
          .collection('auth users')
          .doc(
              "$namaKelas ${panjangList.value} ${semester.value.toLowerCase()}")
          .delete();
    } else if (i == 1) {
      listWaliKelasGmail10.remove(itemKelasGmail);
      listWaliKelas10.remove(itemKelas);
      listWalikelas![i] = listWaliKelas10;
      listWalikelasGmail![i] = listWaliKelasGmail10;
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc(namaKelas)
          .delete();
      await users
          .collection('auth users')
          .doc(
              "$namaKelas ${panjangList.value} ${semester.value.toLowerCase()}")
          .delete();
    } else {
      listWaliKelasGmail11.remove(itemKelasGmail);
      listWaliKelas11.remove(itemKelas);
      listWalikelas![i] = listWaliKelas11;
      listWalikelasGmail![i] = listWaliKelasGmail11;
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc(namaKelas)
          .delete();
     await users
          .collection('auth users')
          .doc(
              "$namaKelas ${panjangList.value} ${semester.value.toLowerCase()}")
          .delete();
    }
    print(listWaliKelas9.length);
    print(listWaliKelasGmail9.length);
  }

  void addKelas(
    int i,
  ) {
    if (i == 0) {
      listWaliKelasGmail9 = [...listWaliKelasGmail9, TextEditingController()];
      listWaliKelas9 = [...listWaliKelas9, TextEditingController()];
      listWalikelas![i] = listWaliKelas9;
      listWalikelasGmail![i] = listWaliKelasGmail9;
      kelas9Aktif = [...kelas9Aktif, true.obs];
      gabungangKelasAktif[i] = kelas9Aktif;
    } else if (i == 1) {
      listWaliKelasGmail10 = [...listWaliKelasGmail10, TextEditingController()];
      listWaliKelas10 = [...listWaliKelas10, TextEditingController()];
      listWalikelas![i] = listWaliKelas10;
      listWalikelasGmail![i] = listWaliKelasGmail10;
      // kelas10Auth = [...kelas10Auth, true.obs];
      kelas10Aktif = [...kelas10Aktif, true.obs];
      // gabungangKelasAuth[i] = kelas10Auth;
      gabungangKelasAktif[i] = kelas10Aktif;
    } else {
      listWaliKelasGmail11 = [...listWaliKelasGmail11, TextEditingController()];
      listWaliKelas11 = [...listWaliKelas11, TextEditingController()];
      listWalikelas![i] = listWaliKelas11;
      listWalikelasGmail![i] = listWaliKelasGmail11;
      // kelas11Auth = [...kelas11Auth, true.obs];
      kelas11Aktif = [...kelas11Aktif, true.obs];
      gabungangKelasAktif[i] = kelas11Aktif;
    }
  }

  //  Pelajaran

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
      panjangListUmum.add(element.pelajaran.length);
      panjangListUmumKKN.add(element.pelajaran.length);
    });
  }

  Future getPelajaranKhusus() async {
    await users
        .collection('Data Sekolah')
        .doc('Data Pelajaran')
        .collection('Pelajaran Khusus')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.data().forEach((key, value) {
          listPelajaranKhusus.add(
            PelajaranKhusus(
              key,
              value['C1'] as List,
              value['C2'] as List,
              value['C3'] as List,
              value['kknC1'] as List,
              value['kknC2'] as List,
              value['kknC3'] as List,
              element.id,
            ),
          );
          listNamaJurusan.add(Jurusan(element.id.obs, key.obs));
        });
      });
    });
    listPelajaranKhusus.forEach((element) {
      panjangListKhususC1.add(element.pelajaranC1.length);
      panjangListKhususC2.add(element.pelajaranC2.length);
      panjangListKhususC3.add(element.pelajaranC3.length);
      panjangListKhususKKNC1.add(element.pelajaranC1.length);
      panjangListKhususKKNC2.add(element.pelajaranC2.length);
      panjangListKhususKKNC3.add(element.pelajaranC3.length);
    });
  }

  Future inputPelajaranUmum() async {
    try {
      if (formKey.currentState!.validate()) {
        listPelajaranUmum.forEach((element) async {
          await users
              .collection('Data Sekolah')
              .doc('Data Pelajaran')
              .collection('Pelajaran Umum')
              .doc(element.id)
              .set({
            element.namaSingkat: {
              'kknUmum': [...element.KKN],
              'umum': [...element.pelajaran]
            },
          });
        });
      } else {
        Get.defaultDialog(
          title: 'Gagal',
          middleText: 'Nilai Tidak Boleh Lebih Dari 100',
        );
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future inputPelajaranKhusus() async {
    try {
      if (formKey.currentState!.validate()) {
        listPelajaranKhusus.forEach((element) async {
          await users
              .collection('Data Sekolah')
              .doc('Data Pelajaran')
              .collection('Pelajaran Khusus')
              .doc(element.id)
              .set({
            element.namaSingkat: {
              "C1": element.pelajaranC1,
              "C2": element.pelajaranC2,
              "C3": element.pelajaranC3,
              "kknC1": element.nilaiKKNC1,
              "kknC2": element.nilaiKKNC2,
              "kknC3": element.nilaiKKNC3,
            },
          });
        });
      } else {
        Get.defaultDialog(
          title: 'Gagal',
          middleText: 'Nilai Tidak Boleh Lebih Dari 100',
        );
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future delete(String id) async {
    try {
      await users
          .collection('Data Sekolah')
          .doc('Data Pelajaran')
          .collection('Pelajaran Khusus')
          .doc(id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  // Future getJurursanKhusus() async {
  //   var data = await users
  //       .collection('Data Sekolah')
  //       .doc('Data Pelajaran')
  //       .collection('Pelajaran Khusus')
  //       .get();
  //   data.docs.forEach((element) {
  //     element.data().forEach((key, value) {
  //       listNamaJurusan.add(Jurusan(element.id.obs, key.obs));
  //     });
  //   });
  // }

  void removeListKhusus() {
    panjangListKhususC1 = <int>[].obs;
    panjangListKhususC2 = <int>[].obs;
    panjangListKhususC3 = <int>[].obs;
    listPelajaranKhusus = <PelajaranKhusus>[];
    listNamaJurusan = [];
  }

  void addPelajranKhususC1(int i) {
    listPelajaranKhusus[i].pelajaranC1.add('');
    listPelajaranKhusus[i].nilaiKKNC1.add('');
    panjangListKhususC1[i]++;
  }

  void addPelajranKhususC2(int i) {
    listPelajaranKhusus[i].pelajaranC2.add('');
    listPelajaranKhusus[i].nilaiKKNC2.add('');
    panjangListKhususC2[i]++;
  }

  void addPelajranKhususC3(int i) {
    listPelajaranKhusus[i].pelajaranC3.add('');
    listPelajaranKhusus[i].nilaiKKNC3.add('');
    panjangListKhususC3[i]++;
  }

  void addPelajranUmum(int i) {
    listPelajaranUmum[i].pelajaran.add('');
    listPelajaranUmum[i].KKN.add('');
    panjangListUmum[i]++;
  }

  void lessPelajranKhususC1(int i, dynamic data, dynamic data1) {
    listPelajaranKhusus[i].pelajaranC1.remove(data);
    listPelajaranKhusus[i].nilaiKKNC1.remove(data1);

    panjangListKhususC1[i]--;
  }

  void lessPelajranKhususC2(int i, dynamic data, dynamic data1) {
    listPelajaranKhusus[i].pelajaranC2.remove(data);
    listPelajaranKhusus[i].nilaiKKNC2.remove(data1);
    panjangListKhususC2[i]--;
  }

  void lessPelajranKhususC3(int i, dynamic data, dynamic data1) {
    listPelajaranKhusus[i].pelajaranC3.remove(data);
    panjangListKhususC3[i]--;
    listPelajaranKhusus[i].nilaiKKNC3.remove(data1);
  }

  void lessPelajranUmum(int i, dynamic data, dynamic data1) {
    listPelajaranUmum[i].pelajaran.remove(data);
    panjangListUmum[i]--;
    listPelajaranUmum[i].KKN.remove(data1);
  }

  // getDataKelas() async {}

  @override
  void dispose() {
    listJurusan.forEach((c) => c.dispose());
    listWaliKelas9.forEach((c) => c.dispose());
    listWaliKelas10.forEach((c) => c.dispose());
    listWaliKelas11.forEach((c) => c.dispose());

    // pelajaran.dispose();
    // guru.dispose();
    super.dispose();
  }

  @override
  void onInit() async {
    if (Get.arguments != null) {
      await getPelajaranKhusus()
          .whenComplete(() => jurusan = listNamaJurusan[0].obs);
      await getJurusan();
      await getPelajaranUmum();
      // await getJurursanKhusus();

      await getDataKelas();
      await getKepalaSekolah();
      extrakurikuler =
          List.generate(listEXR.length, (index) => TextEditingController().obs);
      ListTahun =
          List.generate(tahun.length, (index) => TextEditingController().obs);
    } else {
      Get.offAllNamed('/login');
    }
    super.onInit();
  }
}

class Jurusan {
  final RxString namaLengkap;
  final RxString namaSingkat;
  Jurusan(this.namaLengkap, this.namaSingkat);
}

class NamaKelas {
  final String namaKelas;
  final String namaWaliKelas;
  final String gmailWaliKelas;
  final bool aktif;

  NamaKelas(
    this.namaKelas,
    this.namaWaliKelas,
    this.gmailWaliKelas,
    this.aktif,
  );
}

class PelajaranUmum {
  final String id;
  final String namaSingkat;

  late final List pelajaran;
  late final List KKN;

  PelajaranUmum(
    this.namaSingkat,
    this.pelajaran,
    this.KKN,
    this.id,
  );
}

class PelajaranKhusus {
  final String id;
  final String namaSingkat;

  late List pelajaranC1;
  late List pelajaranC2;
  late List pelajaranC3;
  late List nilaiKKNC1;
  late List nilaiKKNC2;
  late List nilaiKKNC3;

  PelajaranKhusus(
    this.namaSingkat,
    this.pelajaranC1,
    this.pelajaranC2,
    this.pelajaranC3,
    this.nilaiKKNC1,
    this.nilaiKKNC2,
    this.nilaiKKNC3,
    this.id,
  );
}

class Kelas {
  String namaJurusan;
  String singkatanJurusan;
  int jumlahKelas9;
  int jumlahKelas10;
  int jumlahKelas11;
  bool auth;

  Kelas(
    this.namaJurusan,
    this.singkatanJurusan,
    this.jumlahKelas9,
    this.jumlahKelas10,
    this.jumlahKelas11,
    this.auth,
  );
}
