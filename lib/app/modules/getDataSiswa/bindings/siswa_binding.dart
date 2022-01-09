import 'package:get/get.dart';
import 'package:tes_database/app/modules/getDataSiswa/controllers/siswa_controller.dart';

class SiswaDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SiswaDataController>(
      SiswaDataController(),
    );
  }
}
