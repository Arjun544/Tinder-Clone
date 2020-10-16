 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String msg, String title) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: new Text(title),
              content: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: new Text(
                  msg,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }