import 'package:flutter/material.dart';

Future<bool> confirmAction(BuildContext context, String action_description) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Подтвердите действие"),
        content: Text(action_description),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("ОТМЕНА"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("ПОДТВЕРДИТЬ"),
          ),
        ],
      );
    },
  );
}