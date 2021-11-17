import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/button.dart';
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
            child: input(
              controller.tahunAjaran,
              'Tahun Ajaran',
              TextInputType.number,
              [TextInputMask(mask: '9999-9999')],
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        ButtonCustom(
            nama: 'Input Tahun',
            onTap: () async {
              Get.defaultDialog(
                  title: 'Masukan Data',
                  middleText: 'Anda Yakin?',
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        controller.inputTahun().whenComplete(() {
                          controller.removeClassJurusan();
                          controller.changeDrobdown();
                          controller.getJurusan();
                        });
                        Get.back();
                      },
                      child: Text('Yakin'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Tidak'),
                    )
                  ]);
            })
      ],
    );
  }
}
