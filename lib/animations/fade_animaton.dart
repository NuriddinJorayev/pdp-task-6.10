import 'package:flutter/material.dart';

class MyFadeAnimation{

  static Animation anima(AnimationController _controller){
    return Tween<double>(begin: 500.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
  }
  Widget MyAnimation(Widget child, AnimationController _controller, Animation _animation, bool isLeft){
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, chil){
        return Transform(
          transform: isLeft ? Matrix4.translationValues(_animation.value, 0.0, 0.0) : 
          Matrix4.translationValues(-_animation.value, 0.0, 0.0),
          child: child,
          );
      },
    );
  }
} 
