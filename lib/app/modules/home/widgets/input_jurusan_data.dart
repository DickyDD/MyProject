import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import '../controllers/home_controller.dart';

class InputJurusan extends StatelessWidget {
  const InputJurusan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final jumlahJurusan = controller.listJurusan.length.obs;
    var width = MediaQuery.of(context).size.width;
    final sizeJurusan = controller.listJurusan.length.obs;

    return Obx(
      () => jumlahJurusan.value != 0
          ? ListView.builder(
              itemCount: sizeJurusan.value,
              itemBuilder: (context, i) {
                final jurusanC = controller.listJurusan[i];
                final jsingkatanC = controller.listSingkatanJurusan[i];
                // final jumlahKelasC9 = controller.listJumlahkelas9[i];
                // final jumlahKelasC10 = controller.listJumlahkelas10[i];
                // final jumlahKelasC11 = controller.listJumlahkelas11[i];
                var namaJurusan = controller.listNamaJurusan;
                final namaJurusanLengkap = namaJurusan[i].namaLengkap;
                final namaJurusanSingkat = namaJurusan[i].namaSingkat;

                jurusanC.text = namaJurusanLengkap.value;
                jsingkatanC.text = namaJurusanSingkat.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i == 0)
                      Row(
                        children: [
                          // CardShadow(
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(5.0),
                          //     child: Dropdown(
                          //       dropdownValue: controller.panjangList,
                          //       list: controller.tahun,
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding:const EdgeInsets.all(5.0),
                            child: Text(
                              'Jurusan',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          CardShadow(
                            child: TextButton(
                                onPressed: () =>
                                    controller.addJurusan(sizeJurusan),
                                child: Text('+')),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          CardShadow(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5,),
                              child: Text(
                                width > 575
                                    ? 'Jurusan ${namaJurusanLengkap.value == '' ? i + 1 : namaJurusanLengkap.value + ' (${namaJurusanSingkat.value})'}'
                                    : width >= 466
                                        ? namaJurusanLengkap.value
                                        : namaJurusanSingkat.value,
                              ),
                            ),
                          ),
                          Spacer(),
                          CardShadow(
                            child: TextButton(
                                onPressed: () => controller.lessJurusan(
                                      namaJurusan[i],
                                      sizeJurusan,
                                      jurusanC,
                                      jsingkatanC,
                                      // jumlahKelasC9,
                                      // jumlahKelasC10,
                                      // jumlahKelasC11,
                                    ),
                                child: Text('-')),
                          ),
                        ],
                      ),
                    ),
                    CardShadow(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: jurusanC,
                              onChanged: (val) {
                                namaJurusanLengkap.value = val;
                              },
                              decoration: InputDecoration(hintText: 'Jurusan'),
                            ),
                            TextField(
                              controller: jsingkatanC,
                              onChanged: (val) {
                                namaJurusanSingkat.value = val;
                              },
                              decoration:
                                  InputDecoration(hintText: 'Singkatan'),
                            ),
                            // TextField(
                            //   controller: jumlahKelasC9,
                            //   decoration:
                            //       InputDecoration(hintText: 'jumlah kelas 9'),
                            // ),
                            // TextField(
                            //   controller: jumlahKelasC10,
                            //   decoration:
                            //       InputDecoration(hintText: 'jumlah kelas 10'),
                            // ),
                            // TextField(
                            //   controller: jumlahKelasC11,
                            //   decoration:
                            //       InputDecoration(hintText: 'jumlah kelas 11'),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (i == sizeJurusan.value - 1)
                      Center(
                          child: ButtonCustom(
                              nama: 'Save',
                              onTap: () async {
                                controller.inputJurusan();
                                controller.getDataKelas();
                              })),
                  ],
                );
              },
            )
          : Center(
              child: Text('data Null'),
            ),
    );
  }
}
