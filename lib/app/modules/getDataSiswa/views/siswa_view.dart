import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tes_database/app/modules/guru/controllers/guru_controller.dart';

import '../controllers/siswa_controller.dart';

class SiswaDataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SiswaDataController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await Get.find<GuruController>().getBiodata().whenComplete(
                  () => Get.back(),
                );
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        backgroundColor: Colors.yellow[600],
        title: Text(
          'Biodata',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print(controller.jawaban);
          // controller.inputDataSiswa();
        },
        child: Text('Save'),
      ),
    );
  }
}
