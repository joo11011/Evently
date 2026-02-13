import 'package:evently/core/Extension.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Cupertinobtn extends StatelessWidget {
  final String BTNName;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isExpanded;
  const Cupertinobtn({
    super.key,
    required this.BTNName,
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
                    BTNName,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : Text(
                  BTNName,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          secondChild: CupertinoActivityIndicator(
            color: Colors.white,
            radius: 15,
          ),
          crossFadeState: isLoading
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
