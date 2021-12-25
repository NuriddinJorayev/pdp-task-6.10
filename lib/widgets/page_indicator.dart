import 'package:flutter/material.dart';

class PageIndicatorWidget{
static Widget build(int selectIndex, int speed){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _animatedContainer(speed, selectIndex == 0 ? Colors.white : Colors.transparent ),
        SizedBox(width: 10.0),
        _animatedContainer(speed, selectIndex == 1 ? Colors.white : Colors.transparent),
        SizedBox(width: 10.0),
        _animatedContainer(speed, selectIndex == 2 ? Colors.white : Colors.transparent),
        
      ],
  );

}
 static Widget _animatedContainer(int speed, [color]){
  return AnimatedContainer(
    duration: Duration(milliseconds: speed),
    height: 15.0,
    width: 15.0,
    decoration: BoxDecoration(
      color: color ?? Colors.transparent,
      border: Border.all(
        color: Colors.white,
        width: 2.0
      ),
      shape: BoxShape.circle
      
    ),
  );
}
}