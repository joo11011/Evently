import 'package:evently/core/Extension.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/data/model/category.dart';
import 'package:evently/data/web_services/layout_service.dart';
import 'package:evently/features/cubit/Layout_Cubit.dart';
import 'package:evently/features/screens/widgets/event_style.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          final layoutCubit = context.read<LayoutCubit>();
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.purple, AppColors.navyBlue],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.welcomeBack,
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          layoutCubit.user!.displayName!.toUpperCase(),
                          style: context.textTheme.titleLarge!.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon:
                              context.appCubit.state.themeMode ==
                                  ThemeMode.light
                              ? Image.asset(
                                  'assets/icons/light.png',
                                  width: 30,
                                  height: 30,
                                )
                              : Image.asset(
                                  'assets/icons/dark.png',
                                  width: 30,
                                  height: 30,
                                  color: AppColors.white,
                                ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              context.appCubit.state.locale.languageCode
                                  .toUpperCase(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.white),
                        SizedBox(width: 3),
                        Text(
                          context.locale.cairoEgypt,
                          style: context.textTheme.titleLarge!.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    DefaultTabController(
                      length: Category.catwithall.length,
                      child: TabBar(
                        onTap: layoutCubit.onTabChange,
                        labelPadding: EdgeInsets.all(6),
                        indicatorColor: Colors.transparent,
                        dividerColor: Colors.transparent,
                        labelStyle: context.textTheme.labelMedium,
                        unselectedLabelStyle: context.textTheme.labelLarge,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,

                        tabs: Category.catwithall.map((t) {
                          int i = Category.catwithall.indexOf(t);
                          bool isSelected = i == layoutCubit.state.tabIndex;
                          return Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    t.icon,
                                    color: isSelected
                                        ? AppColors.purple
                                        : AppColors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    context.locale.translateCategory(t.id),
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.purple
                                          : AppColors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: LayoutService.getEventsStream(
                    Category.catwithall[layoutCubit.state.tabIndex].id ?? '',
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.hasData) {
                      var events = snapshot.data?.docs ?? [];
                      return Padding(
                        padding: EdgeInsets.all(16.0),
                        child: RefreshIndicator(
                          color: AppColors.purple,
                          onRefresh: () async {
                            await Future.delayed(Duration(milliseconds: 500));
                          },
                          child: ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              var event = events[index].data();
                              return FadeInUp(
                                duration: Duration(milliseconds: 400),
                                delay: Duration(milliseconds: 80 * index),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppStrings.eventDetails,
                                      arguments: event,
                                    );
                                  },
                                  child: EventStyle(
                                    event: event,
                                    onTap: () {
                                      final wasFav = event.isFavorite ?? false;
                                      layoutCubit.toggleFavorite(event);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).clearSnackBars();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                wasFav
                                                    ? Icons.heart_broken
                                                    : Icons.favorite,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                wasFav
                                                    ? context
                                                          .locale
                                                          .removedFromFavorites
                                                    : context
                                                          .locale
                                                          .addedToFavorites,
                                              ),
                                            ],
                                          ),
                                          backgroundColor: AppColors.purple,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
