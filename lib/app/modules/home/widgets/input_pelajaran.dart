import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tes_database/app/data/validator/nilai.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import '../controllers/home_controller.dart';

class InputPelajaran extends StatelessWidget {
  const InputPelajaran({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final jumlahJurusan = controller.listJurusan.length.obs;
    final sizeKhususC1 = controller.panjangListKhususC1;
    final sizeKhususC3 = controller.panjangListKhususC3;
    final sizeKhususC2 = controller.panjangListKhususC2;
    final sizeKhususKKNC1 = controller.panjangListKhususKKNC1;
    final sizeKhususKKNC3 = controller.panjangListKhususKKNC3;
    final sizeKhususKKNC2 = controller.panjangListKhususKKNC2;
    return Obx(
      () => jumlahJurusan.value != 0
          ? Form(
              key: controller.formKey,
              onChanged: () {
                var _isValid = false;
                var formKey = controller.formKey;
                final isValid = formKey.currentState!.validate();
                if (_isValid != isValid) {
                  _isValid = isValid;
                }
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: Get.height,
                      color: Colors.blue[50],
                      child: PelajaranWidget(
                        sizeJurusan: controller.panjangListUmum.length,
                        controller: controller,
                        listData: controller.listPelajaranUmum,
                        jenis: 'Umum',
                        listPanjang: controller.panjangListUmum,
                        input: () => controller.inputPelajaranUmum(),
                        listPanjangKKN: controller.panjangListUmumKKN,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: Get.height,
                      color: Colors.red[50],
                      child: PelajaranWidgetKhusus(
                        sizeJurusan: controller.listPelajaranKhusus.length,
                        controller: controller,
                        listData: controller.listPelajaranKhusus,
                        jenis: 'Khusus',
                        input: () => controller.inputPelajaranKhusus(),
                        listPanjangC1: sizeKhususC1,
                        listPanjangC2: sizeKhususC2,
                        listPanjangC3: sizeKhususC3,
                        listPanjangKKNC1: sizeKhususKKNC1,
                        listPanjangKKNC2: sizeKhususKKNC2,
                        listPanjangKKNC3: sizeKhususKKNC3,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text('data Null'),
            ),
    );
  }
}

class PelajaranWidget extends StatelessWidget {
  final List<PelajaranUmum> listData;
  final List<int> listPanjang;
  final List<int> listPanjangKKN;
  final String jenis;
  final Function() input;
  const PelajaranWidget({
    Key? key,
    required this.sizeJurusan,
    required this.controller,
    required this.listData,
    required this.jenis,
    required this.listPanjang,
    required this.input,
    required this.listPanjangKKN,
  }) : super(key: key);

  final int sizeJurusan;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    var sC = ScrollController();
    return Scrollbar(
      isAlwaysShown: true,
      controller: sC,
      child: ListView.builder(
        controller: sC,
        itemCount: sizeJurusan,
        itemBuilder: (context, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (i == 0)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Pelajaran $jenis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CardShadow(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(listData[i].id),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        controller.addPelajranUmum(i);
                      },
                      icon: Container(
                        decoration: new BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LineIcons.plusCircle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                var panjang = listPanjang[i].obs;
                return Container(
                  child: Column(
                    children: List<Widget>.generate(panjang.value, (index) {
                      final dataC = listData[i].pelajaran[index];
                      final dataKKN = listData[i].KKN[index];
                      var C = TextEditingController(
                        text: dataC.toString(),
                      );
                      var KKN = TextEditingController(
                        text: dataKKN.toString(),
                      );
                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CardShadow(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: C,
                                  onChanged: (str) =>
                                      listData[i].pelajaran[index] = str,
                                  decoration: InputDecoration(
                                    hintText: 'Pelajarana',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CardShadow(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: KKN,
                                  validator: (val) => validateNilai(val!),
                                  inputFormatters: [
                                    TextInputMask(mask: '999'),
                                  ],
                                  keyboardType: TextInputType.number,
                                  onChanged: (str) =>
                                      listData[i].KKN[index] = str,
                                  decoration: InputDecoration(
                                    hintText: 'KKM',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              // padding: EdgeInsets.zero,
                              // splashRadius: 1,
                              onPressed: () {
                                Get.defaultDialog(
                                  middleText: 'Yakin Ingin menghapus',
                                  actions: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                      ),
                                      onPressed: () {
                                        controller.lessPelajranUmum(
                                            i,
                                            listData[i].pelajaran[index],
                                            listData[i].KKN[index]);

                                        Get.back();
                                      },
                                      child: Text('Yakin'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('Tidak'),
                                    ),
                                  ],
                                  title: 'Hapus?',
                                );
                              },
                              icon: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  LineIcons.minusCircle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                );
              }),
              SizedBox(
                height: 10,
              ),
              if (i == sizeJurusan - 1)
                Center(
                    child: ButtonCustom(
                        nama: 'Save',
                        onTap: () async {
                          input();
                        })),
            ],
          );
        },
      ),
    );
  }
}

class PelajaranWidgetKhusus extends StatelessWidget {
  final List<PelajaranKhusus> listData;
  final RxList<int> listPanjangC1;
  final RxList<int> listPanjangC2;
  final RxList<int> listPanjangC3;
  final RxList<int> listPanjangKKNC1;
  final RxList<int> listPanjangKKNC2;
  final RxList<int> listPanjangKKNC3;
  final String jenis;
  final Function() input;
  const PelajaranWidgetKhusus({
    Key? key,
    required this.sizeJurusan,
    required this.controller,
    required this.listData,
    required this.jenis,
    required this.listPanjangC1,
    required this.listPanjangC2,
    required this.listPanjangC3,
    required this.input,
    required this.listPanjangKKNC1,
    required this.listPanjangKKNC2,
    required this.listPanjangKKNC3,
  }) : super(key: key);

  final int sizeJurusan;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    var sC = ScrollController();
    return Scrollbar(
      isAlwaysShown: true,
      controller: sC,
      child: ListView.builder(
        controller: sC,
        itemCount: sizeJurusan,
        itemBuilder: (context, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (i == 0)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Text(
                        'Pelajaran $jenis',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  CardShadow(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(listData[i].id),
                    ),
                  ),
                ],
              ),
              Obx(() {
                var panjangC1 = listPanjangC1[i].obs;
                var panjangC2 = listPanjangC2[i].obs;
                var panjangC3 = listPanjangC3[i].obs;
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: CardShadow(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('C1'),
                                    )),
                                  ),
                                  Spacer(
                                    flex: 3,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        controller.addPelajranKhususC1(i);
                                      },
                                      icon: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.greenAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          LineIcons.plusCircle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...List<Widget>.generate(panjangC1.value,
                                  (index) {
                                final dataC = listData[i].pelajaranC1[index];
                                var C = TextEditingController(
                                  text: dataC.toString(),
                                );
                                final dataKKN = listData[i].nilaiKKNC1[index];
                                var KKN = TextEditingController(
                                  text: dataKKN.toString(),
                                );
                                return Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: CardShadow(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: C,
                                            onChanged: (str) => listData[i]
                                                .pelajaranC1[index] = str,
                                            decoration: InputDecoration(
                                              hintText: 'Pelajarana',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CardShadow(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: KKN,
                                            validator: (val) =>
                                                validateNilai(val!),
                                            inputFormatters: [
                                              TextInputMask(mask: '999'),
                                            ],
                                            keyboardType: TextInputType.number,
                                            onChanged: (str) => listData[i]
                                                .nilaiKKNC1[index] = str,
                                            decoration: InputDecoration(
                                              hintText: 'KKM',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        splashRadius: 1,
                                        onPressed: () {
                                          Get.defaultDialog(
                                            middleText: 'Yakin Ingin menghapus',
                                            actions: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .lessPelajranKhususC1(
                                                    i,
                                                    listData[i]
                                                        .pelajaranC1[index],
                                                    listData[i]
                                                        .nilaiKKNC1[index],
                                                  );

                                                  Get.back();
                                                },
                                                child: Text('Yakin'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text('Tidak'),
                                              ),
                                            ],
                                            title: 'Hapus?',
                                          );
                                        },
                                        icon: Container(
                                          decoration: new BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            LineIcons.minusCircle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          )),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CardShadow(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('C2'),
                                )),
                              ),
                              Spacer(
                                flex: 3,
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    controller.addPelajranKhususC2(i);
                                  },
                                  icon: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.greenAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      LineIcons.plusCircle,
                                      // color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...List<Widget>.generate(panjangC2.value, (index) {
                            final dataC = listData[i].pelajaranC2[index];
                            var C = TextEditingController(
                              text: dataC.toString(),
                            );
                            final dataKKN = listData[i].nilaiKKNC2[index];
                            var KKN = TextEditingController(
                              text: dataKKN.toString(),
                            );
                            return Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CardShadow(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: C,
                                        onChanged: (str) => listData[i]
                                            .pelajaranC2[index] = str,
                                        decoration: InputDecoration(
                                          hintText: 'Pelajarana',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CardShadow(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: KKN,
                                        validator: (val) => validateNilai(val!),
                                        inputFormatters: [
                                          TextInputMask(mask: '999'),
                                        ],
                                        keyboardType: TextInputType.number,
                                        onChanged: (str) =>
                                            listData[i].nilaiKKNC2[index] = str,
                                        decoration: InputDecoration(
                                          hintText: 'KKM',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    splashRadius: 1,
                                    onPressed: () {
                                      Get.defaultDialog(
                                        middleText: 'Yakin Ingin menghapus',
                                        actions: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                            ),
                                            onPressed: () {
                                              controller.lessPelajranKhususC2(
                                                i,
                                                listData[i].pelajaranC2[index],
                                                listData[i].nilaiKKNC2[index],
                                              );

                                              Get.back();
                                            },
                                            child: Text('Yakin'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text('Tidak'),
                                          ),
                                        ],
                                        title: 'Hapus?',
                                      );
                                    },
                                    icon: Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        LineIcons.minusCircle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CardShadow(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('C3'),
                                )),
                              ),
                              Spacer(
                                flex: 3,
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    controller.addPelajranKhususC3(i);
                                  },
                                  icon: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.greenAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(LineIcons.minusCircle),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...List<Widget>.generate(panjangC3.value, (index) {
                            final dataC = listData[i].pelajaranC3[index];
                            var C = TextEditingController(
                              text: dataC.toString(),
                            );
                            final dataKKN = listData[i].nilaiKKNC3[index];
                            var KKN = TextEditingController(
                              text: dataKKN.toString(),
                            );
                            return Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CardShadow(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: C,
                                        onChanged: (str) => listData[i]
                                            .pelajaranC3[index] = str,
                                        decoration: InputDecoration(
                                          hintText: 'Pelajarana',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CardShadow(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: KKN,
                                        validator: (val) => validateNilai(val!),
                                        inputFormatters: [
                                          TextInputMask(mask: '999'),
                                        ],
                                        keyboardType: TextInputType.number,
                                        onChanged: (str) =>
                                            listData[i].nilaiKKNC3[index] = str,
                                        decoration: InputDecoration(
                                          hintText: 'KKM',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    splashRadius: 1,
                                    onPressed: () {
                                      Get.defaultDialog(
                                        middleText: 'Yakin Ingin menghapus',
                                        actions: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                            ),
                                            onPressed: () {
                                              controller.lessPelajranKhususC3(
                                                i,
                                                listData[i].pelajaranC3[index],
                                                listData[i].nilaiKKNC3[index],
                                              );

                                              Get.back();
                                            },
                                            child: Text('Yakin'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text('Tidak'),
                                          ),
                                        ],
                                        title: 'Hapus?',
                                      );
                                    },
                                    icon: Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        LineIcons.minusCircle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(
                height: 10,
              ),
              if (i == sizeJurusan - 1)
                Center(
                    child: ButtonCustom(
                        nama: 'Save',
                        onTap: () async {
                          input();
                        })),
            ],
          );
        },
      ),
    );
  }
}
