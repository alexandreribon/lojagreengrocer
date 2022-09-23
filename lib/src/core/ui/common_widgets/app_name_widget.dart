import 'package:flutter/material.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';

class AppNameWidget extends StatelessWidget {
  final Color? greenTitleColor;
  final double textTitleSize;

  const AppNameWidget({
    Key? key,
    this.greenTitleColor,
    this.textTitleSize = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: textTitleSize),
        children: [
          TextSpan(
            text: 'Green',
            style: TextStyle(
              color: greenTitleColor ?? CustomColors.customSwatchColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'grocer',
            style: TextStyle(
              color: CustomColors.customContrastColor,
            ),
          ),
        ],
      ),
    );
  }
}
