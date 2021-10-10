import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController with StateMixin {
  final users = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // Index List For left Nav
  final indexList = 0.obs;

  // Tahun Ajaran
  final tahunAjaran = TextEditingController();
  final jumlahJurusan = TextEditingController();

  // Semester
  final semester = 'Semester 1'.obs;

  // List Jurusan
  late List<String> tahun = [];

  late List<TextEditingController> listJurusan = [];
  late List<TextEditingController> listSingkatanJurusan = [];
  late List<Jurusan> listNamaJurusan = [];

  late Rx<String> panjangList = Rx('2021-2022');

  final onLoading = false.obs;

  // kelas
  late Rx<Jurusan> jurusan;
  List<NamaKelas> listKelas9 = [];
  List<NamaKelas> listKelas10 = [];
  List<NamaKelas> listKelas11 = [];
  late List<TextEditingController> listWaliKelas9 = [];
  late List<TextEditingController> listWaliKelas10 = [];
  late List<TextEditingController> listWaliKelas11 = [];
  late List<TextEditingController> listWaliKelasGmail9 = [];
  late List<TextEditingController> listWaliKelasGmail10 = [];
  late List<TextEditingController> listWaliKelasGmail11 = [];
  late List<List<TextEditingController>>? listWalikelas;
  late List<List<TextEditingController>>? listWalikelasGmail;
  // final List<Kelas> listKelas = [];
  late Rx<Kelas> kelas =
      Rx(Kelas('Teknik Jaringan dan Komputer', 'TJk', 3, 2, 1));

  final pelajaran = TextEditingController();
  final guru = TextEditingController();
  final jumlah = TextEditingController();

  Future inputTahun() async {
    await users.collection('Data Sekolah').doc('Data Tahun').set({
      'Tahun': [...tahun, '${tahunAjaran.text}']
    });
  }

  // Jurusan

  Future getTahun() async {
    try {
      onLoading.value = true;
      await users.collection('Data Sekolah').get().then((value) {
        value.docs.forEach(
          (element) {
            if (element.id == 'Data Tahun') {
              var listTahun = element.data()['Tahun'] as List;
              listTahun.forEach((element) {
                tahun.add(element);
              });
            } else if (element.id == 'Data Jurusan') {
              var mapJurusan = element.data()['Jurusan'];

              mapJurusan.forEach((key, value) {
                var namaLengkap = "$value".obs;
                var namaSingkat = key.toString().obs;
                listNamaJurusan.add(Jurusan(namaLengkap, namaSingkat));
              });
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
          if ("${kelas[0] + kelas[1]}" == "kelas11") {
            jumlahKelas11++;
            listKelas11.add(NamaKelas(element.id, element.data()['walikelas'],
                element.data()['email']));
            print(11);
          } else if ("${kelas[0] + kelas[1]}" == 'kelas10') {
            jumlahKelas10++;
            listKelas10.add(NamaKelas(element.id, element.data()['walikelas'],
                element.data()['email']));
            print(10);
          } else {
            jumlahKelas9++;
            listKelas9.add(NamaKelas(element.id, element.data()['walikelas'],
                element.data()['email']));
            print(9);
          }
        });

        kelas.value = Kelas(
          jurusan.value.namaLengkap.value,
          jurusan.value.namaSingkat.value,
          jumlahKelas9,
          jumlahKelas10,
          jumlahKelas11,
        );

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
            jurusan.value.namaSingkat.value, 1, 1, 1,);

        buildKelas(
          kelas.value.jumlahKelas9,
          kelas.value.jumlahKelas10,
          kelas.value.jumlahKelas11,
        );
        onLoading.value = false;
      }
    }).whenComplete(() {
      for (var i = 0; i < listKelas9.length; i++) {
        listWaliKelas9[i].text = listKelas9[i].namaWaliKelas;
        listWaliKelasGmail9[i].text = listKelas9[i].gmailWaliKelas;
      }
      for (var i = 0; i < listKelas10.length; i++) {
        listWaliKelas10[i].text = listKelas10[i].namaWaliKelas;
        listWaliKelasGmail10[i].text = listKelas10[i].gmailWaliKelas;
      }
      for (var i = 0; i < listKelas11.length; i++) {
        listWaliKelas11[i].text = listKelas11[i].namaWaliKelas;
        listWaliKelasGmail11[i].text = listKelas11[i].gmailWaliKelas;
      }

      onLoading.value = false;
    });
  }

  inputKelas() async {
    // await users.collection(panjangList.value).doc(kelas.value.namaJurusan).set({
    //   'data': {
    //     'jumlah kelas 9': listWaliKelas9.length,
    //     'jumlah kelas 10': listWaliKelas10.length,
    //     'jumlah kelas 11': listWaliKelas11.length,
    //   }
    // });
    for (var j = 0; j < listWaliKelasGmail9.length; j++) {
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc('kelas 9 ${kelas.value.singkatanJurusan} ${j + 1}')
          .set(
        {
          'walikelas': listWaliKelas9[j].text,
          'email': listWaliKelasGmail9[j].text,
        },
      );
      await users.collection('auth users').doc('${listWaliKelas9[j].text} ${DateTime.now().month}').set(
        {
          'password': '${listWaliKelas9[j].text} ${DateTime.now().month}',
          'tahun': panjangList.value,
          'semester': semester.value.toLowerCase(),
          'kelas': 'kelas 9 ${kelas.value.singkatanJurusan} ${j + 1}',
          'walikelas': listWaliKelas9[j].text,
          'email': listWaliKelasGmail9[j].text,
        },
      );

      print(listWaliKelas9[j].text);
    }
    for (var j = 0; j < listWaliKelas10.length; j++) {
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc('kelas 10 ${kelas.value.singkatanJurusan} ${j + 1}')
          .set({
        'walikelas': listWaliKelas10[j].text,
        'email': listWaliKelasGmail10[j].text,
      });
      await users.collection('auth users').doc('${listWaliKelas10[j].text} ${DateTime.now().month}').set(
        {
          'password': '${listWaliKelas10[j].text} ${DateTime.now().month}',
          'tahun': panjangList.value,
          'semester': semester.value.toLowerCase(),
          'kelas': 'kelas 10 ${kelas.value.singkatanJurusan} ${j + 1}',
          'walikelas': listWaliKelas10[j].text,
          'email': listWaliKelasGmail10[j].text,
        },
      );
      print(listWaliKelas10[j].text);
    }
    for (var j = 0; j < listWaliKelas11.length; j++) {
      await users
          .collection(panjangList.value)
          .doc(kelas.value.namaJurusan)
          .collection(semester.value.toLowerCase())
          .doc('kelas 11 ${kelas.value.singkatanJurusan} ${j + 1}')
          .set({
        'walikelas': listWaliKelas11[j].text,
        'email': listWaliKelasGmail11[j].text,
      });
      await users.collection('auth users').doc('${listWaliKelas11[j].text} ${DateTime.now().month}').set(
        {
          'password': '${listWaliKelas11[j].text} ${DateTime.now().month}',
          'tahun': panjangList.value,
          'semester': semester.value.toLowerCase(),
          'kelas': 'kelas 11 ${kelas.value.singkatanJurusan} ${j + 1}',
          'walikelas': listWaliKelas11[j].text,
          'email': listWaliKelasGmail11[j].text,
        },
      );

      print(listWaliKelas11[j].text);
    }
  }

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
    print('removeeee.. Kelas');
  }

  void lessKelas(
    List<TextEditingController> listWaliKelas,
    List<TextEditingController> listWaliKelasGmail,
    TextEditingController itemKelas,
    TextEditingController itemKelasGmail,
  ) {
    listWaliKelas.removeWhere((element) => element == itemKelas);

    listWaliKelasGmail.removeWhere((element) => element == itemKelasGmail);
  }

  void addKelas(
    int i,
  ) {
    listWalikelas![i] = [...listWalikelas![i], TextEditingController()];

    listWalikelasGmail![i] = [
      ...listWalikelasGmail![i],
      TextEditingController()
    ];
  }

  // getDataKelas() async {}

  @override
  void dispose() {
    tahunAjaran.dispose();

    listJurusan.forEach((c) => c.dispose());
    listWaliKelas9.forEach((c) => c.dispose());
    listWaliKelas10.forEach((c) => c.dispose());
    listWaliKelas11.forEach((c) => c.dispose());

    pelajaran.dispose();
    guru.dispose();
    super.dispose();
  }

  @override
  void onInit() async {
    await getTahun();
    jurusan = listNamaJurusan[0].obs;
    await getDataKelas();

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

  NamaKelas(
    this.namaKelas,
    this.namaWaliKelas,
    this.gmailWaliKelas,
  );
}

class Kelas {
  String namaJurusan;
  String singkatanJurusan;
  int jumlahKelas9;
  int jumlahKelas10;
  int jumlahKelas11;

  Kelas(this.namaJurusan, this.singkatanJurusan, this.jumlahKelas9,
      this.jumlahKelas10, this.jumlahKelas11);
}
