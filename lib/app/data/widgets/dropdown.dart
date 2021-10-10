import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

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
    return Obx(() => DropdownButton<String>(
          value: dropdownValue.value,
          icon: const Icon(LineIcons.arrowCircleDown),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: SizedBox(),
          onChanged: (newValue) async {
            dropdownValue.value = newValue!;
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