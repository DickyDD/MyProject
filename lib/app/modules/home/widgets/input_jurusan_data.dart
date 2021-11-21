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
    // final jumlahJurusan = controller.listJurusan.length.obs;
    var width = MediaQuery.of(context).size.width;
    final sizeJurusan = controller.listJurusan.length.obs;

    return Obx(
      () => sizeJurusan.value != 0
          ? ListView.builder(
              itemCount: sizeJurusan.value,
              itemBuilder: (context, i) {
                final jurusanC = controller.listJurusan[i];
                final jsingkatanC = controller.listSingkatanJurusan[i];
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
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Kompetensi Keahlian',
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
                                horizontal: 10,
                                vertical: 5,
                              ),
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
                                onPressed: () {
                                  Get.defaultDialog(
                                      middleText: 'Yakin Ingin menghapus',
                                      title: 'Hapus?',
                                      actions: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                            ),
                                            child: Text('Yakin'),
                                            onPressed: () async {
                                              controller.lessJurusan(
                                                namaJurusan[i],
                                                sizeJurusan,
                                                jurusanC,
                                                jsingkatanC,
                                              );
                                              await controller.delete(
                                                jurusanC.text,
                                              );
                                              controller.listPelajaranKhusus
                                                  .removeWhere((e) =>
                                                      e.id == jurusanC.text);
                                              // controller.listPelajaranKhusus.removeWhere((e)=>e.id==jurusanC.text);
                                              Get.back();
                                            }),
                                            ElevatedButton(onPressed: (){Get.back();}, child: Text('Tidak'))
                                      ]);
                                },
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
                            controller.inputJurusan().whenComplete(() {
                              controller.onLoading.value = true;
                              controller.removeListKhusus();
                              controller.getPelajaranKhusus().whenComplete(
                                    () => controller.onLoading.value = false,
                                  );
                            });
                          },
                        ),
                      ),
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
