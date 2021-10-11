import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import 'package:tes_database/app/data/widgets/input.dart';
import '../controllers/home_controller.dart';

class InputTahunAjaran extends StatelessWidget {
  const InputTahunAjaran({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Column(
      children: [
        CardShadow(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: input(controller.tahunAjaran, 'Tahun Ajaran'),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {
            controller.inputTahun().whenComplete(() {
              controller.removeClassJurusan();
              controller.getJurusan();
            });
          },
          child: Text('Input siswa'),
        ),
      ],
    );
  }
}