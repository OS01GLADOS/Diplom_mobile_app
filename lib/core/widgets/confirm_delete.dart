import 'package:flutter/material.dart';

Future<bool> confirmDelete(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Подтвердите действие"),
        content: Text("Вы увверены, что хотите удалить этот элемент?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("ОТМЕНА"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("УДАЛИТЬ"),
          ),
        ],
      );
    },
  );
}