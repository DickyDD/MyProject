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
    // final controller.listEXR = List.generate(sizeJurusan.value, (index) => Rx(''));

    return Obx(
      () => sizeJurusan.value != 0
          ? ListView.builder(
              itemCount: sizeJurusan.value,
              itemBuilder: (context, i) {
                var extrakurikuler = controller.extrakurikuler[i];
                extrakurikuler.value.text = controller.listEXR[i].value;
                // controller.listEXR[i].value = extrakurikuler.value.text;
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
                                    ? 'Extrakurikuler ${controller.listEXR[i].value == '' ? i + 1 : controller.listEXR[i].value}'
                                    : controller.listEXR[i].value,
                              ),
                            ),
                          ),
                          Spacer(),
                          if (sizeJurusan.value != 1)
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
                                              controller.lessEXR(sizeJurusan,
                                                  controller.listEXR[i].value);
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
                              controller: extrakurikuler.value,
                              onChanged: (val) {
                                controller.listEXR[i].value = val;
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
                            controller
                                .inputPKL()
                                .whenComplete(() => controller.saveData());
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
