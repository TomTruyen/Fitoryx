import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String hintText;
  final double radius;
  final TextInputType inputType;
  final bool isPassword;
  final String? Function(String?) validator;
  final Function(String) onChanged;

  const FormInput({
    Key? key,
    this.hintText = "",
    this.radius = 8,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    required this.validator,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(radius),
        ),
        fillColor: Colors.grey[300],
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
