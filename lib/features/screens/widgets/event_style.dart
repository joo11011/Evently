import 'dart:ui';

import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/data/model/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventStyle extends StatelessWidget {
  final Event event;
  final Function() onTap;
  const EventStyle({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Hero(
                tag: 'event_image_${event.id}',
                child: Image.asset(event.image ?? '', fit: BoxFit.cover),
              ),

              // Gradient overlay from bottom
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.65),
                    ],
                    stops: const [0.3, 0.55, 1.0],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date badge — glassmorphism
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                DateFormat(
                                  'd',
                                ).format(DateTime.parse(event.date ?? '')),
                                style: context.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'MMM',
                                ).format(DateTime.parse(event.date ?? '')),
                                style: context.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Title bar — glassmorphism
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.white.withOpacity(0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.title ?? '',
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: onTap,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: event.isFavorite ?? false
                                      ? Icon(
                                          Icons.favorite,
                                          key: const ValueKey('fav_filled'),
                                          size: 28,
                                          color: Colors.redAccent,
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                          key: const ValueKey('fav_outline'),
                                          size: 28,
                                          color: AppColors.white,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                event.usersFav?.length.toString() ?? '0',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
