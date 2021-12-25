// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:toast/toast.dart' show Toast;

mixin FlutterToastWidget {
  
static build(BuildContext context, String text, int time){
  Toast.show(text, context, duration: time);
} 
}