import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tes_database/app/modules/home/controllers/home_controller.dart';

class GuruController extends GetxController {
  final Map data = Get.arguments;

  late int jumlah = 1;
  List<String> namaIndex = [
    'Akun',
    'Input',
    'Lihat',
    'Exit',
  ];

  var listDataEXR = <String>[];
  var nilaiEXR = <TextEditingController>[];
  var listDataPKL = <ListPelajaran>[];
  var nialiPKL = <TextEditingController>[];
  var lamaPKL = <TextEditingController>[];

  final formKey = GlobalKey<FormState>();

  late String tahunAjaran = '2021-2022',
      jurusan = 'Bisnis Konstruksi dan Property',
      semester = 'semester 1',
      kelas = 'kelas 11 BKP 1',
      gmail = 'Maul9@gmail.com',
      guru = 'Dicky Darmawan',
      image =
          'https://cdn.dribbble.com/users/1450874/screenshots/15555516/media/e70b73671f40c3102ab98f4c251c198e.jpg?compress=1&resize=1200x900';

  final users = FirebaseFirestore.instance;
  final imagePiker = ImagePicker();

  var panjangKhusus = 1.obs;
  var panjangUmum = 1.obs;

  // final DataSiswa listDataSiswa = [];

  final indexList = 0.obs;
  final onLoading = false.obs;
  final onLoadingImage = false.obs;

  //List Pelajaran
  var pelajranUmum;
  late RxString singkatanUmum = ''.obs;
  late RxString singkatanKhusus = ''.obs;
  late List<ListPelajaran> listGabunganKhusus = [];
  late List<ListPelajaran> listKhususC3 = [];
  late List<ListPelajaran> listGabunganUmum = [];
  final List<String> listKehadiran = ['Sakit', 'Izin', 'Tanpa Keterangan'];

  final List<String> listDPK = [
    'Integritas',
    'Religius',
    'Nasionalis',
    'Mandiri',
    'Gotong-royong'
  ];

  var nialiKehadiran = <TextEditingController>[];
  var nilaiDPK = <TextEditingController>[];
  var pelajranKhususC1;
  var pelajranKhususC2;
  var pelajranKhususC3;
  var dropdownValueKhusus = <Rx<ListPelajaran>>[];

  var dropdownValueUmum = <Rx<ListPelajaran>>[];

  var dropdownValueEXR = <Rx<String>>[];
  var dropdownValuePKL = <Rx<ListPelajaran>>[];

  // siswa
  final Rx<XFile> imageSiswa = Rx(XFile(''));

  var urlsSiswa = '';
  var panjangNilai = 0.obs;
  var nilaiKhusus = <TextEditingController>[];
  var nilaiUmum = <TextEditingController>[];

  // var pelajaran = <Rx<String>>[];
  late TextEditingController nama = TextEditingController();
  late TextEditingController nis = TextEditingController();
  late TextEditingController noOrtu = TextEditingController();
  late TextEditingController catatanAkademik = TextEditingController();

  //Guru
  final Rx<XFile> imageGuru = Rx(XFile(''));
  var fileGuru;
  var urlsGuru = '';
  final cangePassword = false.obs;
  late TextEditingController password =
      TextEditingController(text: guru + ' ' + kelas);

  Future<Uint8List> getImages(Rx<XFile> imagevalue) async {
    // onLoadingImage.value = true;
    imagevalue.value =
        (await imagePiker.pickImage(source: ImageSource.gallery))!;
    Uint8List file = await imagevalue.value.readAsBytes();

    if (imagevalue.value == XFile('')) {
      onLoadingImage.value = false;
    }
    print(imagevalue.value);
    // onLoadingImage.value = false;
    // return result!.files.first.bytes!;
    return file;
  }

  Future updateguru(String url) async {
    var taskImages =
        await FirebaseStorage.instance.ref('foto_guru/$kelas').putData(
              fileGuru,
              SettableMetadata(contentType: 'image/jpeg'),
            );
    url = await taskImages.ref.getDownloadURL();
    await users
        .collection(tahunAjaran)
        .doc(jurusan)
        .collection(semester)
        .doc(kelas)
        .update(
      {
        'imageUrl': url,
      },
    );
  }

  Future<void> inputDataSiswa() async {
    // urlsSiswa
    var listNilaiKhusus = [];
    var listNilaiUmum = [];
    var listPl = [];
    var x = [];
    var k = [];
    var d = [];

    for (var i = 0; i < dropdownValueEXR.length; i++) {
      var type = dropdownValueEXR[i].value;
      print(nilaiEXR[i].text);
      x.add(
        {
          type: {
            'nilai': nilaiEXR[i].text,
          }
        },
      );
      nilaiEXR[i].clear();
    }

    for (var i = 0; i < listKehadiran.length; i++) {
      var type = listKehadiran[i];
      print(nialiKehadiran[i].text);
      k.add(
        {
          type: {
            'nilai': nialiKehadiran[i].text,
          }
        },
      );
      nialiKehadiran[i].clear();
    }

    for (var i = 0; i < listDPK.length; i++) {
      var type = listDPK[i];
      print(nilaiDPK[i].text);
      d.add(
        {
          type: {
            'nilai': nilaiDPK[i].text,
          }
        },
      );
      nilaiDPK[i].clear();
    }

    for (var i = 0; i < dropdownValueKhusus.length; i++) {
      var name = dropdownValueKhusus[i].value.name;
      var type = dropdownValueKhusus[i].value.type;
      print("nialai Khusus" + nilaiKhusus[i].text);
      listNilaiKhusus.add(
        {
          type: {
            'nama': name,
            'nilai': nilaiKhusus[i].text,
          }
        },
      );
      nilaiKhusus[i].clear();
    }
    for (var i = 0; i < dropdownValueUmum.length; i++) {
      var name = dropdownValueUmum[i].value.name;
      var type = dropdownValueUmum[i].value.type;
      print("nialai umum" + nilaiUmum[i].text);
      listNilaiUmum.add(
        {
          type: {
            'nama': name,
            'nilai': nilaiUmum[i].text,
          }
        },
      );
      nilaiUmum[i].clear();
    }
    print(listNilaiUmum);
    for (var i = 0; i < dropdownValuePKL.length; i++) {
      var name = dropdownValuePKL[i].value.name;
      var type = dropdownValuePKL[i].value.type;
      print(nialiPKL[i].text);
      listPl.add(
        {
          type: {
            'lokasi': name,
            'lama': lamaPKL[i].text,
            'nilai': nialiPKL[i].text,
          }
        },
      );
      nialiPKL[i].clear();
    }

    await users
        .collection(tahunAjaran)
        .doc(jurusan)
        .collection(semester)
        .doc(kelas)
        .collection("Siswa")
        .add(
      {
        'nama': nama.text,
        'nis': nis.text,
        "imageSiswa": urlsSiswa == '' ? image : urlsSiswa,
        "noOrtu": noOrtu.text,
        "nilai_umum": listNilaiUmum,
        "nilai_khusus": listNilaiKhusus,
        "pkl": listPl,
        "extr": x,
        "kehadiran": k,
        "dpk": d,
        "catatanAkademik": catatanAkademik.text,
      },
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? streamData;

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
      // print(panjangNilai.value++);
    });
    print(pelajranKhususC1);
    print(pelajranKhususC2);
    print(pelajranKhususC3);
  }

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

// Data Sekolah/Data Extrakurikuler

  Future getEXR() async {
    var data =
        await users.collection('Data Sekolah').doc('Data Extrakurikuler').get();
    data.data()!['data'].forEach((value) {
      listDataEXR.add(value);
      print(value);
    });
  }

  Future getPKL() async {
    var data = await users.collection('Data Sekolah').doc('Data PKL').get();
    data.data()!['data'].forEach((key, value) {
      listDataPKL.add(ListPelajaran(key.toString(), value.toString()));
      print(value);
    });
  }

  @override
  void dispose() {
    nilaiKhusus.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  void onInit() async {
    if (Get.arguments != null) {
      onLoading.value = true;
      jumlah = int.parse(data['jumlah']);
      tahunAjaran = data['tahun'];
      jurusan = data['jurusan'];
      semester = data['semester'];
      kelas = data['kelas'];
      guru = data['guru'];
      await getDataPelajaranKhusus();
      await getPelajaranUmum();
      await getEXR();
      await getPKL();
      // ...pelajranKhususC1, ...pelajranKhususC2

      if (kelas.split(' ')[1] != '9') {
        var listC3 = <ListPelajaran>[];
        var list3 = pelajranKhususC3 as List;
        list3.forEach((element) {
          listC3.add(
            ListPelajaran(
              'C3',
              element,
            ),
          );
        });
        listKhususC3 = [...listC3];
      } else {
        var list1 = pelajranKhususC1 as List;
        var list2 = pelajranKhususC2 as List;
        var listC1 = <ListPelajaran>[];
        var listC2 = <ListPelajaran>[];
        list1.forEach((element) {
          listC1.add(
            ListPelajaran(
              'C1',
              element,
            ),
          );
        });
        list2.forEach((element) {
          listC2.add(
            ListPelajaran(
              'C2',
              element,
            ),
          );
        });
        listGabunganKhusus = [...listC1, ...listC2];
      }
      listPelajaranUmum.forEach((element) {
        element.pelajaran.forEach((e) {
          listGabunganUmum.add(ListPelajaran(element.id, e));
        });
      });
      print(listGabunganUmum);
      streamData = users
          .collection(tahunAjaran)
          .doc(jurusan)
          .collection(semester)
          .doc(kelas)
          .snapshots();
      listKhususC3
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      listGabunganKhusus
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      listGabunganUmum
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      onLoading.value = false;
    } else {
      Get.offAllNamed('/login');
    }
    super.onInit();
  }
}

class ListPelajaran {
  //Hello
  final String type;
  final String name;

  ListPelajaran(this.type, this.name);
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
