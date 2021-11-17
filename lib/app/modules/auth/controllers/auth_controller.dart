import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class AuthController extends GetxController {
  final users = FirebaseFirestore.instance;
  final List<TextEditingController> listC = [
    TextEditingController(),
    TextEditingController(),
    // TextEditingController(),
  ];
  final hintText = [
    'NIP',
    'Password'.toUpperCase(),
    // 'Token',
  ];
  final inconPrefix = [
    LineIcons.addressBookAlt,
    LineIcons.lock,
    // LineIcons.exclamationCircle,
  ];

  var validator = [];
  void loginFake(String gmail, String password) {
    if (gmail == 'Admin@gmail.com' && password == '12345Aa') {
      Get.offNamed('/admin', arguments: [
        gmail,
        password,
      ]);
    } else {
      users
          .collection('auth users')
          .where('nip', isEqualTo: gmail)
          .where('password', isEqualTo: password)
          .get()
          .then(
            (value) => value.docs.forEach(
              (element) {
                bool aktif = element.data()['aktif'];
                if (aktif == true) {
                  Get.offNamed(
                    '/guru',
                    arguments: {
                      'jumlah': 2.toString(),
                      'tahun': element.data()['tahun'].toString(),
                      'jurusan': element.data()['jurusan'],
                      'semester': element.data()['semester'].toString(),
                      'kelas': element.data()['kelas'].toString(),
                      'guru': element.data()['walikelas'].toString(),
                    },
                  );
                  
                } else {
                  Get.defaultDialog(
                    title: 'Warning',
                    middleText: 'Akun ini sudah di non aktifkan',
                  );
                }
              },
            ),
          );
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
