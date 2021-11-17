import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tes_database/app/modules/home/controllers/home_controller.dart';

class Dropdown extends StatelessWidget {
  final List<String> list;
  final Rx<String> dropdownValue;
  const Dropdown({
    required this.list,
    Key? key,
    required this.dropdownValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() => DropdownButton<String>(
          value: dropdownValue.value,
          icon: const Icon(LineIcons.arrowCircleDown),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: SizedBox(),
          onChanged: (newValue) async {
            controller.changeDrobdownKelas();
            dropdownValue.value = newValue!;
          await controller.getDataKelas();
            
          },
          items: list.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(value),
              ),
            );
          }).toList(),
        ));
  }
}
