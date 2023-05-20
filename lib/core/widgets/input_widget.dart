import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:flutter/material.dart';


class InputWidget extends StatefulWidget {
  InputWidget(
      this.label,
      this.textboxController,
      [
        this.type = 'text'
      ]
      ){
    switch(type) {
      case 'password': {
        obscure_text = true;
        keyboardType = TextInputType.visiblePassword;
      }
      break;
      case 'email':{
        keyboardType = TextInputType.emailAddress;
      }
    }
  }
  TextEditingController textboxController;
  String label;

  String type;
  bool obscure_text = false;
  TextInputType keyboardType = TextInputType.text;

  @override
  State<InputWidget> createState() => new InputWidgetState();

}


class InputWidgetState extends State<InputWidget> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: ColorConstants.lightGreen,
                width: 1
            ),
            color: ColorConstants.whiteBackground,
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите значение';
              }
              return null;
            },
            obscureText: widget.obscure_text,
            controller: widget.textboxController,
            keyboardType: widget.keyboardType,
            style: TextStyle(color: ColorConstants.usualGreenUsualText),
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.usualGreenUsualText, width: 2)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.lightGreen, width: 2)),
              errorStyle: TextStyle(color: ColorConstants.redError),
            ),

          ),
        ),
        Positioned(
          left: 30,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: ColorConstants.whiteBackground,
            child: Text(
              widget.label,
              style: TextStyle(
                  color: ColorConstants.lightGreen,
                  fontSize: 12
              ),
            ),
          ),
        ),
      ],
    );
  }
}
