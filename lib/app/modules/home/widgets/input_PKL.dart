import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import '../controllers/home_controller.dart';

class InputPKL extends StatelessWidget {
  const InputPKL({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    // final jumlahJurusan = controller.listJurusan.length.obs;
    var width = MediaQuery.of(context).size.width;
    final sizeJurusan = controller.listPKL.length.obs;

    return Obx(
      () => sizeJurusan.value != 0
          ? ListView.builder(
              itemCount: sizeJurusan.value,
              itemBuilder: (context, i) {
                final mitraC = controller.listMitra[i];
                final lokasiC = controller.listLokasi[i];
                var namaJurusan = controller.listPKL;
                final mitra = namaJurusan[i].namaLengkap;
                final lokasi = namaJurusan[i].namaSingkat;

                mitraC.text = mitra.value;
                lokasiC.text = lokasi.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i == 0)
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Praktik Kerja Lapangan',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          CardShadow(
                            child: TextButton(
                                onPressed: () => controller.addPKL(sizeJurusan),
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
                                    ? 'Mitra ${mitra.value == '' ? i + 1 : mitra.value + ' lokasi ${lokasi.value}'}'
                                    : width >= 466
                                        ? mitra.value
                                        : lokasi.value,
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
                                              controller.lessPKL(
                                                namaJurusan[i],
                                                sizeJurusan,
                                                mitraC,
                                                lokasiC,
                                              );
                                              // controller.listPelajaranKhusus.removeWhere((e)=>e.id==mitraC.text);
                                              Get.back();
                                            })
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
                              controller: mitraC,
                              onChanged: (val) {
                                mitra.value = val;
                              },
                              decoration: InputDecoration(hintText: 'Mitra'),
                            ),
                            TextField(
                              controller: lokasiC,
                              onChanged: (val) {
                                lokasi.value = val;
                              },
                              decoration: InputDecoration(hintText: 'Lokasi'),
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
                            controller.inputPKL();
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
