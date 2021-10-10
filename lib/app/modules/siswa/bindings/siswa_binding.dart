import 'package:get/get.dart';

import '../controllers/siswa_controller.dart';

class SiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SiswaController>(
      () => SiswaController(),
    );
  }
}
