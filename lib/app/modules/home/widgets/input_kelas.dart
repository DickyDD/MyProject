import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import 'package:tes_database/app/data/widgets/dropdown.dart';
import 'package:tes_database/app/data/widgets/input.dart';
import '../controllers/home_controller.dart';

class InputKelas extends StatelessWidget {
  const InputKelas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    var data = controller.listNamaJurusan;
    var jumlahData = controller.listWaliKelas9.length.obs;
    var listDropdown = [
      CardShadow(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: DropdownKelas(
            dropdownValue: controller.jurusan,
            changeDrobdown: controller.changeDrobdownKelas,
            list: data,
            buildTextEditing: () async {
              await controller.getDataKelas();
            },
          ),
        ),
      ),
      CardShadow(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Dropdown(
            dropdownValue: controller.panjangList,
            list: controller.tahun,
          ),
        ),
      ),
      CardShadow(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Dropdown(
          dropdownValue: controller.semester,
          list: ['Semester 1', 'Semester 2'],
        ),
      )),
    ];
    var width = MediaQuery.of(context).size.width;

    return Obx(() => jumlahData.value != 0
        ? ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              (width > 410)
                  ? SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: listDropdown,
                      ),
                    )
                  : Wrap(
                      children: listDropdown,
                    ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: List.generate(3, (i) {
                  return Obx(() {
                    var listJumlah = [
                      controller.kelas.value.jumlahKelas9,
                      controller.kelas.value.jumlahKelas10,
                      controller.kelas.value.jumlahKelas11
                    ];
                    return controller.onLoading.value == false
                        ? Expanded(
                            child: Container(
                              height: Get.height * 0.9,
                              color: (i == 0)
                                  ? Colors.blue[50]
                                  : (i == 1)
                                      ? Colors.red[50]
                                      : Colors.indigo[50],
                              child: ListView.builder(
                                itemCount: controller.listWalikelas![i].length,
                                itemBuilder: (context, indx) => Column(
                                  children: [
                                    if (indx == 0)
                                      Container(
                                        color: Colors.grey[200],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "Jumlah ${listJumlah[i].toString()}"),
                                            TextButton(
                                                onPressed: () {
                                                  controller.onLoading.value =
                                                      true;
                                                  controller.addKelas(i);
                                                  if (i == 0) {
                                                    controller.kelas
                                                        .update((val) {
                                                      val!.jumlahKelas9++;
                                                    });
                                                    controller.onLoading.value =
                                                        false;
                                                  } else if (i == 1) {
                                                    controller.kelas
                                                        .update((val) {
                                                      val!.jumlahKelas10++;
                                                    });
                                                    controller.onLoading.value =
                                                        false;
                                                  } else {
                                                    controller.kelas
                                                        .update((val) {
                                                      val!.jumlahKelas11++;
                                                    });
                                                    controller.onLoading.value =
                                                        false;
                                                  }
                                                },
                                                child: Text('+'))
                                          ],
                                        ),
                                      ),
                                    CardShadow(
                                      // horizontal: 0,
                                      // vertical: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      'Kelas ${10 + i} ${controller.kelas.value.singkatanJurusan} ${indx + 1}'),
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.defaultDialog(
                                                          title: 'Hapus?',
                                                          middleText:
                                                              'Yakin  Ingin menghapus',
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                controller
                                                                    .onLoading
                                                                    .value = true;
                                                                controller.lessKelas(
                                                                    controller
                                                                            .listWalikelas![
                                                                        i],
                                                                    controller
                                                                            .listWalikelasGmail![
                                                                        i],
                                                                    controller
                                                                            .listWalikelas![i]
                                                                        [indx],
                                                                    controller
                                                                            .listWalikelasGmail![
                                                                        i][indx],
                                                                    i,
                                                                    'kelas ${10 + i} ${controller.kelas.value.singkatanJurusan} ${indx + 1}');
                                                                if (i == 0) {
                                                                  controller
                                                                      .kelas
                                                                      .update(
                                                                          (val) {
                                                                    val!.jumlahKelas9--;
                                                                  });
                                                                } else if (i ==
                                                                    1) {
                                                                  controller
                                                                      .kelas
                                                                      .update(
                                                                          (val) {
                                                                    val!.jumlahKelas10--;
                                                                  });
                                                                } else {
                                                                  controller
                                                                      .kelas
                                                                      .update(
                                                                          (val) {
                                                                    val!.jumlahKelas11--;
                                                                  });
                                                                }
                                                                controller
                                                                        .onLoading
                                                                        .value =
                                                                    false;
                                                                Get.back();
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .red),
                                                              ),
                                                              child: Text(
                                                                  'Yakin Hapus'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                controller.users
                                                                    .collection(
                                                                        'auth users')
                                                                    .doc(
                                                                        '${controller.listWalikelas![i][indx].text} kelas ${10 + i} ${controller.kelas.value.singkatanJurusan} ${indx + 1}')
                                                                    .update({
                                                                  "aktif":
                                                                      false,
                                                                });
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                'Non Aktif Auth',
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child:
                                                                  Text('Tidak'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                      child: Text('-'))
                                                ],
                                              ),
                                            ),
                                            input(
                                              controller.listWalikelas![i]
                                                  [indx],
                                              'Nama WaliKelas ${10 + i}',
                                              null,
                                              null,
                                            ),
                                            input(
                                              controller.listWalikelasGmail![i]
                                                  [indx],
                                              'NIP WaliKelas ${10 + i}',
                                              TextInputType.number,
                                              // TextInputType.number,
                                              [
                                                TextInputMask(
                                                    mask: '99999 999999 9 999'),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Non Aktif Akun'),
                                                Obx(() => Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 5,
                                                      ),
                                                      child: CupertinoSwitch(
                                                        value: controller
                                                            .gabungangKelasAktif[
                                                                i][indx]
                                                            .value,
                                                        onChanged: (value) {
                                                          controller
                                                              .gabungangKelasAktif[
                                                                  i][indx]
                                                              .value = value;
                                                        },
                                                      ),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Center(child: CircularProgressIndicator());
                  });
                }),
              ),
              Container(
                height: Get.height * 0.05,
                child: TextButton(
                    child: Text('Save'),
                    onPressed: () {
                      controller.inputKelas();
                    }),
              )
            ],
          )
        : Center(
            child: Text('Data Masih Kosong'),
          ));
  }
}

class DropdownKelas extends StatelessWidget {
  final List<Jurusan> list;
  final Rx<Jurusan> dropdownValue;
  final Future Function() buildTextEditing;
  final Function() changeDrobdown;

  const DropdownKelas({
    required this.list,
    Key? key,
    required this.dropdownValue,
    required this.buildTextEditing,
    required this.changeDrobdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Obx(() => DropdownButton<Jurusan>(
          value: dropdownValue.value,
          icon: const Icon(LineIcons.arrowCircleDown),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: SizedBox(),
          onChanged: (newValue) {
            changeDrobdown();
            dropdownValue.value = newValue!;
            buildTextEditing();
          },
          items: list.map<DropdownMenuItem<Jurusan>>((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                width > 740
                    ? "${value.namaLengkap.value} (${value.namaSingkat.value})"
                    : width > 650
                        ? value.namaLengkap.value
                        : value.namaSingkat.value,
              ),
            );
          }).toList(),
        ));
  }
}
