import 'package:evently/data/model/event.dart';
import 'package:evently/data/web_services/layout_service.dart';
import 'package:evently/features/screens/Layout/Tabs/home_screen.dart';
import 'package:evently/features/screens/Layout/Tabs/love_screen.dart';
import 'package:evently/features/screens/Layout/Tabs/map_screen.dart';
import 'package:evently/features/screens/Layout/Tabs/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutState {
  final int navIndex;
  final int tabIndex;

  LayoutState({this.navIndex = 0, this.tabIndex = 0});

  LayoutState copyWith({int? navIndex, int? tabIndex}) {
    return LayoutState(
      navIndex: navIndex ?? this.navIndex,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutState());

  List<Widget> screens = [
    const HomeScreen(),
    const MapScreen(),
    const SizedBox(width: 50),
    const LoveScreen(),
    const ProfileScreen(),
  ];

  User? get user => FirebaseAuth.instance.currentUser;

  void onNav(int index) {
    emit(state.copyWith(navIndex: index));
  }

  void onTabChange(int index) {
    emit(state.copyWith(tabIndex: index));
  }

  Future<void> toggleFavorite(Event event) async {
    await LayoutService.toggleEvents(event);
  }
}
