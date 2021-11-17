import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final int? max;
  final int? minLines, maxLines;
  final List<TextInputFormatter>? listFormat;
  final TextInputType? keyboardtype;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // inputFormatters: [TextFor],
      maxLength: max,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardtype,
      inputFormatters: listFormat,
      decoration: InputDecoration(hintText: hintText),
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
