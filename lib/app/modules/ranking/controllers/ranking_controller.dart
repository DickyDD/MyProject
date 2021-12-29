import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RankingController extends GetxController {
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
  final indexDataSiswa = RankingSiswa(
    '213321',
    'diki',
    '12313',
    [
      Ranking(
        "type",
        "name",
        0,
        0,
        0,
      )
    ],
    [
      Ranking(
        "type",
        "name",
        0,
        0,
        0,
      ),
    ],
    0,
    0,
  ).obs;
  final onloading = false.obs;
  late List<RankingSiswa> dataSiswa = <RankingSiswa>[];

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
          (value) => dataSiswa = value.docs.map((e) {
            var dataListUmum = e.data()['nilai_umum'] as List;
            var dataListKhusus = e.data()['nilai_khusus'] as List;
            var listPelajaranDataUmum = <Ranking>[];
            var listPelajaranDataKhusus = <Ranking>[];
            var jumlahNilaiKhusus = 0.0;
            var jumlahNilaiUmum = 0.0;
            dataListKhusus.forEach((element) {
              var val = element as Map;

              val.forEach((key, value) {
                // var noKhusus = 0;
                // print(noKhusus++);
                listPelajaranDataKhusus.add(
                  Ranking(
                    key,
                    value['nama'],
                    value['kkn'],
                    int.tryParse(value['Pengetahuan'].toString()) ?? 0,
                    int.tryParse(value['Keterampilan'].toString()) ?? 0,
                  ),
                );
              });
            });

            dataListUmum.forEach((element) {
              var val = element as Map;

              val.forEach((key, value) {
                listPelajaranDataUmum.add(
                  Ranking(
                    key,
                    value['nama'],
                    value['kkn'],
                    int.tryParse(value['Pengetahuan'].toString()) ?? 0,
                    int.tryParse(value['Keterampilan'].toString()) ?? 0,
                  ),
                );
              });
            });

            listPelajaranDataKhusus.forEach((element) {
              jumlahNilaiKhusus = jumlahNilaiKhusus +
                  ((element.keterampilan + element.pengetahuan) / 2);
              // print("keterampilan : ${element.keterampilan}");
              // print("pengetahuan : ${element.pengetahuan}");
              // print("jumlah Nilai Khusus : $jumlahNilaiKhusus");
              // print((element.keterampilan + element.pengetahuan) / 2);
            });

            listPelajaranDataUmum.forEach((element) {
              jumlahNilaiUmum = jumlahNilaiUmum +
                  ((element.keterampilan + element.pengetahuan) / 2);
              // print("keterampilan : ${element.keterampilan}");
              // print("pengetahuan : ${element.pengetahuan}");
              // print("jumlah Nilai Umum : $jumlahNilaiUmum");
              // print((element.keterampilan + element.pengetahuan) / 2);
            });

            // jumlahNilai = 0;

            return RankingSiswa(
              e.id,
              e.data()['nama'],
              e.data()['nis'],
              listPelajaranDataKhusus,
              listPelajaranDataUmum,
              no++,
              jumlahNilaiKhusus + jumlahNilaiUmum,
            );
          }).toList(),
        )
        .whenComplete(() => onloading.value = !onloading.value);
  }

  var jumlahNilai = 0.0;
  var jumlahNilaiRata = 0.0;
  var nilaiMax = 0.0;
  var nilaiMin = 0.0;

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
      dataSiswa.sort((a, b) {
        var nilai = a.nama!.compareTo(b.nama!);
        print("${a.nama} -- ${b.nama} $nilai");
        if (b.jumlahNilai.compareTo(a.jumlahNilai) == 0) {
          return a.nama!.compareTo(b.nama!);
        }
        return b.jumlahNilai.compareTo(a.jumlahNilai);
      });
      indexDataSiswa.value = dataSiswa.first;
      dataSiswa.forEach((e) {
        jumlahNilai = jumlahNilai + e.jumlahNilai;
        print(jumlahNilai);
      });
      jumlahNilaiRata = jumlahNilai / dataSiswa.length;
      nilaiMax = dataSiswa.first.jumlahNilai;
      nilaiMin = dataSiswa.last.jumlahNilai;
    } else {
      Get.offAllNamed('/login');
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

class Ranking {
  final String type;
  final String name;
  final int kkn;
  final int pengetahuan;
  final int keterampilan;
  Ranking(this.type, this.name, this.kkn, this.pengetahuan, this.keterampilan);
}

class RankingSiswa {
  final String? id;
  final String? nama;
  final String? nis;
  final List<Ranking> pelajaranKhusus;
  final List<Ranking> pelajaranUmum;
  final double jumlahNilai;
  final int no;
  RankingSiswa(
    this.id,
    this.nama,
    this.nis,
    this.pelajaranKhusus,
    this.pelajaranUmum,
    this.no,
    this.jumlahNilai,
  );
}
