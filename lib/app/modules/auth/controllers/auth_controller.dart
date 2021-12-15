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
  ];
  final hintText = [
    'NIP/NIK',
    'Password'.toUpperCase(),
  ];
  final inconPrefix = [
    LineIcons.addressBookAlt,
    LineIcons.lock,
  ];

  var validator = [];
  void loginFake(String gmail, String password) {
    if (gmail == 'AdminKid@gmail.com' && password == '12345Aa') {
      Get.offNamed('/admin', arguments: [
        gmail,
        password,
      ]);
    } else {
      users
          .collection('auth users')
          .where('nip', isEqualTo: gmail)
          .get()
          .then(
            (value) => value.size != 0
                ? value.docs.forEach(
                    (element) {
                      if (element.data()['password'].toString() == password) {
                        bool aktif = element.data()['aktif'];
                        if (aktif == true) {
                          Get.offAllNamed(
                            '/guru',
                            arguments: {
                              'password': password.toString(),
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
                      } else {
                        Get.defaultDialog(
                          title: 'Warning',
                          middleText: 'Password anda salah',
                        );
                      }
                    },
                  )
                : Get.defaultDialog(
                    title: 'Warning',
                    middleText: 'NIP anda salah',
                  ),
          );
    }
  }

  Future<UserCredential?> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "tess@gmail.com",
        password: "444456Dd@",
      );
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
