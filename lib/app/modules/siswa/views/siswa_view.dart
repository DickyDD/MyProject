import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/input.dart';
import '../controllers/siswa_controller.dart';

class SiswaView extends GetView<SiswaController> {
  @override
  Widget build(BuildContext context) {
    final int jumlah = controller.jumlah;
    return Scaffold(
      appBar: AppBar(
        title: Text('SiswaView'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: jumlah,
        itemBuilder: (context, i) {
          final nama = controller.name[i];
          final id = controller.id[i];
          final noOrtu = controller.noOrtu[i];
          final image = controller.images[i];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => controller.getImages(image),
                        child: Container(
                          height: 120,
                          width: 120,
                          child: Obx(
                            () => CircleAvatar(
                              child: image.value.path != ''
                                  ? Image.file(image.value)
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            input(nama, 'Nama ${i + 1}'),
                            input(id, 'Id ${i + 1}'),
                            input(noOrtu, 'No Ortu ${i + 1}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (jumlah-1 == i)
                TextButton(
                  child: Text('data'),
                  onPressed: controller.getData,
                ),
             
            ],
          );
        },
      ),
    );
  }
}
