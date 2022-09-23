import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/core/config/custom_colors.dart';
import 'package:greengrocer/src/core/ui/common_widgets/app_name_widget.dart';
import 'package:greengrocer/src/modules/splash/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CustomColors.customSwatchColor,
              CustomColors.customSwatchColor.shade400,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            AppNameWidget(
              greenTitleColor: Colors.white,
              textTitleSize: 40,
            ),
            SizedBox(
              height: 15,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
