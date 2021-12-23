import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
       
        
        
        SizedBox(
          height: 30,
        ),
        DataWalikelas(
          nama: 'Nama',
          value: controller.guru,
        ),
        DataWalikelas(
          nama: 'Password',
          value: controller.password,
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 9,
        //       child: Card(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Obx(() => controller.cangePassword.value == false
        //               ? Text("Password :" + " " + controller.password.text)
        //               : TextField(
        //                   // readOnly: controller.cangePassword.value,
        //                   controller: controller.password,
        //                 )),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       flex: 1,
        //       child: IconButton(
        //           onPressed: () => controller.cangePassword.value =
        //               !controller.cangePassword.value,
        //           icon: Obx(() => Icon(controller.cangePassword.value == false
        //               ? LineIcons.pen
        //               : LineIcons.save))),
        //     )
        //   ],
        // ),
        DataWalikelas(
          nama: 'NIP',
          value: controller.nip,
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
