import 'package:flutter/material.dart';

Widget input(TextEditingController controller, String hintText) => TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );