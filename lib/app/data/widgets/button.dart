import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonCustom extends StatelessWidget {
  final String nama;
  final TextStyle? style;
  final Future<dynamic> Function() onTap;

  const ButtonCustom({
    Key? key,
    required this.nama,
    required this.onTap,
     this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 200.0;
    var onLoadingButton = false.obs;
    var tap = () async {
      width = 40;
      onLoadingButton.value = true;
      await onTap().whenComplete(() {
        onLoadingButton.value = false;
        width = 200;
      });
    };
    return Column(
      children: [
        Obx(() => Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                height: 40,
                width: width,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      offset: Offset(1, 2),
                      spreadRadius: 2,
                      color: Color(0xffB5BCC2).withOpacity(0.15),
                    )
                  ],
                ),
                duration: Duration(milliseconds: 400),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: onLoadingButton.value == false ? tap : null,
                      child: onLoadingButton.value == false
                          ? Center(
                              child: Text(
                              nama,
                              style: style,
                            ))
                          : Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
