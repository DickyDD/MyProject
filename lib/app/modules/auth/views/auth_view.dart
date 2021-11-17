import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_database/app/data/validator/password.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(children: [
        width >= 700
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/login.png'),
                    Text(
                      'Raport Digital'.toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                    )
                  ],
                ),
              )
            : SizedBox(),
        Expanded(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: double.infinity,
                color: Colors.blue[50],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: height * 0.2,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Column(
                        children: [
                          Container(
                            width: width >= 700
                                ? Get.width * 0.33
                                : Get.width * 0.8,
                            child: AuthTextFormField(
                              hintText: controller.hintText[0],
                              validator: (val) => validateUser(val!),
                              prefixIcon: controller.inconPrefix[0],
                              controller: controller.listC[0],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: width >= 700
                                ? Get.width * 0.33
                                : Get.width * 0.8,
                            child: AuthTextFormField(
                              hintText: controller.hintText[1],
                              validator: (val) => validatePassword(val!),
                              prefixIcon: controller.inconPrefix[1],
                              controller: controller.listC[1],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      ButtonCustom(
                        nama: 'Login',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            controller.loginFake(
                              controller.listC[0].text,
                              controller.listC[1].text,
                            );
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.validator,
  }) : super(key: key);

  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return CardShadow(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        child: TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon),
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
