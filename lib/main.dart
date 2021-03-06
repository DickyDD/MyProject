import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes_database/app/modules/biodata/bindings/biodata_siswa_binding.dart';
import 'package:tes_database/app/modules/siswa/bindings/siswa_binding.dart';
import 'package:tes_database/app/modules/siswa/views/siswa_view.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/modules/auth/bindings/auth_binding.dart';
import 'app/modules/auth/views/auth_view.dart';
import 'app/modules/biodata/views/biodata_siswa_view.dart';
import 'app/modules/home/bindings/home_binding.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/modules/guru/bindings/guru_binding.dart';
import 'app/modules/guru/views/guru_view.dart';
import 'app/modules/ranking/bindings/ranking_binding.dart';
import 'app/modules/ranking/views/ranking_view.dart';
import 'app/modules/tes_siswa/bindings/tes_siswa_binding.dart';
import 'app/modules/tes_siswa/views/tes_siswa_view.dart';

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Raport Digital",
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/admin',
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/guru',
          page: () => GuruView(),
          binding: GuruBinding(),
        ),
        GetPage(
          name: '/',
          page: () => AuthView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/siswa',
          page: () => SiswaView(),
          binding: SiswaBinding(),
        ),
        GetPage(
          name: '/nilai',
          page: () => TesSiswaView(),
          binding: TesSiswaBinding(),
        ),
        GetPage(
          name: '/ranking',
          page: () => RankingView(),
          binding: RankingBinding(),
        ),
        GetPage(
          name: '/biodata',
          page: () => BiodataSiswaView(),
          binding: BiodataSiswaBinding(),
        ),
        // GetPage(
        //   name: '/siswadata',
        //   page: () => SiswaDataView(),
        //   binding: SiswaDataBinding(),
        // ),
      ],
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    ),
  );
}
