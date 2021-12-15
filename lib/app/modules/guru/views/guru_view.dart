import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import '../widgets/landing.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:tes_database/app/data/api/pdf_api.dart';
import 'package:tes_database/app/data/model/invoice.dart';
import 'package:tes_database/app/data/validator/nilai.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
// import 'package:tes_database/app/modules/guru/widgets/nilai_umum.dart';
import '../controllers/firebase_upload.dart';
import '../widgets/acount_guru.dart';
import '../controllers/guru_controller.dart';

class GuruView extends GetView<GuruController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        title:
            Obx(() => Text(controller.namaIndex[controller.indexList.value])),
        centerTitle: true,
      ),
      body: Landing(),
    );
  }
}

class TanggalRaport extends GetView<GuruController> {
  const TanggalRaport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardShadow(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EditingInputSiswa(
              controller: controller.tanggalPdf,
              hintText: "Tanggal Raport",
            ),
          ),
        ),
      ],
    );
  }
}

// Input Siswa
class InputSiswa extends StatelessWidget {
  const InputSiswa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List? fileSiswa;
    final controller = Get.find<GuruController>();
    var inputNilai = controller.kelas.split(' ')[1];
    print(inputNilai);

    return Container(
      child: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => controller.onLoadingImage.value == false
                    ? Card(
                        child: Container(
                          height: 230,
                          width: 230,
                          // margin: EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(
                                controller.imageGuru.value.path != ''
                                    ? controller.imageGuru.value.path
                                    : controller.image,
                              ),
                            ),
                          ),

                          child: InkWell(
                            onTap: () async {
                              fileSiswa = await controller
                                  .getImages(controller.imageGuru);

                              controller.onLoadingImage.value = false;
                            },
                          ),
                        ),
                      )
                    : Container(
                        height: 230,
                        width: 230,
                        child: Center(child: CircularProgressIndicator()),
                      ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditingInputSiswa(
                controller: controller.nama,
                hintText: 'Nama Siswa',
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditingInputSiswa(
                controller: controller.nis,
                hintText: 'NIS',
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditingInputSiswa(
                controller: controller.namaOrtu,
                hintText: 'Nama Orang tua',
                // max: 13,
                keyboardtype: TextInputType.name,
                // listFormat: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditingInputSiswa(
                controller: controller.noOrtu,
                hintText: 'No.Orang tua',
                max: 13,
                keyboardtype: TextInputType.number,
                listFormat: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditingInputSiswa(
                controller: controller.catatanAkademik,
                hintText: 'CATATAN AKADEMIK',
                minLines: 3,
                maxLines: 5,
              ),
            ),
          ),
          NilaiWidget(
            inputNilai: inputNilai,
            controller: controller,
          ),
          SizedBox(
            height: 20,
          ),

          // controller.semester.toLowerCase() == "semester 2"
          //     ? Row(
          //         children: [
          //           Expanded(
          //             child: Obx(() => CheckboxListTile(
          //                   title: Text("${controller.lulus}"),
          //                   value: controller.checkedValue.value,
          //                   onChanged: (newValue) {
          //                     controller.checkedValue.value =
          //                         !controller.checkedValue.value;
          //                   },
          //                   controlAffinity: ListTileControlAffinity
          //                       .leading, //  <-- leading Checkbox
          //                 )),
          //           ),
          //           Expanded(
          //             child: Obx(
          //               () => CheckboxListTile(
          //                 title: Text("${controller.tidakLulus}"),
          //                 value: !controller.checkedValue.value,
          //                 onChanged: (newValue) {
          //                   controller.checkedValue.value =
          //                       !controller.checkedValue.value;
          //                 },
          //                 controlAffinity: ListTileControlAffinity
          //                     .leading, //  <-- leading Checkbox
          //               ),
          //             ),
          //           ),
          //         ],
          //       )
          //     : SizedBox(),
          SizedBox(
            height: 20,
          ),
          ButtonCustom(
              nama: 'Save',
              onTap: () async {
                try {
                  if (controller.nama.text == '' ||
                      controller.nis.text == '' ||
                      controller.noOrtu.text == '' ||
                      controller.catatanAkademik.text == '') {
                    Get.defaultDialog(
                      title: 'Gagal',
                      middleText: 'Ada Yang Belum terisi',
                    );
                    return null;
                  }
                  if (controller.formKey.currentState!.validate()) {
                    if (fileSiswa != null) {
                      controller.onLoading.value = true;
                      final destination =
                          'foto_kelas/${controller.kelas}/${controller.nama.text}';
                      var ref =
                          await FirebaseApi.uploadFile(destination, fileSiswa!);
                      controller.urlsSiswa = await ref!.ref.getDownloadURL();
                    } else {
                      controller.urlsSiswa = controller.image;
                    }
                    controller.inputDataSiswa().whenComplete(
                          () => Get.defaultDialog(
                              title: 'Berhasil',
                              middleText:
                                  '${controller.nama.text} Data Sudah Berahasil Terinput'),
                        );
                  } else {
                    Get.defaultDialog(
                      title: 'Gagal',
                      middleText: 'Nilai Tidak Boleh Lebih Dari 100',
                    );
                    return null;
                  }

                  controller.onLoading.value = false;
                } catch (e) {
                  print(e);
                  controller.onLoading.value = false;
                }
              }),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class NilaiWidget extends StatelessWidget {
  const NilaiWidget({
    Key? key,
    required this.inputNilai,
    required this.controller,
  }) : super(key: key);

  final String inputNilai;
  final GuruController controller;

  @override
  Widget build(BuildContext context) {
    // var _isValid = false.obs;
    return Form(
      key: controller.formKey,
      onChanged: () {
        var _isValid = false;
        var formKey = Get.find<GuruController>().formKey;
        final isValid = formKey.currentState!.validate();
        if (_isValid != isValid) {
          _isValid = isValid;
        }
      },
      child: Column(
        children: [
          Divider(),
          inputNilai != 'X'
              ? Obx(() {
                  var list = controller.listKhususC3;
                  var panjang = list.length.obs;
                  var panjangList = 1.obs;
                  controller.nilaiKhusus = List.generate(
                    panjang.value,
                    (index) => TextEditingController(),
                  );
                  controller.keterampilanKhusus = List.generate(
                    panjang.value,
                    (index) => TextEditingController(),
                  );
                  // controller.panjangKhusus.value = panjangList.value;
                  controller.dropdownValueKhusus = [
                    list[0].obs,
                  ];

                  return Obx(() => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Nilai Pelajaran Khusus',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    if (panjangList.value < panjang.value) {
                                      panjangList.value++;
                                      controller.dropdownValueKhusus = [
                                        ...controller.dropdownValueKhusus,
                                        list[0].obs
                                      ];
                                    } else {
                                      print(panjangList.value);
                                      Get.defaultDialog(
                                        title: 'Peringatan',
                                        middleText:
                                            'Jumlah pelajaran telah mencapai batas',
                                      );
                                    }
                                  },
                                  icon: Icon(LineIcons.plusCircle),
                                ),
                                SizedBox(
                                  width: 40,
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          ...List.generate(
                            panjangList.value,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 22, bottom: 22, left: 8),
                                        child: Dropdown(
                                          dropdownValue: controller
                                              .dropdownValueKhusus[index],
                                          list: list,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Card(
                                      // color: ,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: EditingInputSiswaNilai(
                                          key: Key(controller
                                              .nilaiKhusus[index].text),
                                          controller:
                                              controller.nilaiKhusus[index],
                                          max: 3,
                                          validator: (val) =>
                                              validateNilai(val!),
                                          keyboardtype: TextInputType.number,
                                          listFormat: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          hintText: 'Pengetahuan',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Card(
                                      // color: ,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: EditingInputSiswaNilai(
                                          key: Key(
                                            controller
                                                .keterampilanKhusus[index].text,
                                          ),
                                          controller: controller
                                              .keterampilanKhusus[index],
                                          max: 3,
                                          validator: (val) =>
                                              validateNilai(val!),
                                          keyboardtype: TextInputType.number,
                                          listFormat: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          hintText: 'Keterampilan',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          if (panjangList.value > 1) {
                                            panjangList.value--;
                                            controller.dropdownValueKhusus
                                                .removeAt(
                                              index,
                                            );
                                          } else {
                                            print(panjangList.value);
                                            Get.defaultDialog(
                                              title: 'Peringatan',
                                              middleText:
                                                  'Jumlah pelajaran tidak boleh kurang dari 1',
                                            );
                                          }
                                        },
                                        icon: Icon(LineIcons.minusCircle)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                })
              : Obx(() {
                  var list = controller.listGabunganKhusus;
                  var panjang = list.length.obs;
                  var panjangList = 1.obs;
                  controller.nilaiKhusus = List.generate(
                    panjang.value,
                    (index) => TextEditingController(),
                  );
                  controller.keterampilanKhusus = List.generate(
                    panjang.value,
                    (index) => TextEditingController(),
                  );

                  // controller.panjangKhusus.value = panjangList.value;
                  controller.dropdownValueKhusus = [
                    list[0].obs,
                  ];
                  return Obx(() => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Nilai Pelajaran Khusus',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    if (panjangList.value < panjang.value) {
                                      panjangList.value++;
                                      controller.dropdownValueKhusus = [
                                        ...controller.dropdownValueKhusus,
                                        list[0].obs
                                      ];
                                    } else {
                                      print(panjangList.value);
                                      Get.defaultDialog(
                                        title: 'Peringatan',
                                        middleText:
                                            'Jumlah pelajaran telah mencapai batas',
                                      );
                                    }
                                  },
                                  icon: Icon(LineIcons.plusCircle),
                                ),
                                SizedBox(
                                  width: 40,
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          ...List.generate(
                            panjangList.value,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 22, bottom: 22, left: 8),
                                        child: Dropdown(
                                          dropdownValue: controller
                                              .dropdownValueKhusus[index],
                                          list: list,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Card(
                                      // color: ,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: EditingInputSiswaNilai(
                                          key: Key(controller
                                              .nilaiKhusus[index].text),
                                          controller:
                                              controller.nilaiKhusus[index],
                                          max: 3,
                                          keyboardtype: TextInputType.number,
                                          validator: (val) =>
                                              validateNilai(val!),
                                          listFormat: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          hintText: 'Pengetahuan',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Card(
                                      // color: ,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: EditingInputSiswaNilai(
                                          key: Key(
                                            controller
                                                .keterampilanKhusus[index].text,
                                          ),
                                          controller: controller
                                              .keterampilanKhusus[index],
                                          max: 3,
                                          validator: (val) =>
                                              validateNilai(val!),
                                          keyboardtype: TextInputType.number,
                                          listFormat: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          hintText: 'Keterampilan',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          if (panjangList.value > 1) {
                                            panjangList.value--;
                                            controller.dropdownValueKhusus
                                                .removeAt(
                                              index,
                                            );
                                          } else {
                                            print(panjangList.value);
                                            Get.defaultDialog(
                                              title: 'Peringatan',
                                              middleText:
                                                  'Jumlah pelajaran tidak boleh kurang dari 1',
                                            );
                                          }
                                        },
                                        icon: Icon(LineIcons.minusCircle)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                }),
          Divider(),
          Obx(() {
            var list = controller.listGabunganUmum;
            var panjang = list.length.obs;
            var panjangList = 1.obs;
            controller.nilaiUmum = List.generate(
              panjang.value,
              (index) => TextEditingController(),
            );
            controller.keterampilanUmum = List.generate(
              panjang.value,
              (index) => TextEditingController(),
            );
            // controller.panjangUmum.value = panjangList.value;
            controller.dropdownValueUmum = [
              list[0].obs,
            ];
            print(232);
            return Obx(() => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Nilai Pelajaran Umum',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              if (panjangList.value < panjang.value) {
                                panjangList.value++;
                                controller.dropdownValueUmum = [
                                  ...controller.dropdownValueUmum,
                                  list[0].obs
                                ];
                              } else {
                                print(panjangList.value);
                                Get.defaultDialog(
                                  title: 'Peringatan',
                                  middleText:
                                      'Jumlah pelajaran telah mencapai batas',
                                );
                              }
                            },
                            icon: Icon(LineIcons.plusCircle),
                          ),
                          SizedBox(
                            width: 40,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ...List.generate(
                      panjangList.value,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 22, bottom: 22, left: 8),
                                  child: Dropdown(
                                    dropdownValue:
                                        controller.dropdownValueUmum[index],
                                    list: list,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Card(
                                // color: ,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EditingInputSiswaNilai(
                                    key: Key(controller.nilaiUmum[index].text),
                                    controller: controller.nilaiUmum[index],
                                    max: 3,
                                    validator: (val) => validateNilai(val!),
                                    keyboardtype: TextInputType.number,
                                    listFormat: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    hintText: 'Pengetahuan',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Card(
                                // color: ,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EditingInputSiswaNilai(
                                    key: Key(
                                      controller.keterampilanUmum[index].text,
                                    ),
                                    controller:
                                        controller.keterampilanUmum[index],
                                    max: 3,
                                    validator: (val) => validateNilai(val!),
                                    keyboardtype: TextInputType.number,
                                    listFormat: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    hintText: 'Keterampilan',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  onPressed: () {
                                    if (panjangList.value > 1) {
                                      panjangList.value--;
                                      controller.dropdownValueUmum.removeAt(
                                        index,
                                      );
                                    } else {
                                      print(panjangList.value);
                                      Get.defaultDialog(
                                        title: 'Peringatan',
                                        middleText:
                                            'Jumlah pelajaran tidak boleh kurang dari 1',
                                      );
                                    }
                                  },
                                  icon: Icon(LineIcons.minusCircle)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          }),

          inputNilai != 'X'
              ? Obx(() {
                  // var list = controller.listDataPKL;
                  var panjang = 5.obs;
                  var panjangList = 1.obs;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Pelatihan Kerja Lapangan",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                if (panjangList.value < panjang.value) {
                                  panjangList.value++;
                                  controller.nialiPKL
                                      .add(TextEditingController());
                                  controller.mitraPKL
                                      .add(TextEditingController());
                                  controller.lamaPKL
                                      .add(TextEditingController());
                                  controller.lokasiPKL
                                      .add(TextEditingController());
                                } else {
                                  print(panjangList.value);
                                  Get.defaultDialog(
                                    title: 'Peringatan',
                                    middleText:
                                        'Jumlah pelajaran telah mencapai batas',
                                  );
                                }
                              },
                              icon: Icon(LineIcons.plusCircle),
                            ),
                            SizedBox(
                              width: 40,
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      ...List.generate(
                        panjangList.value,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 22, bottom: 22, left: 8),
                                        child: EditingInputSiswaNilai(
                                          // key:Key(controller.nialiKehadiran[index].text),
                                          controller:
                                              controller.mitraPKL[index],

                                          keyboardtype: TextInputType.multiline,
                                          validator: (val) => val!.isEmpty
                                              ? "Tidak Boleh kosong"
                                              : null,
                                          // listFormat: [
                                          //   FilteringTextInputFormatter
                                          //       .digitsOnly
                                          // ],
                                          hintText: 'Mitra PKL',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 22, bottom: 22, left: 8),
                                        child: EditingInputSiswaNilai(
                                          // key:Key(controller.nialiKehadiran[index].text),
                                          controller:
                                              controller.lokasiPKL[index],

                                          keyboardtype: TextInputType.multiline,
                                          validator: (val) => val!.isEmpty
                                              ? "Tidak Boleh kosong"
                                              : null,
                                          // listFormat: [
                                          //   FilteringTextInputFormatter
                                          //       .digitsOnly
                                          // ],
                                          hintText: 'Lokasi PKL',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Card(
                                      // color: ,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: EditingInputSiswaNilai(
                                          // key:Key(controller.nialiKehadiran[index].text),
                                          controller: controller.lamaPKL[index],
                                          max: 2,
                                          keyboardtype: TextInputType.number,
                                          // validator: (val) =>
                                          //     validateNilai(val!),
                                          validator: (val) => val!.isEmpty
                                              ? "Tidak Boleh kosong"
                                              : null,
                                          listFormat: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          hintText: 'Lama PKL',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          if (panjangList.value > 1) {
                                            panjangList.value--;

                                            controller.nialiPKL.removeAt(index);
                                            controller.mitraPKL.removeAt(index);
                                            controller.lamaPKL.removeAt(index);
                                            controller.lokasiPKL
                                                .removeAt(index);
                                          } else {
                                            print(panjangList.value);
                                            Get.defaultDialog(
                                              title: 'Peringatan',
                                              middleText:
                                                  'Jumlah pelajaran tidak boleh kurang dari 1',
                                            );
                                          }
                                        },
                                        icon: Icon(LineIcons.minusCircle)),
                                  ),
                                ],
                              ),
                              Card(
                                // color: ,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EditingInputSiswaNilai(
                                    key: Key(controller.nialiPKL[index].text),
                                    controller: controller.nialiPKL[index],
                                    maxLines: 3,
                                    validator: (val) => val!.isEmpty
                                        ? "Tidak Boleh kosong"
                                        : null,
                                    hintText: 'Keterangan',
                                    // hintText: 'Nilai',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                })
              : SizedBox(),
          //Extra kurikuler
          Obx(() {
            var list = controller.listDataEXR;
            var panjang = list.length.obs;
            var panjangList = 1.obs;
            controller.nilaiEXR = List.generate(
              panjang.value,
              (index) => TextEditingController(),
            );
            controller.keteranganEXR = List.generate(
              panjang.value,
              (index) => TextEditingController(),
            );
            // controller.panjangKhusus.value = panjangList.value;
            controller.dropdownValueEXR = [
              list[0].obs,
            ];
            return Obx(() => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Extrakurikuler",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              if (panjangList.value < panjang.value) {
                                panjangList.value++;
                                controller.dropdownValueEXR = [
                                  ...controller.dropdownValueEXR,
                                  list[0].obs
                                ];
                              } else {
                                print(panjangList.value);
                                Get.defaultDialog(
                                  title: 'Peringatan',
                                  middleText:
                                      'Jumlah pelajaran telah mencapai batas',
                                );
                              }
                            },
                            icon: Icon(LineIcons.plusCircle),
                          ),
                          SizedBox(
                            width: 40,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ...List.generate(
                      panjangList.value,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 22, bottom: 22, left: 8),
                                  child: DropdownE(
                                    dropdownValue:
                                        controller.dropdownValueEXR[index],
                                    list: list,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Card(
                                // color: ,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EditingInputSiswaNilai(
                                    controller: controller.nilaiEXR[index],
                                    maxLines: 1,
                                    max: 2,
                                    keyboardtype: TextInputType.name,
                                    listFormat: [TextInputMask(mask: 'AA')],
                                    validator: (val) => val!.isEmpty
                                        ? "Tidak Boleh kosong"
                                        : null,
                                    hintText: 'Nilai',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Card(
                                // color: ,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EditingInputSiswa(
                                    controller: controller.keteranganEXR[index],
                                    maxLines: 3,
                                    validator: (val) => val!.isEmpty
                                        ? "Tidak Boleh kosong"
                                        : null,
                                    hintText: 'Keterangan',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  onPressed: () {
                                    if (panjangList.value > 1) {
                                      panjangList.value--;
                                      controller.dropdownValueEXR.removeAt(
                                        index,
                                      );
                                    } else {
                                      print(panjangList.value);
                                      Get.defaultDialog(
                                        title: 'Peringatan',
                                        middleText:
                                            'Jumlah pelajaran tidak boleh kurang dari 1',
                                      );
                                    }
                                  },
                                  icon: Icon(LineIcons.minusCircle)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          }),

          // kehadirannnn
          Divider(),
          Obx(() {
            var list = controller.listKehadiran;
            var panjang = list.length.obs;
            var panjangList = 3.obs;
            controller.nialiKehadiran = List.generate(
              panjang.value,
              (index) => TextEditingController(),
            );

            print(232);
            return Obx(() => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Kehadiran',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Divider(),
                    ...List.generate(
                      panjangList.value,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Card(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 22, bottom: 22, left: 8),
                                    child: Text(
                                      list[index],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Card(
                                // color: ,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EditingInputSiswaKehadiran(
                                    key: Key(
                                        controller.nialiKehadiran[index].text),
                                    controller:
                                        controller.nialiKehadiran[index],
                                    max: 2,
                                    // validator: (val) => validateNilai(val!),
                                    keyboardtype: TextInputType.number,
                                    listFormat: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    hintText: 'Kehadiran',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          }),
          // kehadirannnn
          Divider(),
          Obx(() {
            var list = controller.listDPK;
            var panjang = list.length.obs;
            var panjangList = 5.obs;
            controller.nilaiDPK = List.generate(
              panjang.value,
              (index) => TextEditingController(),
            );

            print(232);
            return Obx(() => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'DESKRIPSI PERKEMBANGAN KARAKTER',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Divider(),
                    ...List.generate(
                      panjangList.value,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Card(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 22, bottom: 22, left: 8),
                                    child: Text(
                                      list[index],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Card(
                                // color: ,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EditingInputSiswaDKP(
                                    key: Key(
                                      controller.nilaiDPK[index].text,
                                    ),
                                    controller: controller.nilaiDPK[index],
                                    max: 1,
                                    validator: (val) => validateDPK(val!),
                                    keyboardtype: TextInputType.number,
                                    listFormat: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    hintText: 'Nilai',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          }),
        ],
      ),
    );
  }
}

class EditingInputSiswaNilai extends StatelessWidget {
  const EditingInputSiswaNilai({
    Key? key,
    required this.controller,
    required this.hintText,
    this.max,
    this.listFormat,
    this.keyboardtype,
    this.minLines,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final int? max;
  final int? minLines, maxLines;
  final List<TextInputFormatter>? listFormat;
  final TextInputType? keyboardtype;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    var labelText = "".obs;
    return Obx(() => TextFormField(
          controller: controller,
          // inputFormatters: [TextFor],
          maxLength: max,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: keyboardtype,
          validator: validator,
          // onTap: () => labelText.value == "" ? "Nilai E" : null,
          onChanged: (val) {
            var nilai = int.parse(val);
            if (nilai > 80) {
              labelText.value = "Nilai A";
            } else if (nilai > 70) {
              labelText.value = "Nilai B";
            } else if (nilai > 60) {
              labelText.value = "Nilai C";
            } else if (nilai > 40) {
              labelText.value = "Nilai D";
            } else {
              labelText.value = "Nilai E";
            }
          },
          inputFormatters: listFormat,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText.value == "" ? hintText : labelText.value,
          ),
        ));
  }
}

class EditingInputSiswaKehadiran extends StatelessWidget {
  const EditingInputSiswaKehadiran({
    Key? key,
    required this.controller,
    required this.hintText,
    this.max,
    this.listFormat,
    this.keyboardtype,
    this.minLines,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final int? max;
  final int? minLines, maxLines;
  final List<TextInputFormatter>? listFormat;
  final TextInputType? keyboardtype;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    var labelText = "".obs;
    return Obx(() => TextFormField(
          controller: controller,
          // inputFormatters: [TextFor],
          maxLength: max,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: keyboardtype,
          validator: validator,
          inputFormatters: listFormat,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText.value == "" ? hintText : labelText.value,
          ),
        ));
  }
}

class EditingInputSiswaDKP extends StatelessWidget {
  const EditingInputSiswaDKP({
    Key? key,
    required this.controller,
    required this.hintText,
    this.max,
    this.listFormat,
    this.keyboardtype,
    this.minLines,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final int? max;
  final int? minLines, maxLines;
  final List<TextInputFormatter>? listFormat;
  final TextInputType? keyboardtype;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    var labelText = "".obs;
    return Obx(() => TextFormField(
          controller: controller,
          // inputFormatters: [TextFor],
          maxLength: max,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: keyboardtype,
          validator: validator,
          onChanged: (val) {
            var nilai = int.parse(val);
            if (nilai > 3) {
              labelText.value = "Sangat Baik";
            } else if (nilai > 2) {
              labelText.value = "Baik";
            } else if (nilai > 1) {
              labelText.value = "Cukup";
            } else {
              labelText.value = "Kurang";
            }
          },
          inputFormatters: listFormat,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText.value == "" ? hintText : labelText.value,
          ),
        ));
  }
}

class EditingInputSiswa extends StatelessWidget {
  const EditingInputSiswa({
    Key? key,
    required this.controller,
    required this.hintText,
    this.max,
    this.listFormat,
    this.keyboardtype,
    this.minLines,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final int? max;
  final int? minLines, maxLines;
  final List<TextInputFormatter>? listFormat;
  final TextInputType? keyboardtype;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: max,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardtype,
      validator: validator,
      inputFormatters: listFormat,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
      ),
    );
  }
}

class DataWalikelas extends StatelessWidget {
  final String nama;
  final String value;
  const DataWalikelas({
    Key? key,
    required this.nama,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("$nama : $value"),
    ));
  }
}

class Dropdown extends StatelessWidget {
  final List<ListPelajaran> list;
  final Rx<ListPelajaran> dropdownValue;
  const Dropdown({
    required this.list,
    Key? key,
    required this.dropdownValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Get.width);
    return Obx(() => DropdownButton<ListPelajaran>(
          value: dropdownValue.value,
          icon: const Icon(LineIcons.arrowCircleDown),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          underline: SizedBox(),
          onChanged: (newValue) async {
            dropdownValue.value = newValue!;
          },
          items: list.map<DropdownMenuItem<ListPelajaran>>((value) {
            return DropdownMenuItem(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Flex(
                  direction:
                      Get.width >= 1140 ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${value.type} : ",
                    ),
                    Text(
                      "${value.name}",
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }
}

class DropdownE extends StatelessWidget {
  final List<String> list;
  final Rx<String> dropdownValue;
  const DropdownE({
    required this.list,
    Key? key,
    required this.dropdownValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Get.width);
    return Obx(() => DropdownButton<String>(
          value: dropdownValue.value,
          icon: const Icon(LineIcons.arrowCircleDown),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          underline: SizedBox(),
          onChanged: (newValue) async {
            dropdownValue.value = newValue!;
          },
          items: list.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem(
              value: value,
              child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(value)),
            );
          }).toList(),
        ));
  }
}

class ViewDataSiswa extends StatelessWidget {
  const ViewDataSiswa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GuruController>();
    var inputNilai = controller.kelas.split(' ')[1];

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.users
          .collection(controller.tahunAjaran)
          .doc(controller.jurusan)
          .collection(controller.semester)
          .doc(controller.kelas)
          .collection("Siswa")
          .snapshots(),
      builder: (ctx, asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return Text('Error: ${asyncSnapshot.error}');
        }
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.none:
            return Text('No data');
          case ConnectionState.waiting:
            return Text('Awaiting...');
          case ConnectionState.active:
            var data = asyncSnapshot.data!.docs;
            // var data = dataMap["siswa"] ?? [];

            // var dataobs = data as List;
            var inNull = asyncSnapshot.data!.size.obs;
            return inNull.value != 0
                ? GridView.extent(
                    // crossAxisCount: 2,
                    maxCrossAxisExtent: 440,
                    // childAspectRatio: ,
                    // mainAxisSpacing: 50,
                    // crossAxisSpacing: 50,
                    children: [
                      ...data.map((value) {
                        var nilaiUmum = value["nilai_umum"] ?? [];
                        var nilaiKhusus = value["nilai_khusus"] ?? [];
                        var pkl = value['pkl'] ?? [];
                        var extr = value['extr'] ?? [];
                        var dpk = value['dpk'] ?? [];
                        var kehadiran = value['kehadiran'] ?? [];
                        var dataKososng = "Belum di Isi";
                        return Card(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(
                                //   height: 30,
                                // ),
                                Stack(
                                  children: [
                                    ProgressiveImage(
                                      placeholder:
                                          AssetImage('assets/person.png'),
                                      // size: 1.87KB
                                      thumbnail:
                                          AssetImage('assets/person.png'),
                                      // size: 1.29MB
                                      image: NetworkImage(value['imageSiswa']),
                                      height: 250,
                                      width: 500,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        color: Colors.blue,
                                        child: IconButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                                middleText:
                                                    'Anda inggin Mengedit atau Menghapus ?',
                                                title: value['nama'],
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Get.toNamed(
                                                        '/siswa',
                                                        arguments: [
                                                          inputNilai != 'X'
                                                              ? controller
                                                                  .listKhususC3
                                                              : controller
                                                                  .listGabunganKhusus,
                                                          controller
                                                              .listGabunganUmum,
                                                          controller
                                                              .listDataEXR,
                                                          value['nama'] ??
                                                              dataKososng,
                                                          value['nis'] ??
                                                              dataKososng,
                                                          value['noOrtu'] ??
                                                              dataKososng,
                                                          value['catatanAkademik'] ??
                                                              dataKososng,
                                                          nilaiUmum as List,
                                                          nilaiKhusus as List,
                                                          pkl as List,
                                                          extr as List,
                                                          kehadiran as List,
                                                          dpk as List,
                                                          value.id,
                                                          value['imageSiswa'],
                                                          value['namaOrtu'],
                                                          controller
                                                              .tahunAjaran,
                                                          controller.jurusan,
                                                          controller.kelas,
                                                          value["lulus"] ??
                                                              "Naik ke",
                                                          controller.semester
                                                        ],
                                                      );
                                                    },
                                                    child: Text('Edit'),
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Colors.redAccent,
                                                      ),
                                                      onPressed: () {
                                                        controller.users
                                                            .collection(
                                                                controller
                                                                    .tahunAjaran)
                                                            .doc(controller
                                                                .jurusan)
                                                            .collection(
                                                                controller
                                                                    .semester)
                                                            .doc(controller
                                                                .kelas)
                                                            .collection("Siswa")
                                                            .doc(value.id)
                                                            .delete()
                                                            .then(
                                                              (_) => Get.back(),
                                                            );
                                                      },
                                                      child: Text('Hapus'))
                                                ]);
                                          },
                                          icon: Icon(
                                            LineIcons.verticalEllipsis,
                                            color: Colors.white,
                                            // size: 30,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  value['nama'] ?? dataKososng,
                                  style: TextStyle(fontSize: 24),
                                ),
                                Text(
                                  value['nis'] ?? dataKososng,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(value["lulus"] ?? dataKososng),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      controller.onLoading.value = true;
                                      int no1 = 1;
                                      int no2 = 1;
                                      int no3 = 1;
                                      int no4 = 1;
                                      int no5 = 1;
                                      int no6 = 1;
                                      var dataUmum1 = <NilaiPDF>[];
                                      var dataUmum2 = <NilaiPDF>[];
                                      var dataKhususC1 = <NilaiPDF>[];
                                      var dataKhususC2 = <NilaiPDF>[];
                                      var dataKhususC3 = <NilaiPDF>[];

                                      nilaiUmum.forEach((element) {
                                        element.forEach((key, value) {
                                          print(key);
                                          if (key.toString() ==
                                              "Muatan Kewilayahan") {
                                            dataUmum2.add(
                                              NilaiPDF(
                                                value['nama'],
                                                value['Pengetahuan'],
                                                value['Keterampilan'],
                                              ),
                                            );
                                          } else {
                                            dataUmum1.add(
                                              NilaiPDF(
                                                value['nama'],
                                                value['Pengetahuan'],
                                                value['Keterampilan'],
                                              ),
                                            );
                                          }
                                        });
                                      });

                                      nilaiKhusus.forEach((element) {
                                        element.forEach((key, value) {
                                          if (key == "C1") {
                                            dataKhususC1.add(
                                              NilaiPDF(
                                                value['nama'] ?? "",
                                                value['Pengetahuan'] ?? "",
                                                value['Keterampilan'] ?? "",
                                              ),
                                            );
                                          } else if (key == "C2") {
                                            dataKhususC2.add(
                                              NilaiPDF(
                                                value['nama'] ?? "",
                                                value['Pengetahuan'] ?? "",
                                                value['Keterampilan'] ?? "",
                                              ),
                                            );
                                          } else if (inputNilai != 'X') {
                                            dataKhususC3.add(
                                              NilaiPDF(
                                                value['nama'],
                                                value['Pengetahuan'],
                                                value['Keterampilan'],
                                              ),
                                            );
                                          }
                                        });
                                      });
                                      var dataPKL = <InvoiceItemPKL>[];
                                      if (inputNilai != 'X') {
                                        pkl.forEach((element) {
                                          element.forEach((key, value) {
                                            dataPKL.add(
                                              InvoiceItemPKL(
                                                keterangan: value['nilai'],
                                                lama: value['lama'],
                                                lokasi: value['lokasi'],
                                                mitra: key,
                                                no: "${no5++}",
                                              ),
                                            );
                                          });
                                        });
                                      } else {
                                        dataPKL.add(
                                          InvoiceItemPKL(
                                            keterangan: "",
                                            lama: "",
                                            lokasi: "",
                                            mitra: "",
                                            no: "1",
                                          ),
                                        );
                                      }
                                      var dataExtr = <InvoiceItemExtra>[];

                                      extr.forEach((element) {
                                        element.forEach((key, value) {
                                          dataExtr.add(
                                            InvoiceItemExtra(
                                              keterangan: value['keterangan'],
                                              nama: key.toString(),
                                              nilai: value['nilai'].toString(),
                                              no: no6++,
                                            ),
                                          );
                                        });
                                      });

                                      var dataKehadiran =
                                          <InvoiceItemKehadiran>[];

                                      kehadiran.forEach((element) {
                                        element.forEach((key, value) {
                                          dataKehadiran.add(
                                            InvoiceItemKehadiran(
                                              nama: key.toString(),
                                              nilai: value['nilai'].toString(),
                                            ),
                                          );
                                        });
                                      });
                                      var dataDPK = <InvoiceItemKehadiran>[];
                                      final dataNilaiDPK = [
                                        "Kurang".toUpperCase(),
                                        "Cukup".toUpperCase(),
                                        "Baik".toUpperCase(),
                                        "Sangat Baik".toUpperCase(),
                                      ];

                                      // final String tanggal =
                                      //     'Makassar, ${controller.hari} ${controller.bulan[controller.month]} ${controller.tahun}';

                                      var dataI = 0;
                                      var dataR = 0;
                                      var dataN = 0;
                                      var dataM = 0;
                                      var dataG = 0;
                                      final InR = [
                                        "Meningkatkan",
                                        "Meningkatkan",
                                        "Mempertahankan",
                                        "Mempertahankan",
                                      ];
                                      final dpkLain = [
                                        "Lebih",
                                        "Lebih",
                                        "Telah",
                                        "Telah",
                                      ];

                                      dpk.forEach((element) {
                                        element.forEach((key, value) {
                                          if (key.toString() == "Integritas") {
                                            dataDPK.add(
                                              InvoiceItemKehadiran(
                                                nama: key.toString(),
                                                nilai:
                                                    "Anda memiliki pola kehidupan kemasyarakatan yang ${dataNilaiDPK[(int.tryParse(value['nilai']) ?? 1) - 1]} di Lingkungan sekolah",
                                              ),
                                            );
                                            dataI =
                                                int.tryParse(value['nilai'])!;
                                          } else if (key.toString() ==
                                              "Religius") {
                                            dataDPK.add(
                                              InvoiceItemKehadiran(
                                                nama: key.toString(),
                                                nilai:
                                                    "Anda menunjukkan ketakwaan pada agama yang dianut dan toleran pada penganut yang berbeda ${dataNilaiDPK[int.tryParse(value['nilai'])! - 1]} di Lingkungan sekolah",
                                              ),
                                            );
                                            dataR =
                                                int.tryParse(value['nilai'])!;
                                          } else if (key.toString() ==
                                              "Nasionalis") {
                                            dataDPK.add(
                                              InvoiceItemKehadiran(
                                                nama: key.toString(),
                                                nilai:
                                                    "Anda ${dataNilaiDPK[int.tryParse(value['nilai'])! - 1]} dalam kegiatan yang bernuansa nasionalis di Lingkungan sekolah",
                                              ),
                                            );
                                            dataN =
                                                int.tryParse(value['nilai'])!;
                                          } else if (key.toString() ==
                                              "Mandiri") {
                                            dataDPK.add(
                                              InvoiceItemKehadiran(
                                                nama: key.toString(),
                                                nilai:
                                                    "Anda menunjukkan sikap kemandirian yang ${dataNilaiDPK[int.tryParse(value['nilai'])! - 1]} di lingkungan sekolah",
                                              ),
                                            );
                                            dataM =
                                                int.tryParse(value['nilai'])!;
                                          } else {
                                            dataDPK.add(
                                              InvoiceItemKehadiran(
                                                nama: key.toString(),
                                                nilai:
                                                    "Anda menunjukkan kegotong-royongan yang ${dataNilaiDPK[int.tryParse(value['nilai'])! - 1]} dalam lingkungan sekolah",
                                              ),
                                            );
                                            dataG =
                                                int.tryParse(value['nilai'])!;
                                          }
                                        });
                                      });

                                      final dpkG =
                                          "Anda harus ${InR[dataI - 1]} INTEGRITAS di Lingkungan sekolah, ${InR[dataR - 1]} sifat RELIGIUS, ${dpkLain[dataN - 1]} menunjukkan sifat NASIONALISME. ${dpkLain[dataM - 1]} menunjukkan sifat KEMANDIRIAN  dan ${dpkLain[dataG - 1]} menunjukkan sifat KEGOTONGROYONGAN  di lingkungan sekolah.";

                                      final invoice = Invoice(
                                        //  lulus: 'das',
                                        tanggal: controller.tanggalPdf.text,
                                        info: Info(
                                          nama: value['nama'] ?? dataKososng,
                                          nik: value['nis'] ?? dataKososng,
                                          namaSekolah: 'SMK Negeri 10 Makassar',
                                          alamat:
                                              'Jl. Bontomanai No. 14 Gunungsari Baru Makassar',
                                          kelas: controller.kelas
                                              .split('kelas')
                                              .join()
                                              .trim()
                                              .split(' ')
                                              .join(' '),
                                          semester: controller.semester ==
                                                  'semester 1'
                                              ? "1 (Satu)"
                                              : '2 (Dua)',
                                          tahunPelajaran:
                                              controller.tahunAjaran,
                                        ),
                                        itemsA: List.generate(
                                          dataUmum1.length,
                                          (index) => InvoiceItem(
                                            no: no1++,
                                            mP: dataUmum1[index].nama,
                                            pengetahuan: int.parse(
                                              dataUmum1[index].pengetahuan,
                                            ),
                                            keterampilan: int.parse(
                                              dataUmum1[index].keterampilan,
                                            ),
                                          ),
                                        ),
                                        itemsB: List.generate(
                                          dataUmum2.length,
                                          (index) => InvoiceItem(
                                            no: no2++,
                                            mP: dataUmum2[index].nama,
                                            pengetahuan: int.parse(
                                              dataUmum2[index].pengetahuan,
                                            ),
                                            keterampilan: int.parse(
                                              dataUmum2[index].keterampilan,
                                            ),
                                          ),
                                        ),
                                        itemsC: List.generate(
                                          dataKhususC1.length,
                                          (index) => InvoiceItem(
                                            no: no3++,
                                            mP: dataKhususC1[index].nama,
                                            pengetahuan: int.parse(
                                              dataKhususC1[index].pengetahuan,
                                            ),
                                            keterampilan: int.parse(
                                              dataKhususC1[index].keterampilan,
                                            ),
                                          ),
                                        ),
                                        itemsD: List.generate(
                                          dataKhususC2.length,
                                          (index) => InvoiceItem(
                                            no: no4++,
                                            mP: dataKhususC2[index].nama,
                                            pengetahuan: int.parse(
                                              dataKhususC2[index].pengetahuan,
                                            ),
                                            keterampilan: int.parse(
                                              dataKhususC2[index].keterampilan,
                                            ),
                                          ),
                                        ),
                                        catatanAkademik:
                                            value['catatanAkademik'] ??
                                                dataKososng,
                                        namaKepalaSekolah:
                                            controller.kepalaSekolahNama,
                                        namaOrangTua: value["namaOrtu"],
                                        namaWalikelas: controller.guru,
                                        nipKepalaSekolah:
                                            controller.kepalaSekolahNIP,
                                        nipWalikelas: controller.gmail,
                                        itemsExtra: List.generate(
                                          dataExtr.length,
                                          (index) => InvoiceItemExtra(
                                            no: dataExtr[index].no,
                                            nilai: dataExtr[index].nilai,
                                            nama: dataExtr[index].nama,
                                            keterangan:
                                                dataExtr[index].keterangan,
                                          ),
                                        ),
                                        itemsKehadiran: List.generate(
                                          dataKehadiran.length,
                                          (index) => InvoiceItemKehadiran(
                                            nilai: dataKehadiran[index].nilai ==
                                                    ""
                                                ? "-"
                                                : dataKehadiran[index].nilai,
                                            nama: dataKehadiran[index].nama,
                                          ),
                                        ),
                                        itemsPkl: List.generate(
                                          dataPKL.length,
                                          (index) => InvoiceItemPKL(
                                            keterangan:
                                                dataPKL[index].keterangan,
                                            lama: dataPKL[index].lama,
                                            lokasi: dataPKL[index].lokasi,
                                            mitra: dataPKL[index].mitra,
                                            no: dataPKL[index].no,
                                          ),
                                        ),

                                        itemsDPK: List.generate(
                                          dataDPK.length,
                                          (index) => InvoiceItemKehadiran(
                                            nilai: dataDPK[index].nilai == ""
                                                ? "-"
                                                : dataDPK[index].nilai,
                                            nama: dataDPK[index].nama,
                                          ),
                                        ),
                                        dpk: dpkG,
                                        kenaikanKelas: value["lulus"],
                                        // 'Makassar, ${controller.hari} ${controller.bulan[controller.month]} ${controller.tahun}',
                                      );
                                      // compute<int, >();
                                      Get.to(MyPDF(raport: invoice));

                                      controller.onLoading.value = false;
                                    },
                                    child: Text("PDF")),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  )
                : Center(
                    child: Text("Data Masih Kosong"),
                  );
          case ConnectionState.done:
            var dataMap = asyncSnapshot.data!.docs as Map;
            var data = dataMap["siswa"] as List;
            print(data);
            return ListView(children: [
              ...data.map(
                (value) => Column(
                  children: [
                    Text(value.toString()),
                  ],
                ),
              ),
            ]);
        }
      },
    );
  }
}

class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> inputIndex = [
      Acount(),
      TanggalRaport(),
      InputSiswa(),
      ViewDataSiswa(),
    ];

    List<IconData> iconIndex = [
      LineIcons.userCircle,
      LineIcons.calendar,
      LineIcons.userPlus,
      LineIcons.userFriends,
      LineIcons.arrowCircleLeft,
    ];

    var width = MediaQuery.of(context).size.width;
    var maxWidth = (width >= 944) ? 250.0 : 50.0;
    final controller = Get.find<GuruController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
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
              controller.namaIndex.length,
              (index) => Obx(() => AnimatedContainer(
                    height: 50,
                    width: maxWidth,
                    duration: Duration(milliseconds: 600),
                    child: Material(
                      color: index == controller.indexList.value
                          ? Colors.yellow
                          : Colors.transparent,
                      child: InkWell(
                        hoverColor: Colors.yellow[200],
                        splashColor: Colors.yellow[50],
                        highlightColor: Colors.yellow[100],
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
                                        : Colors.yellow,
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
                                      controller.namaIndex[index],
                                      style: TextStyle(
                                          color: index ==
                                                  controller.indexList.value
                                              ? Colors.white.withOpacity(0.95)
                                              : Colors.yellow[700],
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
                                      : Colors.yellow,
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
    );
  }
}

class NilaiPDF {
  final String nama;
  final String pengetahuan;
  final String keterampilan;
  NilaiPDF(this.nama, this.pengetahuan, this.keterampilan);
}
