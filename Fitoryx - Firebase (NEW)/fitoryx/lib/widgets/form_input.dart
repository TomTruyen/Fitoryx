import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class FormInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? initialValue;
  final double radius;
  final int? maxLines;
  EdgeInsetsGeometry? contentPadding;
  final TextInputType inputType;
  final TextInputAction? inputAction;
  final bool readOnly;
  final bool isDense;
  final bool isPassword;
  final bool centerText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function()? onTap;

  FormInput({
    Key? key,
    this.controller,
    this.hintText = "",
    this.initialValue,
    this.radius = 8,
    this.maxLines = 1,
    this.contentPadding,
    this.inputType = TextInputType.text,
    this.inputAction,
    this.readOnly = false,
    this.isDense = false,
    this.isPassword = false,
    this.centerText = false,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
  }) : super(key: key) {
    if (isDense) {
      contentPadding = const EdgeInsets.all(6.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: inputAction,
      inputFormatters: inputFormatters,
      textAlign: centerText ? TextAlign.center : TextAlign.start,
      keyboardType: inputType,
      obscureText: isPassword,
      maxLines: maxLines,
      readOnly: readOnly,
      initialValue: initialValue,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        isDense: isDense,
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
      onTap: onTap,
    );
  }
}
