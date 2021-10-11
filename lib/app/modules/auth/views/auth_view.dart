import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/data/widgets/card_shadow.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Lottie.asset(
            'assets/auth.json',
          ),
          Text(
            'Raport Digital'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          )
            ],
          ),
        ),
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
                      ...List.generate(
                        controller.hintText.length,
                        (index) => Column(
                          children: [
                            Container(
                              width: Get.width * 0.33,
                              child: AuthTextFormField(
                                hintText: controller.hintText[index],
                                prefixIcon: controller.inconPrefix[index],
                                controller: controller.listC[index],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      // TextButton(
                      //     onPressed: () {
                           
                      //     },
                      //     child: Text('Login')),
                      ButtonCustom(nama: 'Login', onTap: ()async{
                         controller.loginFake(
                              controller.listC[0].text,
                              controller.listC[1].text,
                            );
                      }, style: TextStyle(fontWeight: FontWeight.w600),)
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
  }) : super(key: key);

  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;

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
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon),
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
