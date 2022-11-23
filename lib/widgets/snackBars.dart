import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, Color bacgroundColor){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(text),
          backgroundColor: bacgroundColor,
      ));
}