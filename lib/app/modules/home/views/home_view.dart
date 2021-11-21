import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tes_database/app/modules/home/widgets/input_PKL.dart';
import 'package:tes_database/app/modules/home/widgets/input_extrakurikuler.dart';
import 'package:tes_database/app/modules/home/widgets/input_kepala_sekolah.dart';
import 'package:tes_database/app/modules/home/widgets/input_pelajaran.dart';

import '../widgets/input_jurusan_data.dart';
import '../widgets/Input_tahun.dart';
import '../widgets/dasboard.dart';
import '../widgets/input_kelas.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    List<Widget> inputIndex = [
      Dasboard(),
      InputKepalaSekolah(),
      InputTahunAjaran(),
      InputJurusan(),
      InputPelajaran(),
      InputKelas(),
      InputPKL(),
      InputExtrakurikuler()
    ];

    List<String> namaIndex = [
      'Dasboard',
      'Kepala Sekolah',
      'Tahun Ajaran',
      'kompetensi keahlian'.capitalize!,
      'Mata Pelajaran',
      'Kelas',
      'PKL',
      'Extrakurikuler',
      // 'Nilai',
      'Exit',
    ];

    List<IconData> iconIndex = [
      Icons.dashboard_outlined,
      LineIcons.addressCard,
      LineIcons.calendarPlus,
      LineIcons.book,
      LineIcons.edit,
      LineIcons.userFriends,
      LineIcons.clipboard,
      LineIcons.award,
      LineIcons.arrowCircleLeft,
    ];

    var width = MediaQuery.of(context).size.width;
    var maxWidth = (width >= 944) ? 250.0 : 50.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        centerTitle: true,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0, 2),
                  spreadRadius: 2,
                  color: Color(0xffB5BCC2).withOpacity(0.15),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                namaIndex.length,
                (index) => Obx(() => AnimatedContainer(
                      height: 50,
                      width: maxWidth,
                      duration: Duration(milliseconds: 600),
                      child: Material(
                        color: index == controller.indexList.value
                            ? Colors.blue
                            : Colors.transparent,
                        child: InkWell(
                          hoverColor: Colors.blue[200],
                          splashColor: Colors.blue[50],
                          highlightColor: Colors.blue[100],
                          onTap: () {
                            if (index != inputIndex.length) {
                              controller.indexList.value = index;
                            } else {
                              Get.offNamed('/login');
                            }
                          },
                          child: (width >= 944)
                              ? ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Center(
                                        child: Icon(
                                      iconIndex[index],
                                      color: index == controller.indexList.value
                                          ? Colors.white.withOpacity(0.95)
                                          : Colors.blue,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (width >= 944)
                                      SizedBox(
                                        width: 10,
                                      ),
                                    Center(
                                      child: Text(
                                        namaIndex[index],
                                        style: TextStyle(
                                          color: index ==
                                                  controller.indexList.value
                                              ? Colors.white.withOpacity(0.95)
                                              : Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Icon(
                                    iconIndex[index],
                                    color: index == controller.indexList.value
                                        ? Colors.white.withOpacity(0.95)
                                        : Colors.blue,
                                  ),
                                ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Obx(() {
              if (controller.onLoading.value == false)
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: double.infinity,
                  child: Obx(
                    () => inputIndex[controller.indexList.value],
                  ),
                );
              else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }),
          ),
        ],
      ),
    );
  }
}
