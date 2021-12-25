import 'package:flutter/material.dart';

class RichTextWidget {
  static Widget build(String text1, String text2, Function() func) {
    return Container(
      height: 50.0,
      width: double.infinity,
      color: Colors.indigo[600],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text1, style: TextStyle(color: Colors.white, fontSize: 16.0)),
          SizedBox(width: 10.0),
          InkWell(
            onTap: func,
            child: Text(text2,
                style: TextStyle(
                    color: Colors.white, fontSize: 16.0, decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }
}
