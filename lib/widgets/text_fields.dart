import 'package:flutter/material.dart';

class TextFields_widget{

  Widget build(BuildContext context, hintText, icon, control, Widget WidgetChild, [bool password = false]) {
    
    final baseColor = Color.fromARGB(255, 81, 115, 238);
    Size allsize = MediaQuery.of(context).size;
    return Container(
      height: 55.0,
      width: allsize.width - 80,
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: baseColor,
          width: 3.0,
        )
      ),

      child: TextField(
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, letterSpacing: 1.2),
        obscuringCharacter: '*',
        obscureText: password,
        controller: control,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText, 
          hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, letterSpacing: 1.2),
          suffixIcon: WidgetChild,
          prefixIcon: Icon(icon, color: baseColor)
        ),
      ),
    );
  }
}
