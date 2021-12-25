import 'package:flutter/material.dart';

class GreyTextFieldWidget{

  static Widget build(String hintText, var control){
    return Container(
      height: hintText.compareTo("Content") == 0 ? 120.0 : 50.0,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 0.3, horizontal: 20.0),
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            color: Colors.grey,
            width: 3.0,
          )),
      child: TextField(
        style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1),
            controller: control,
        cursorColor: Colors.black,       
        maxLines: hintText.compareTo("Content") == 0 ? 4 : 1,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1),
            border: InputBorder.none),
      ),
    );
  }
}