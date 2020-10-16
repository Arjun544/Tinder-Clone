import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
    this.btnColor,
    this.txtColor,
    this.btnHeight,
    this.btnWidth,
    this.fontSize,
    this.btnGradient
  }) : super(key: key);
  final String text;
  final Function press;
  final Color btnColor;
  final Color txtColor;
  final double btnHeight;
  final double btnWidth;
  final double fontSize;
  final LinearGradient btnGradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
          child: Center(
        child: Container(
          alignment: Alignment.center,
          width: btnWidth,
          height: btnHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: btnColor,
              gradient: btnGradient),
          child: Text(
            text,
            style: TextStyle(
                fontSize: fontSize,
                color: txtColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
        ),
      ),
    );
  }
}
