// import 'package:easy_mask/easy_mask.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tes_database/app/data/widgets/button.dart';
// import 'package:tes_database/app/data/widgets/card_shadow.dart';
// import 'package:tes_database/app/data/widgets/input.dart';
// import '../controllers/home_controller.dart';

// class InputTahunAjaran extends StatelessWidget {
//   const InputTahunAjaran({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<HomeController>();
//     return Column(
//       children: [
//         CardShadow(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: input(
//               controller.tahunAjaran,
//               'Tahun Ajaran',
//               TextInputType.number,
//               [TextInputMask(mask: '9999-9999')],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 40,
//         ),
//         ButtonCustom(
//             nama: 'Input Tahun',
//             onTap: () async {
//               Get.defaultDialog(
//                   title: 'Masukan Data',
//                   middleText: 'Anda Yakin?',
//                   actions: [
//                     ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(Colors.red),
//                       ),
//                       onPressed: () {
//                         controller.inputTahun().whenComplete(() {
//                           controller.removeClassJurusan();
//                           controller.changeDrobdown();
//                           controller
//                               .getJurusan()
//                               .whenComplete(() => controller.saveData());
//                         });
//                         Get.back();
//                       },
//                       child: Text('Yakin'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       child: Text('Tidak'),
//                     )
//                   ]);
//             })
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import '../controllers/home_controller.dart';

class InputTahunAjaran extends StatelessWidget {
  const InputTahunAjaran({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    // final jumlahJurusan = controller.listJurusan.length.obs;
    var width = MediaQuery.of(context).size.width;
    final sizeJurusan = controller.tahun.length.obs;
    // controller.listEXR = List.generate(sizeJurusan.value, (index) => Rx(''));

    return Obx(
      () => sizeJurusan.value != 0
          ? ListView.builder(
              itemCount: sizeJurusan.value,
              itemBuilder: (context, i) {
                var Tahun = controller.ListTahun[i];
                Tahun.value.text = controller.tahun[i];
                // controller.listEXR[i].value = Tahun.value.text;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i == 0)
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Tahun',
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
                                    controller.addTahun(sizeJurusan),
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
                                    ? 'Tahun ${controller.tahun[i] == '' ? i + 1 : controller.tahun[i]}'
                                    : controller.tahun[i],
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
                                                controller.lessTahun(
                                                  sizeJurusan,
                                                  i,
                                                );
                                                Get.back();
                                              }),
                                          ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text('Tidak'))
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
                              controller: Tahun.value,
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
                             controller.inputTahun().whenComplete(() {
                          controller.removeClassJurusan();
                          controller.changeDrobdown();
                          controller
                                  .getJurusan()
                                  .whenComplete(() => controller.saveData());
                        });
                        Get.back();
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
