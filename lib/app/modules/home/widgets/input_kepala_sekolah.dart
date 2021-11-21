import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import 'package:tes_database/app/data/widgets/input.dart';
import '../controllers/home_controller.dart';

class InputKepalaSekolah extends StatelessWidget {
  const InputKepalaSekolah({
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
              controller.kepalaSekolahNama,
              'Nama',
              null,
              null,
            ),
          ),
        ),
        CardShadow(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: input(
              controller.kepalaSekolahNIP,
              'NIP',
              TextInputType.number,
              // TextInputType.number,
              [
                TextInputMask(mask: '99999 999999 9 999'),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        ButtonCustom(
            nama: 'Ganti',
            onTap: () async {
              Get.defaultDialog(
                  title: 'Masukan Data',
                  middleText: 'Anda Yakin?',
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () async {
                        await controller.inputkepalaSekolah();
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
