import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tes_database/app/modules/guru/controllers/guru_controller.dart';

import 'editing_input_siswa.dart';

class Acount extends StatelessWidget {
  const Acount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GuruController>();
    return ListView(
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => controller.onLoadingImage.value == false
                  ? Card(
                      child: Container(
                        height: 230,
                        width: 230,
                        // margin: EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                              controller.imageGuru.value.path != ''
                                  ? controller.imageGuru.value.path
                                  : controller.image,
                            ),
                          ),
                        ),

                        child: InkWell(
                          onTap: () {
                            controller.getImages(controller.imageGuru);
                          },
                        ),
                      ),
                    )
                  : Container(
                      height: 230,
                      width: 230,
                      child: CircularProgressIndicator()),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        DataWalikelas(
          nama: 'Nama',
          value: controller.guru,
        ),
        Row(
          children: [
            Expanded(
              flex: 9,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => controller.cangePassword.value == false
                      ? Text("Password :" + " " + controller.password.text)
                      : TextField(
                          // readOnly: controller.cangePassword.value,
                          controller: controller.password,
                        )),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () => controller.cangePassword.value =
                      !controller.cangePassword.value,
                  icon: Obx(() => Icon(controller.cangePassword.value == false
                      ? LineIcons.pen
                      : LineIcons.save))),
            )
          ],
        ),
        DataWalikelas(
          nama: 'Kelas',
          value: controller.kelas.capitalize!,
        ),
        DataWalikelas(
          nama: 'Jurusan',
          value: controller.jurusan,
        ),
        DataWalikelas(
          nama: 'Tahun',
          value: controller.tahunAjaran,
        ),
        DataWalikelas(
          nama: 'Semester',
          value: controller.semester.capitalize!,
        ),
      ],
    );
  }
}
