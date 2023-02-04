import 'package:flutter/material.dart';

void showSnackBar(
  String message,
  BuildContext context,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}


/// If we get keval@123.com
/// Then it will return keval
String getNameFromEmailId({required String emailId}) {
  return emailId.split('@').first;
}
