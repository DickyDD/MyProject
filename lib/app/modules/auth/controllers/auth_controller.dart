import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class AuthController extends GetxController {
  final List<TextEditingController> listC = [
    TextEditingController(),
    TextEditingController(),
    // TextEditingController(),
  ];
  final hintText = [
    'Gmail',
    'Password',
    // 'Token',
  ];
  final inconPrefix = [
    LineIcons.envelope,
    LineIcons.lock,
    // LineIcons.exclamationCircle,
  ];

  void loginFake(String gmail, String password) {
    if (gmail == 'Admin@gmail.com' && password == '123') {
      Get.offNamed('/admin');
    } else if (gmail == 'guruTes1@gmail.com' && password == '123') {
      Get.offNamed('/guru');
    }
  }

  Future<UserCredential?> login() async {
    try {
      // UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "tess@gmail.com",
        password: "444456Dd@",
      );

      // return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
