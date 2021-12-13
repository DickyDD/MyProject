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
  var urlPdf = "";
  List<String> namaIndex = [
    'Akun',
    'Input',
    'Lihat',
    'Exit',
  ];

  var listDataEXR = <String>[];
  var nilaiEXR = <TextEditingController>[];
  var keteranganEXR = <TextEditingController>[];
  var nialiPKL = <TextEditingController>[];
  var lamaPKL = <TextEditingController>[];
  var lokasiPKL = <TextEditingController>[];
  var mitraPKL = <TextEditingController>[];
  // var panjangPKL = 1.obs;
  var checkedValue = true.obs;
  final formKey = GlobalKey<FormState>();

  late String tahunAjaran = '2021-2022',
      jurusan = 'Bisnis Konstruksi dan Property',
      semester = 'semester 1',
      kelas = 'kelas X BKP 1',
      gmail = '23423 452643 5 646',
      guru = 'Dicky1',
      // /2021-2022//semester 1/
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

  var bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  var hari = DateTime.now().day;
  var month = DateTime.now().month;
  var tahun = DateTime.now().year;

  var lulus = "";
  var tidakLulus = "";

  var nialiKehadiran = <TextEditingController>[];
  var nilaiDPK = <TextEditingController>[];
  var pelajranKhususC1;
  var pelajranKhususC2;
  var pelajranKhususC3;
  var nilaiKknKhususC1;
  var nilaiKknKhususC2;
  var nilaiKknKhususC3;
  var dropdownValueKhusus = <Rx<ListPelajaran>>[];

  var dropdownValueUmum = <Rx<ListPelajaran>>[];

  var dropdownValueEXR = <Rx<String>>[];
  // var dropdownValuePKL = <Rx<ListPelajaran>>[];

  // siswa
  final Rx<XFile> imageSiswa = Rx(XFile(''));

  var urlsSiswa = '';
  var panjangNilai = 0.obs;
  var nilaiKhusus = <TextEditingController>[];
  var keterampilanKhusus = <TextEditingController>[];
  var keterampilanUmum = <TextEditingController>[];
  var nilaiUmum = <TextEditingController>[];

  // var pelajaran = <Rx<String>>[];
  late TextEditingController nama = TextEditingController();
  late TextEditingController nis = TextEditingController();
  late TextEditingController noOrtu = TextEditingController();
  late TextEditingController namaOrtu = TextEditingController();
  late TextEditingController catatanAkademik = TextEditingController();

  //Guru
  final Rx<XFile> imageGuru = Rx(XFile(''));
  var fileGuru;
  var urlsGuru = '';
  final cangePassword = false.obs;
  var password = "";
  var kepalaSekolahNama = "";
  var kepalaSekolahNIP = "";

  Future getKepalaSekolah() async {
    await users
        .collection('Data Sekolah')
        .doc('Data Kepala Sekolah')
        .get()
        .then((value) {
      kepalaSekolahNama = value.data()!['Nama'];
      kepalaSekolahNIP = value.data()!['NIP'];
    });
  }

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
    int nilaiBlmTuntas = 0;
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
            'keterangan': keteranganEXR[i].text,
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
      if (dropdownValueKhusus[i].value.kkn > int.parse(nilaiKhusus[i].text)) {
        nilaiBlmTuntas++;
      }
      print("nialai Khusus" + nilaiKhusus[i].text);
      listNilaiKhusus.add(
        {
          type: {
            'nama': name,
            'Pengetahuan': nilaiKhusus[i].text,
            'Keterampilan': keterampilanKhusus[i].text,
          }
        },
      );
      nilaiKhusus[i].clear();
      keterampilanKhusus[i].clear();
    }
    for (var i = 0; i < dropdownValueUmum.length; i++) {
      var name = dropdownValueUmum[i].value.name;
      var type = dropdownValueUmum[i].value.type;
      print("nialai umum" + nilaiUmum[i].text);
      if (dropdownValueUmum[i].value.kkn > int.parse(nilaiUmum[i].text)) {
        nilaiBlmTuntas++;
      }
      listNilaiUmum.add(
        {
          type: {
            'nama': name,
            'Pengetahuan': nilaiUmum[i].text,
            'Keterampilan': keterampilanUmum[i].text,
          }
        },
      );
      nilaiUmum[i].clear();
      keterampilanUmum[i].clear();
    }
    print(listNilaiUmum);
    if (kelas.split(' ')[1] != 'X') {
      for (var i = 0; i < nialiPKL.length; i++) {
        var lokasi = lokasiPKL[i].text;
        var mitra = mitraPKL[i].text;
        print(nialiPKL[i].text);
        listPl.add(
          {
            mitra: {
              'lokasi': lokasi,
              'lama': lamaPKL[i].text,
              'nilai': nialiPKL[i].text,
            }
          },
        );
        lokasiPKL[i].clear();
        mitraPKL[i].clear();
        lamaPKL[i].clear();
        nialiPKL[i].clear();
      }
    }

    // if (nilaiBlmTuntas != 0) {
    //     Get.defaultDialog(title: tidakLulus);
    //   }

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
        "lulus": nilaiBlmTuntas != 0 ? lulus : tidakLulus,
        "namaOrtu": namaOrtu.text,
        "catatanAkademik": catatanAkademik.text,
      },
    ).whenComplete(() {
      nama.clear();
      nis.clear();
      noOrtu.clear();
      catatanAkademik.clear();
      
    });
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
      nilaiKknKhususC1 = value['kknC1'];
      nilaiKknKhususC2 = value['kknC2'];
      nilaiKknKhususC3 = value['kknC3'];
    });
    print(data.data()!);
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

  // Future getPKL() async {
  //   var data = await users.collection('Data Sekolah').doc('Data PKL').get();
  //   data.data()!['data'].forEach((key, value) {
  //     listDataPKL.add(ListPelajaran(key.toString(), value.toString()));
  //     print(value);
  //   });
  // }
  var tanggal;

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
      password = data['password'];
      tahunAjaran = data['tahun'];
      jurusan = data['jurusan'];
      semester = data['semester'];
      kelas = data['kelas'];
      guru = data['guru'];

      await getDataPelajaranKhusus();
      await getPelajaranUmum();
      await getEXR();
      nialiPKL = List.generate(
        1,
        (index) => TextEditingController(),
      );
      lamaPKL = List.generate(
        1,
        (index) => TextEditingController(),
      );
      mitraPKL = List.generate(
        1,
        (index) => TextEditingController(),
      );
      lokasiPKL = List.generate(
        1,
        (index) => TextEditingController(),
      );
      // await getPKL();
      // ...pelajranKhususC1, ...pelajranKhususC2
      if (semester.toLowerCase() == "semester 2") {
        lulus = kelas.split(' ')[1] == 'X'
            ? 'Naik ke Kelas XI'
            : kelas.split(' ')[1] == 'XI'
                ? 'Naik ke Kelas XII'
                : 'Lulus';
        tidakLulus = kelas.split(' ')[1] == 'X'
            ? 'Tinggal di Kelas X'
            : kelas.split(' ')[1] == 'XI'
                ? 'Tinggal di Kelas XI'
                : 'Tidak Lulus';
      } else {
        lulus = "";
        tidakLulus = "";
      }

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
        listKhususC3 = [...listC3];
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
              int.parse(element.KKN[i]),
            ),
          );
        }
        listGabunganUmum.forEach((element) {
          print(element.name);
          print(element.kkn);
        });
      });

      streamData = users
          .collection(tahunAjaran)
          .doc(jurusan)
          .collection(semester)
          .doc(kelas)
          .snapshots();
      listKhususC3.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
      listGabunganKhusus.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
      listGabunganUmum.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
      tanggal = 'Makassar, $hari ${bulan[month - 1]} $tahun';
      onLoading.value = false;
      await getKepalaSekolah();
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
  final int kkn;

  ListPelajaran(this.type, this.name, this.kkn);
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
