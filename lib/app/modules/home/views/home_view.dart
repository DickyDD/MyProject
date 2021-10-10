import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tes_database/app/data/widgets/input.dart';

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
      InputTahunAjaran(),
      InputJurusan(),
      InputKelas(),
    ];

    List<String> namaIndex = [
      'Dasboard',
      'Tahun',
      'Jurusan',
      'Kelas',
      // 'Nilai',
      'Exit',
    ];

    List<IconData> iconIndex = [
      Icons.dashboard_outlined,
      LineIcons.calendarPlus,
      LineIcons.book,
      LineIcons.userFriends,
      // Icons.person,
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
                            if (index != 4) {
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
                                            fontWeight: FontWeight.bold),
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

class LoginGuru extends StatelessWidget {
  const LoginGuru({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gmailC = TextEditingController(text: '2021-2022');
    final passwordC = TextEditingController(text: 'semester 1');
    final controller = Get.find<HomeController>();

    return Column(
      children: [
        input(gmailC, 'Gmail'),
        input(passwordC, 'Password'),
        TextButton(
            onPressed: () async {
              // await controller.login().then((value) async {
              //   if (value!.user != null) {
              //     print(value.user!.email);
              //     await controller.users
              //         .collection('auth users')
              //         .doc(passwordC.text)
              //         .get()
              //         .then((value) => print(value.data()));
              //   } else {
              //     controller.auth.signOut();
              //     print('object');
              //   }
              // });
            },
            child: Text('data'))
      ],
    );
  }
}
