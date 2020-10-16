import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyEmailField extends StatefulWidget {
  final String hintText;
  final SvgPicture icon;
  final TextEditingController textEditingController;
  final bool obscure;
  final TextInputType textInputType;
  final Color fillColor;
  final Function onChanged;
  List<LengthLimitingTextInputFormatter> lengthLimitingTextInputFormatter = [
    LengthLimitingTextInputFormatter(20),
  ];

  MyEmailField(
      {@required this.hintText,
      @required this.icon,
      @required this.obscure,
      this.textEditingController,
      this.lengthLimitingTextInputFormatter,
      this.onChanged,
      this.textInputType,
      this.fillColor});

  @override
  _MyEmailFieldState createState() => _MyEmailFieldState();
}

class _MyEmailFieldState extends State<MyEmailField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      inputFormatters: widget.lengthLimitingTextInputFormatter,
      onChanged: widget.onChanged,
      keyboardType: widget.textInputType,
      cursorWidth: 3,
      validator: (value) {
        if (value.isEmpty || !value.contains('@') || !value.contains('.com')) {
          return 'Invalid email!';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 26.0, horizontal: 10),
        filled: true,
        fillColor: widget.fillColor,
        border: new OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(20.0),
          ),
        ),
        labelStyle: TextStyle(color: Colors.white, fontSize: 18),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: widget.icon,
        ),
      ),
    );
  }
}
