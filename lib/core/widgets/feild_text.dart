import 'package:flutter/material.dart';

Widget FeildTextWidget(String fieldName) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      fieldName,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
