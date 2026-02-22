import 'package:feild_visit_app/core/utils/snack_bar.dart';
import 'package:feild_visit_app/features/home/screens/home_page.dart';
import 'package:flutter/material.dart';

void validateLogin(
  dynamic usernameController,
  dynamic passwordController,
  BuildContext context,
) {
  if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
    showCustomSnackBar(
      context,
      'All Fields are Required',
      backgroundColor: Colors.red,
    );
    return;
  }
  if (passwordController.text.length < 6) {
    showCustomSnackBar(
      context,
      'Password should more than 6 characters',
      backgroundColor: Colors.red,
    );
    return;
  } else {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false,
    );
    showCustomSnackBar(context, 'Login Success', backgroundColor: Colors.green);
  }
}
