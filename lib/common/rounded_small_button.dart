import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class RoundedSmallButton extends StatelessWidget {
  const RoundedSmallButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.textColor = Pallete.backgroundColor,
    this.backgroundColor = Pallete.whiteColor,
  });

  final String buttonText;
  final VoidCallback onTap;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        backgroundColor: backgroundColor,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
      ),
    );
  }
}
