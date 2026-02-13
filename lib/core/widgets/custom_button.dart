import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/Extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CupertinoCustomButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isExpanded;

  const CupertinoCustomButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.isLoading = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoButton(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(16),
        onPressed: () {
          onPressed();
        },
        child: AnimatedCrossFade(
          firstChild: isExpanded
              ? Center(
                  child: Text(
                    buttonName,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : Text(
                  buttonName,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          secondChild: const CupertinoActivityIndicator(
            color: Colors.white,
            radius: 15,
          ),
          crossFadeState: isLoading
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}

// Elevated Button
class ElevatedCustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isBlueColor;

  const ElevatedCustomButton({
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
        minimumSize: WidgetStateProperty.all(const Size(361, 57.67)),
        backgroundColor: isBlueColor
            ? WidgetStateProperty.all(AppColors.purple)
            : WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.purple),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
