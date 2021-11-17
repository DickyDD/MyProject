import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget input(
  TextEditingController controller,
  String hintText,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(hintText: hintText),
    );
