import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tes_database/app/modules/guru/controllers/guru_controller.dart';

class SiswaController extends GetxController {
  // final Map data = Get.arguments;

  final data = Get.arguments;

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
  final onEdit = true.obs;

  var panjangKhusus = 1.obs;
  var panjangUmum = 1.obs;
  final formKey = GlobalKey<FormState>();
  // final DataSiswa listDataSiswa = [];

  final indexList = 0.obs;
  final onLoading = false.obs;
  final onLoadingImage = false.obs;

  var listDataEXR = <String>[];
  var nilaiEXR = <TextEditingController>[];
  var keteranganEXR = <TextEditingController>[];
  // var listDataPKL = <ListPelajaran>[];
  var nialiPKL = <TextEditingController>[];
  var lamaPKL = <TextEditingController>[];
  var lokasiPKL = <TextEditingController>[];
  var mitraPKL = <TextEditingController>[];

  var dropdownValueEXR = <Rx<String>>[];
  var dropdownValuePKL = <Rx<ListPelajaran>>[];

  final List<String> listKehadiran = [];

  late List<String> listDPK = [];

  var nialiKehadiran = <TextEditingController>[];
  var nilaiDPK = <TextEditingController>[];

  //List Pelajaran
  var pelajranUmum;
  late RxString singkatanUmum = ''.obs;
  late RxString singkatanKhusus = ''.obs;
  late List<ListPelajaran> listGabunganKhusus = [];
  late List<ListPelajaran> listGabunganUmum = [];
  var dropdownValueKhusus = <Rx<ListPelajaran>>[];
  var dropdownValueUmum = <Rx<ListPelajaran>>[];

  // siswa
  final Rx<XFile> imageSiswa = Rx(XFile(''));

  var urlsSiswa = '';
  var panjangNilai = 0.obs;
  var nilaiKhusus = <TextEditingController>[];
  var keterampilanKhusus = <TextEditingController>[];
  var nilaiUmum = <TextEditingController>[];
  var keterampilanUmum = <TextEditingController>[];

  var checkedValue = true.obs;
  var lulus = "";
  var tidakLulus = "";

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
  late TextEditingController password =
      TextEditingController(text: guru + ' ' + kelas);

  Future<Uint8List> getImages(Rx<XFile> imagevalue) async {
    onLoadingImage.value = true;
    imagevalue.value =
        (await imagePiker.pickImage(source: ImageSource.gallery))!;
    Uint8List file = await imagevalue.value.readAsBytes();
    // url = imagevalue.value.path;

    onLoadingImage.value = false;
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
            'keterangan': keteranganEXR[i].text,
          }
        },
      );
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
    }

    for (var i = 0; i < dropdownValueKhusus.length; i++) {
      var name = dropdownValueKhusus[i].value.name;
      var type = dropdownValueKhusus[i].value.type;
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
    }
    for (var i = 0; i < dropdownValueUmum.length; i++) {
      var name = dropdownValueUmum[i].value.name;
      var type = dropdownValueUmum[i].value.type;
      print("nialai umum" + nilaiUmum[i].text);
      listNilaiUmum.add(
        {
          type: {
            'nama': name,
            'Pengetahuan': nilaiUmum[i].text,
            'Keterampilan': keterampilanUmum[i].text,
          }
        },
      );
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
      }
    }

    await users
        .collection(tahunAjaran)
        .doc(jurusan)
        .collection(semester)
        .doc(kelas)
        .collection("Siswa")
        .doc(data[13].toString())
        .set(
      {
        'nama': nama.text,
        'nis': nis.text,
        "imageSiswa": urlsSiswa == '' ? image : urlsSiswa,
        "noOrtu": noOrtu.text,
        "nilai_umum": listNilaiUmum,
        "nilai_khusus": listNilaiKhusus,
        "namaOrtu": namaOrtu.text,
        "pkl": listPl,
        "extr": x,
        "kehadiran": k,
        "dpk": d,
        "lulus": checkedValue.value == true ? lulus : tidakLulus,
        "catatanAkademik": catatanAkademik.text,
      },
    );
  }

  @override
  void dispose() {
    nilaiKhusus.forEach((c) => c.dispose());
    super.dispose();
  }

  var dataDropUmum = <ListPelajaran>[];
  var dataListUmum = <int>[];
  var dataDropKhusus = <ListPelajaran>[];
  var dataListKhusus = <int>[];
  // var dataDropPKL = <ListPelajaran>[];
  // var dataListPKL = <int>[];
  var dataDropEXR = <ListPelajaran>[];
  var dataListEXR = <int>[];
  var dataDropKehadiran = <ListPelajaran>[];
  var dataListKehadiran = <int>[];
  var dataDropDPK = <ListPelajaran>[];
  var dataListDPK = <int>[];

  @override
  void onInit() async {
    print(data);

    listGabunganKhusus = data[0];
    listGabunganUmum = data[1];
    // listDataPKL = data[2];
    listDataEXR = data[2];
    nama.text = data[3];
    nis.text = data[4];
    noOrtu.text = data[5];
    catatanAkademik.text = data[6];

    var nilai_umum = data[7] as List;
    nilai_umum.forEach((element) {
      element.forEach((key, value) {
        dataDropUmum.add(ListPelajaran(key, value["nama"]));
        nilaiUmum.add(TextEditingController(text: value["Pengetahuan"]));
        keterampilanUmum
            .add(TextEditingController(text: value["Keterampilan"]));
      });
    });

    dataDropUmum.forEach((element) {
      var dataUmum = listGabunganUmum.asMap().entries.where((entry) {
        return entry.value.type == element.type &&
            entry.value.name == element.name;
      }).map((val) => val.key);
      var i = 0;
      if (dataUmum.length == 0) {
        listGabunganUmum.add(ListPelajaran(element.type, element.name));
        i = listGabunganUmum.length;
        dataListUmum.add(i - 1);
      } else {
        i = dataUmum.first;
        dataListUmum.add(i);
      }
    });

    var nilai_khusus = data[8] as List;
    nilai_khusus.forEach((element) {
      element.forEach((key, value) {
        dataDropKhusus.add(ListPelajaran(key, value["nama"]));
        nilaiKhusus.add(TextEditingController(text: value["Pengetahuan"]));
        keterampilanKhusus
            .add(TextEditingController(text: value["Keterampilan"]));
      });
    });

    dataDropKhusus.forEach((element) {
      var datakhusus = listGabunganKhusus.asMap().entries.where((entry) {
        return entry.value.type == element.type &&
            entry.value.name == element.name;
      }).map((val) => val.key);
      var i = 0;
      if (datakhusus.length == 0) {
        listGabunganKhusus.add(ListPelajaran(element.type, element.name));
        i = listGabunganKhusus.length;
        dataListKhusus.add(i - 1);
      } else {
        i = datakhusus.first;
        dataListKhusus.add(i);
      }
    });

    var nilai_pkl = data[9] as List;
    nilai_pkl.forEach((element) {
      element.forEach((key, value) {
        // dataDropPKL.add(ListPelajaran(key, value["lokasi"]));
        mitraPKL.add(TextEditingController(text: key.toString()));
        lokasiPKL.add(TextEditingController(text: value["lokasi"]));
        nialiPKL.add(TextEditingController(text: value["nilai"]));
        lamaPKL.add(TextEditingController(text: value['lama']));
      });
    });

    // dataDropPKL.forEach((element) {
    //   var dataPKL = listDataPKL.asMap().entries.where((entry) {
    //     return entry.value.type == element.type &&
    //         entry.value.name == element.name;
    //   }).map((val) => val.key);
    //   var i = 0;
    //   if (dataPKL.length == 0) {
    //     listDataPKL.add(ListPelajaran(element.type, element.name));
    //     i = listDataPKL.length;
    //     dataListPKL.add(i - 1);
    //   } else {
    //     i = dataPKL.first;
    //     dataListPKL.add(i);
    //   }
    // });

    var nilai_EXR = data[10] as List;
    nilai_EXR.forEach((element) {
      element.forEach((key, value) {
        var data = listDataEXR.where((element) => element == key.toString());
        if (data.length == 0) {
          listDataEXR.add(key.toString());
          dropdownValueEXR.add(key.toString().obs);
        } else {
          dropdownValueEXR.add(key.toString().obs);
        }

        nilaiEXR.add(TextEditingController(text: value["nilai"]));
        keteranganEXR.add(TextEditingController(text: value["keterangan"]));
      });
    });
    var nilai_Kehadiran = data[11] as List;
    nilai_Kehadiran.forEach((element) {
      element.forEach((key, value) {
        listKehadiran.add(key);
        nialiKehadiran.add(TextEditingController(text: value["nilai"]));
      });
    });
    var nilai_DPK = data[12] as List;
    nilai_DPK.forEach((element) {
      element.forEach((key, value) {
        listDPK.add(key);
        nilaiDPK.add(TextEditingController(text: value["nilai"]));
      });
    });

    image = data[14];
    namaOrtu.text = data[15];
    tahunAjaran = data[16];
    jurusan = data[17];
    kelas = data[18];
    if (data[19].toString().split(" ")[0] == "Naik") {
      checkedValue.value = true;
    } else {
      checkedValue.value = false;
    }

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
    
    super.onInit();
  }
}
