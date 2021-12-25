import 'package:flutter/material.dart';

class AppBAr1Widget {

  static Appbar(Function() back_function, String text, Function() more_function){
    return PreferredSize(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.indigo[900]!,
          Colors.pink[900]!,
        ])),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: back_function,
                    splashRadius: 10.0,
                    icon: Icon(Icons.arrow_back_ios_new),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: more_function,
                    splashRadius: 10,
                    icon: Icon(Icons.more_horiz_rounded, size: 30.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      preferredSize: (Size.fromHeight(50.0)),
    );
  }
}


  
