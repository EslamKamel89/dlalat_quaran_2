import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
    this.label,
    this.controller,
    this.hint, {
    super.key,
    this.inputType = TextInputType.text,
    this.validator,
    this.showMulitLine = false,
  });
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final bool showMulitLine;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        validator: validator,
        maxLines: showMulitLine ? 20 : null,
        minLines: showMulitLine ? 2 : null,
      ),
    );
  }
}
