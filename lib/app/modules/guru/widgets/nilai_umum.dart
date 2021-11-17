import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tes_database/app/modules/guru/controllers/guru_controller.dart';
import 'package:tes_database/app/modules/guru/views/guru_view.dart';

class NilaiUmum extends StatelessWidget {
  NilaiUmum({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GuruController controller = Get.find<GuruController>();
    var list = controller.listGabunganUmum;
    var panjang = list.length.obs;
    var panjangList = 1.obs;
    controller.nilaiKhusus = List.generate(
      panjang.value,
      (index) => TextEditingController(),
    );
    // controller.panjangKhusus.value = panjangList.value;
    controller.dropdownValueUmum = [
      list[0].obs,
    ];
    return Obx(() => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Nilai Pelajaran Umum",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      if (panjangList.value < panjang.value) {
                        panjangList.value++;
                        controller.dropdownValueUmum = [
                          ...controller.dropdownValueUmum,
                          list[0].obs
                        ];
                      } else {
                        print(panjangList.value);
                        Get.defaultDialog(
                          title: 'Peringatan',
                          middleText: 'Jumlah pelajaran telah mencapai batas',
                        );
                      }
                    },
                    icon: Icon(LineIcons.plusCircle),
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
            Divider(),
            ...List.generate(
              panjangList.value,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Card(
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 22, bottom: 22, left: 8),
                          child: Dropdown(
                            dropdownValue: controller.dropdownValueUmum[index],
                            list: list,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Card(
                        // color: ,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EditingInputSiswa(
                            controller: controller.nilaiUmum[index],
                            max: 3,
                            keyboardtype: TextInputType.number,
                            listFormat: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            hintText: 'Nilai',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            if (panjangList.value > 1) {
                              panjangList.value--;
                              controller.dropdownValueUmum.removeAt(
                                index,
                              );
                            } else {
                              print(panjangList.value);
                              Get.defaultDialog(
                                title: 'Peringatan',
                                middleText:
                                    'Jumlah pelajaran tidak boleh kurang dari 1',
                              );
                            }
                          },
                          icon: Icon(LineIcons.minusCircle)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
