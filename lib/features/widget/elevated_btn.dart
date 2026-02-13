import 'package:evently/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Elevatedbtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isBlueColor;
  const Elevatedbtn({
    super.key,
    required this.child,
    required this.onPressed,
    this.isBlueColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        elevation: WidgetStateProperty.all(0),
        minimumSize: WidgetStateProperty.all(Size(361, 57.67)),
        backgroundColor: isBlueColor
            ? WidgetStateProperty.all(AppColors.purple)
            : WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.purple),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
