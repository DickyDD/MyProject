import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';
import 'package:tes_database/app/modules/guru/controllers/guru_controller.dart';

import '../controllers/biodata_siswa_controller.dart';

class BiodataSiswaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BiodataSiswaController>();
    final sC = ScrollController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await Get.find<GuruController>().getBiodata().whenComplete(
                  () => Get.back(),
                );
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        backgroundColor: Colors.yellow[600],
        title: Text(
          'Biodata',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.dataSiswa.value.length != 0
            ? Scrollbar(
                controller: sC,
                isAlwaysShown: true,
                child: ListView.builder(
                    controller: sC,
                    itemCount: 17,
                    itemBuilder: (ctx, idx) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (idx == 0) SearchSiswa(controller: controller),
                          Obx(
                            () => controller.onChange.value == false
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: idx < 10
                                        ? Pertanyaan(
                                            controller: controller,
                                            idx: idx,
                                          )
                                        : idx == 10
                                            ? PertanyaanDua(
                                                controller: controller,
                                                idx1: 10,
                                                idx2: 11,
                                                idxPertanyaan: 0,
                                              )
                                            : idx == 11
                                                ? PertanyaanDua(
                                                    controller: controller,
                                                    idx1: 12,
                                                    idx2: 13,
                                                    idxPertanyaan: 1,
                                                  )
                                                : idx == 12
                                                    ? PertanyaanDua(
                                                        controller: controller,
                                                        idx1: 14,
                                                        idx2: 15,
                                                        idxPertanyaan: 0,
                                                        jumlahpertanyaan: true,
                                                      )
                                                    : idx == 13
                                                        ? PertanyaanDua(
                                                            controller:
                                                                controller,
                                                            idx1: 16,
                                                            idx2: 17,
                                                            idxPertanyaan: 2,
                                                            // jumlahpertanyaan: true,
                                                          )
                                                        : idx == 14
                                                            ? Pertanyaan1(
                                                                controller:
                                                                    controller,
                                                                idx: 14,
                                                                jawabanidx: 18,
                                                              )
                                                            : idx == 16
                                                                ? Pertanyaan1(
                                                                    controller:
                                                                        controller,
                                                                    idx: 16,
                                                                    jawabanidx:
                                                                        21,
                                                                  )
                                                                : PertanyaanDua(
                                                                    controller:
                                                                        controller,
                                                                    idx1: 19,
                                                                    idx2: 20,
                                                                    idxPertanyaan:
                                                                        1,
                                                                    jumlahpertanyaan:
                                                                        true,
                                                                  ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ],
                      );
                    }),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(controller.jawaban);
          controller.inputDataSiswa();
        },
        child: Text('Save'),
      ),
    );
  }
}

class Pertanyaan extends StatelessWidget {
  const Pertanyaan({
    Key? key,
    required this.controller,
    required this.idx,
  }) : super(key: key);

  final BiodataSiswaController controller;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return CardShadow(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: TextEditingController(
            text: controller.jawaban[idx],
          ),
          onChanged: (value) => controller.jawaban[idx] = value,
          readOnly: (idx < 2) ? true : false,
          decoration: InputDecoration(
            labelText: controller.pertanyaan[idx],
          ),
        ),
      ),
    );
  }
}

class Pertanyaan1 extends StatelessWidget {
  const Pertanyaan1({
    Key? key,
    required this.controller,
    required this.idx,
    required this.jawabanidx,
  }) : super(key: key);

  final BiodataSiswaController controller;
  final int idx;
  final int jawabanidx;

  @override
  Widget build(BuildContext context) {
    return CardShadow(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: TextEditingController(
            text: controller.jawaban[jawabanidx],
          ),
          onChanged: (value) => controller.jawaban[jawabanidx] = value,
          decoration: InputDecoration(
            labelText: controller.pertanyaan[idx],
          ),
        ),
      ),
    );
  }
}

class PertanyaanDua extends StatelessWidget {
  const PertanyaanDua({
    Key? key,
    required this.controller,
    required this.idx1,
    required this.idx2,
    required this.idxPertanyaan,
    this.jumlahpertanyaan = false,
  }) : super(key: key);

  final BiodataSiswaController controller;
  final int idx1;
  final int idx2;
  final int idxPertanyaan;
  final bool jumlahpertanyaan;

  @override
  Widget build(BuildContext context) {
    return CardShadow(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (jumlahpertanyaan != true)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.pertanyaan2[idxPertanyaan].pertanyaan),
                  Divider(
                    color: Colors.grey[400],
                  ),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: controller.jawaban[idx1],
                    ),
                    onChanged: (value) => controller.jawaban[idx1] = value,
                    decoration: InputDecoration(
                      labelText: jumlahpertanyaan != true
                          ? controller.pertanyaan2[idxPertanyaan].subPertanyaan1
                          : controller.petanyaan1[idxPertanyaan].pertanyaan,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: controller.jawaban[idx2],
                    ),
                    onChanged: (value) => controller.jawaban[idx2] = value,
                    decoration: InputDecoration(
                      labelText: jumlahpertanyaan != true
                          ? controller.pertanyaan2[idxPertanyaan].subPertanyaan2
                          : controller.petanyaan1[idxPertanyaan].subPertanyaan1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SearchSiswa extends StatelessWidget {
  const SearchSiswa({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BiodataSiswaController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CardShadow(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownSearch<SiswaData>(
                items: controller.dataSiswa.value,
                maxHeight: 300,
                dropdownSearchDecoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                showSelectedItems: false,
                dropdownBuilder: (context, selectedItem) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Flex(
                    direction:
                        Get.width >= 1140 ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${selectedItem!.nama} ",
                      ),
                      Text(
                        "(${selectedItem.nis})",
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                itemAsString: (item) => '${item!.nama} (${item.nis})',
                onChanged: (value) {
                  controller.indexDataSiswa.value = value!;
                  controller.dropdownBerubah(value);
                },
                showSearchBox: true,
                selectedItem: controller.indexDataSiswa.value,
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
