import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tes_database/app/data/validator/nilai.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/modules/guru/controllers/guru_controller.dart';
// import 'package:tes_database/app/modules/guru/controllers/guru_controller.dart';
// import 'package:tes_database/app/modules/guru/views/guru_view.dart';
import 'package:tes_database/app/modules/siswa/controllers/firebase_upload.dart';
import '../controllers/siswa_controller.dart';

class SiswaView extends GetView<SiswaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${controller.nama.text}"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'Edit',
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      controller.onEdit.value = !controller.onEdit.value;
                    },
                    child: Text('Yakin'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Tidak'),
                  ),
                ],
                middleText: 'Anda Yakin Edit ?',
              );
            },
            icon: Icon(LineIcons.edit),
          ),
        ],
      ),
      body: controller.onLoading.value == false
          ? InputSiswa()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

// Input Siswa
class InputSiswa extends StatelessWidget {
  const InputSiswa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List? fileSiswa;
    final controller = Get.find<SiswaController>();
    var inputNilai = controller.kelas.split(' ')[1];
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
                                    : controller.data[15],
                              ),
                            ),
                          ),

                          child: InkWell(
                            onTap: () async {
                              fileSiswa = await controller
                                  .getImages(controller.imageGuru);
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
                    controller.inputDataSiswa().whenComplete(() =>
                        Get.defaultDialog(
                            title: 'Berhasil',
                            middleText:
                                '${controller.nama.text} Data Sudah Berahasil Terinput'));
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
  final SiswaController controller;

  @override
  Widget build(BuildContext context) {
    // var _isValid = false.obs;
    return Form(
      key: controller.formKey,
      onChanged: () {
        var _isValid = false;
        var formKey = Get.find<SiswaController>().formKey;
        final isValid = formKey.currentState!.validate();
        if (_isValid != isValid) {
          _isValid = isValid;
        }
      },
      child: Column(
        children: [
          Divider(),
          Obx(() {
            var list = controller.listGabunganKhusus;
            var panjang = list.length.obs;
            var panjangList = controller.dataListKhusus.length.obs;
            controller.dropdownValueKhusus = List.generate(
              panjangList.value,
              (idx) => list[controller.dataListKhusus[idx]].obs,
            );

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
                                    dropdownValue:
                                        controller.dropdownValueKhusus[index],
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
                                    key:
                                        Key(controller.nilaiKhusus[index].text),
                                    controller: controller.nilaiKhusus[index],
                                    max: 3,
                                    keyboardtype: TextInputType.number,
                                    validator: (val) => validateNilai(val!),
                                    listFormat: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    hintText: 'Nilai',
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
                                      controller.dropdownValueKhusus.removeAt(
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
            var panjangList = controller.dataListUmum.length.obs;
            controller.dropdownValueUmum = List.generate(
              panjangList.value,
              (idx) => list[controller.dataListUmum[idx]].obs,
            );
            print(232);
            return Column(
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
                              padding:
                                  EdgeInsets.only(top: 22, bottom: 22, left: 8),
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
                                hintText: 'Nilai',
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
            );
          }),

          inputNilai != '9'
              ? Obx(() {
                  var list = controller.listDataPKL;
                  var panjang = list.length.obs;
                  var panjangList = controller.dataListPKL.length.obs;
                  controller.dropdownValuePKL = List.generate(
                    panjangList.value,
                    (idx) => list[controller.dataListPKL[idx]].obs,
                  );
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
                                  controller.dropdownValuePKL = [
                                    ...controller.dropdownValuePKL,
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
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 22, bottom: 22, left: 8),
                                        child: Dropdown(
                                          dropdownValue: controller
                                              .dropdownValuePKL[index],
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
                                          // key:Key(controller.nialiKehadiran[index].text),
                                          controller: controller.lamaPKL[index],
                                          max: 3,
                                          keyboardtype: TextInputType.number,
                                          // validator: (val) =>
                                          //     validateNilai(val!),
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
                                            controller.dropdownValuePKL
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
            var panjangList = controller.dropdownValueEXR.length.obs;

            return Column(
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
                              padding:
                                  EdgeInsets.only(top: 22, bottom: 22, left: 8),
                              child: DropdownE(
                                dropdownValue:
                                    controller.dropdownValueEXR[index],
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
                                controller: controller.nilaiEXR[index],
                                maxLines: 3,
                                validator: (val) =>
                                    val!.isEmpty ? "Tidak Boleh kosong" : null,
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
            );
          }),

          // kehadirannnn
          Divider(),
         
Column(
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
                  3,
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
                                  controller.listKehadiran[index],
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
                                key: Key(controller.nialiKehadiran[index].text),
                                controller: controller.nialiKehadiran[index],
                                max: 1,
                                validator: (val) => validateNilai(val!),
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
            
          ),
          // kehadirannnn
          Divider(),
          Column(
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
                controller.listDPK.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Card(
                          child: Padding(
                              padding:
                                  EdgeInsets.only(top: 22, bottom: 22, left: 8),
                              child: Text(
                                controller.listDPK[index],
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
                              validator: (val) => validateNilai(val!),
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
          ),
        ],
      ),
    );
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
    final c = Get.find<SiswaController>();
    return Obx(() => TextFormField(
          controller: controller,
          // inputFormatters: [TextFor],
          maxLength: max,
          readOnly: c.onEdit.value,
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
    final c = Get.find<SiswaController>();
    return Obx(() => TextFormField(
          controller: controller,
          // inputFormatters: [TextFor],
          maxLength: max,
          readOnly: c.onEdit.value,
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
    final c = Get.find<SiswaController>();
    return Obx(() => TextFormField(
          controller: controller,
          // inputFormatters: [TextFor],
          maxLength: max,
          readOnly: c.onEdit.value,
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
    final c = Get.find<SiswaController>();
    return Obx(() => TextFormField(
          controller: controller,
          maxLength: max,
          readOnly: c.onEdit.value,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: keyboardtype,
          validator: validator,
          inputFormatters: listFormat,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: hintText,
          ),
        ));
  }
}
