import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:tes_database/app/data/validator/nilai.dart';

import '../controllers/tes_siswa_controller.dart';

class TesSiswaView extends GetView<TesSiswaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TesSiswaView'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.dataSiswa.value.length != 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
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
                            direction: Get.width >= 1140
                                ? Axis.horizontal
                                : Axis.vertical,
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
                        onChanged: (value) =>
                            controller.indexDataSiswa.value = value!,
                        showSearchBox: true,
                        selectedItem: controller.indexDataSiswa.value,
                      ),
                    ),
                  ),
                  DataWalikelas(
                    nama: 'Nama',
                    value: controller.indexDataSiswa.value.nama!,
                  ),
                  DataWalikelas(
                    nama: 'NIS',
                    value: controller.indexDataSiswa.value.nis!,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 22,
                              bottom: 22,
                              left: 8,
                            ),
                            child: DropdownSearch<ListPelajaran>(
                              items: controller.listGabunganUmum,
                              maxHeight: 300,
                              dropdownSearchDecoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              showSelectedItems: false,
                              dropdownBuilder: (context, selectedItem) =>
                                  Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Flex(
                                  direction: Get.width >= 1140
                                      ? Axis.horizontal
                                      : Axis.vertical,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${selectedItem!.type} : ",
                                    ),
                                    Text(
                                      "${selectedItem.name}",
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              itemAsString: (item) =>
                                  '${item!.type} ${item.name}',
                              onChanged: print,
                              showSearchBox: true,
                              selectedItem: controller.dataNilaiUmum.value,
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
                              controller: controller.nilaiUmum,
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
                              controller: controller.keterampilanUmum,
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
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 22,
                              bottom: 22,
                              left: 8,
                            ),
                            child: DropdownSearch<ListPelajaran>(
                              items: controller.listGabunganKhusus,
                              maxHeight: 300,
                              dropdownSearchDecoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              showSelectedItems: false,
                              dropdownBuilder: (context, selectedItem) =>
                                  Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Flex(
                                  direction: Get.width >= 1140
                                      ? Axis.horizontal
                                      : Axis.vertical,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${selectedItem!.type} : ",
                                    ),
                                    Text(
                                      "${selectedItem.name}",
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              itemAsString: (item) =>
                                  '${item!.type} ${item.name}',
                              onChanged: print,
                              showSearchBox: true,
                              selectedItem: controller.dataNilaiKhusus.value,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EditingInputSiswaNilai(
                              controller: controller.nilaiKhusus,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EditingInputSiswaNilai(
                              controller: controller.keterampilanKhusus,
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
                    ],
                  ),
                  
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        
      },child: Text('Save'),),
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
