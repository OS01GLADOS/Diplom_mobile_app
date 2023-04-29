
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Загрузка...'),
        ],
      ),
    );
  }

}