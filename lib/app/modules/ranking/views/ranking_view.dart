import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';

import '../controllers/ranking_controller.dart';

class RankingView extends GetView<RankingController> {
  @override
  Widget build(BuildContext context) {
    var sC = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        title: Text(
          'Ranking',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.onloading.value == false
            ? Scrollbar(
                controller: sC,
                isAlwaysShown: true,
                child: ListView.builder(
                  controller: sC,
                  itemCount: controller.dataSiswa.length,
                  itemBuilder: (ctx, i) {
                    var data = controller.dataSiswa[i];
                    return Column(
                      children: [
                        if (i == 0) infoNilai(),
                        listSiswa(i, data),
                      ],
                    );
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  CardShadow infoNilai() {
    return CardShadow(
      // color: Colors.grey[350],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            nilaiRow("Jumlah Semua Nilai : ${controller.jumlahNilai}",
                "Jumlah Nilai Rata-Rata : ${controller.jumlahNilaiRata.toStringAsFixed(2)}"),
            nilaiRow("Nilai Tertinggi : ${controller.nilaiMax}",
                "Nilai Terendah : ${controller.nilaiMin}"),
          ],
        ),
      ),
    );
  }

  Row nilaiRow(String nilai1, String nilai2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          nilai1,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          nilai2,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  CardShadow listSiswa(int i, RankingSiswa data) {
    var kurangKKM = 0;

    data.pelajaranKhusus.forEach((e) {
      var nilaiPengetahuan = (e.pengetahuan / 100 * 30);
      var nilaiKeterampilan = (e.keterampilan / 100 * 70);
      if ((nilaiKeterampilan + nilaiPengetahuan) < e.kkn) {
        // print(e.kkn);
        // print(nilaiKeterampilan + nilaiPengetahuan);
        kurangKKM++;
      }
    });
    data.pelajaranUmum.forEach((e) {
      var nilaiPengetahuan = (e.pengetahuan / 100 * 30);
      var nilaiKeterampilan = (e.keterampilan / 100 * 70);
      if ((nilaiKeterampilan + nilaiPengetahuan) < e.kkn) {
        // print(e.kkn);
        // print(nilaiKeterampilan + nilaiPengetahuan);
        kurangKKM++;
      }
    });
    return CardShadow(
      child: ExpansionTile(
        collapsedBackgroundColor:
            kurangKKM == 0 ? Colors.white : Colors.red[100],
        backgroundColor: kurangKKM == 0 ? Colors.white : Colors.red[100],
        leading: CircleAvatar(child: Text("${i + 1}")),
        title: Text(data.nama!),
        subtitle: Text(data.nis!),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jumlah Nilai Akhir : ${data.jumlahNilai.toString()}",
            ),
            Text(
              "Jumlah Nilai Yang di Isi : ${data.pelajaranKhusus.length + data.pelajaranUmum.length}",
            ),
          ],
        ),
        expandedAlignment: Alignment.topLeft,
        childrenPadding: EdgeInsets.all(15),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Text(
            "Muatan Nasional",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Divider(),
          ...dataNilai(data.pelajaranUmum, Colors.blue[100]!),
          Divider(),
          Text(
            "Muatan Peminatan Kejuruan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Divider(),
          ...dataNilai(data.pelajaranKhusus, Colors.yellow[100]!),
          Divider(),
        ],
      ),
    );
  }

  List<Widget> dataNilai(List<Ranking> pelajaran, Color color) {
    return List.generate(pelajaran.length, (index) {
      var value = pelajaran[index];
      return Container(
        color: color,
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${value.type} : ${value.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "KKM : ${value.kkn.toString()}",
            ),
            Text(
              "Keterampilan : ${value.keterampilan.toString()}",
            ),
            Text(
              "Pengetahuan : ${value.pengetahuan.toString()}",
            ),
            Text(
              "Nilai Akhir : ${(value.pengetahuan / 100 * 30) + (value.keterampilan / 100 * 70)}",
            ),
          ],
        ),
      );
    });
  }
}
