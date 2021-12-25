import 'package:flutter/material.dart';

class ButtonBuilder {
  final baseColor = Color.fromARGB(255, 81, 115, 238);
 

  Widget build(BuildContext context, buttonText, bool isLoading, isvis()) {
    Size allSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: isvis,
      child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          alignment: Alignment.center,
          height: 55.0,
          width: isLoading ? 55.0 : allSize.width - 80,

          decoration: BoxDecoration(
            
            borderRadius: BorderRadius.circular(28.0),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              colors: [Colors.blue[400]!, Colors.indigo[600]!],
            ),
          ),

          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(buttonText, style: TextStyle(
                color: Colors.white, 
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2
                ))),
    );
  }
}
