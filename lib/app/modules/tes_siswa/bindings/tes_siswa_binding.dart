import 'package:get/get.dart';

import '../controllers/tes_siswa_controller.dart';

class TesSiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TesSiswaController>(
       TesSiswaController(),
    );
  }
}
