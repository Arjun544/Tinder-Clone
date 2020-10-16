import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget dismissBackground() {
  return Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20),
    color: Colors.red,
    child: Icon(
      Icons.delete_sweep,
      color: Colors.white,
    ),
  );
}
