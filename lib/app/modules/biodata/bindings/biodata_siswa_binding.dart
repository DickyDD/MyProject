import 'package:get/get.dart';
import 'package:tes_database/app/modules/biodata/controllers/biodata_siswa_controller.dart';

class BiodataSiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BiodataSiswaController>(
      BiodataSiswaController(),
    );
  }
}
