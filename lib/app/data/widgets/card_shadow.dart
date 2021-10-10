import 'package:flutter/material.dart';

class CardShadow extends StatelessWidget {
  const CardShadow({
    Key? key,
    required this.child,
    this.width, this.horizontal = 5, this.vertical = 5,
  }) : super(key: key);

  final Widget child;
  final double? width;
  final double? horizontal;
  final double? vertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: horizontal!, vertical: vertical!),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(0, 2),
            spreadRadius: 5,
            color: Color(0xffB5BCC2).withOpacity(0.15),
          )
        ],
      ),
      child: child,
    );
  }
}