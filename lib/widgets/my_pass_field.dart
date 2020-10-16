import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPassField extends StatefulWidget {
  final TextEditingController passwordController;
  final String hintText;
  final SvgPicture prefixIcon;
  final bool obscure;
  final TextInputType textInputType;

  MyPassField({
    @required this.hintText,
    @required this.prefixIcon,
    @required this.obscure,
    this.passwordController,
    this.textInputType,
  });

  @override
  _MyPassFieldState createState() => _MyPassFieldState();
}

class _MyPassFieldState extends State<MyPassField> {
  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: _obscureText,
      cursorWidth: 3,
      validator: (value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password is too short!';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 26.0, horizontal: 10),
        filled: true,
        fillColor: Color(0xFFA9B7E2),
        border: new OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(20.0),
          ),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 5),
          child: widget.prefixIcon,
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            _toggle();
          },
        ),
      ),
    );
  }
}
