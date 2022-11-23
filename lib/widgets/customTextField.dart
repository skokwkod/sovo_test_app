import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
    required this.label,

  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder()
      ),

    );
  }
}