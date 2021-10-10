import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/modules/auth/bindings/auth_binding.dart';
import 'app/modules/auth/views/auth_view.dart';
import 'app/modules/home/bindings/home_binding.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/modules/siswa/bindings/siswa_binding.dart';
import 'app/modules/siswa/views/siswa_view.dart';

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  final auth = FirebaseAuth.instance.currentUser;
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: '/login',
      getPages:
          // auth != null ?
          [
        GetPage(
          name: '/admin',
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/guru',
          page: () => SiswaView(),
          binding: SiswaBinding(),
        ),
        GetPage(
          name: '/login',
          page: () => AuthView(),
          binding: AuthBinding(),
        ),
        // ]
        // : [
        //    GetPage(
        //     name: '/login',
        //     page: () => AuthView(),
        //     binding: AuthBinding(),
        //   ),
      ],
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    ),
  );
}
