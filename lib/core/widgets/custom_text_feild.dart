import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  bool isPassword = false,
  String? Function(String?)? validator,
  int? maxLines = 1,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: TextFormField(
      validator: validator,
      controller: controller,
      obscureText: isPassword,
      maxLines: maxLines! > 0 ? maxLines : 1,

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: InputBorder.none,
      ),
    ),
  );
}
