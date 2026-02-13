import 'package:evently/features/cubit/Layout_Cubit.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/core/Extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          final layoutCubit = BlocProvider.of<LayoutCubit>(context);
          return Scaffold(
            body: layoutCubit.screens[layoutCubit.state.navIndex],
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.purple, AppColors.navyBlue],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple.withOpacity(0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  heroTag: 'layout_fab',
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {
                    Navigator.pushNamed(context, AppStrings.addEvent);
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                if (index == 2) return;
                layoutCubit.onNav(index);
              },
              currentIndex: layoutCubit.state.navIndex,
              type: BottomNavigationBarType.fixed,
              iconSize: 30,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(Icons.home, color: AppColors.purple),
                  label: context.locale.home,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  activeIcon: Icon(Icons.location_on, color: AppColors.purple),
                  label: context.locale.location,
                ),
                BottomNavigationBarItem(icon: SizedBox(width: 50), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline_rounded),
                  activeIcon: Icon(
                    Icons.favorite_rounded,
                    color: AppColors.purple,
                  ),
                  label: context.locale.favorites,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined),
                  activeIcon: Icon(Icons.person_2, color: AppColors.purple),
                  label: context.locale.profile,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
