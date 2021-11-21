import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import '../controllers/home_controller.dart';

class InputExtrakurikuler extends StatelessWidget {
  const InputExtrakurikuler({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    // final jumlahJurusan = controller.listJurusan.length.obs;
    var width = MediaQuery.of(context).size.width;
    final sizeJurusan = controller.listEXR.length.obs;
    final listString = List.generate(sizeJurusan.value, (index) => Rx(''));

    return Obx(
      () => sizeJurusan.value != 0
          ? ListView.builder(
              itemCount: sizeJurusan.value,
              itemBuilder: (context, i) {
                var extrakurikuler = controller.extrakurikuler[i];
                extrakurikuler.value.text = controller.listEXR[i].value;
                listString[i].value = extrakurikuler.value.text;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i == 0)
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Extrakurikuler',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          CardShadow(
                            child: TextButton(
                                onPressed: () => controller.addEXR(sizeJurusan),
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
                                    ? 'Extrakurikuler ${listString[i].value == '' ? i + 1 : listString[i].value}'
                                    : listString[i].value,
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
                                              controller.lessEXR(sizeJurusan,listString[i].value);
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
                              controller: extrakurikuler.value,
                              onChanged: (val) {
                                listString[i].value = val;
                              },
                              decoration: InputDecoration(hintText: 'Mitra'),
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
