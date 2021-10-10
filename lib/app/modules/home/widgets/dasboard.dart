import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import '../controllers/home_controller.dart';

class Dasboard extends StatelessWidget {
  const Dasboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final namaJurusan = controller.listNamaJurusan;
    final tahunAjaran = controller.tahun;
    var dataJurusan = List.generate(
      controller.listNamaJurusan.length,
      (index) => Padding(
        padding:
            const EdgeInsets.only(bottom: 5.0, left: 10, right: 10, top: 2),
        child: Text(
          "${namaJurusan[index].namaLengkap.value} (${namaJurusan[index].namaSingkat.value})",
        ),
      ),
    );

    var dataTahun = List.generate(
      controller.tahun.length,
      (index) => Padding(
        padding:
            const EdgeInsets.only(bottom: 5.0, left: 10, right: 10, top: 2),
        child: Text(
          "${tahunAjaran[index]}",
        ),
      ),
    );

    return ListView(
      children: [
        Wrap(
          spacing: 30,
          runSpacing: 30,
          children: [
            CardShadow(
              width: 373,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Data Jurusan',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...dataJurusan
                  ]),
            ),
            CardShadow(
              width: 123,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Data Tahun',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...dataTahun
                  ]),
            ),
          ],
        )
      ],
    );
  }
}