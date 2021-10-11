import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import '../controllers/home_controller.dart';

class InputPelajaran extends StatelessWidget {
  const InputPelajaran({
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

                var namaJurusan = controller.listNamaJurusan;
                final namaJurusanLengkap = namaJurusan[i].namaLengkap;
                final namaJurusanSingkat = namaJurusan[i].namaSingkat;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i == 0)
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
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
                                onPressed: () => controller.getPelajaran(),
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
                                onPressed: () => controller.getPelajaran,
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

class DropDownPelajaran extends StatelessWidget {
  const DropDownPelajaran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
