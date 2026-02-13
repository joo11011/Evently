import 'package:evently/features/cubit/Event_Cubit.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/data/model/category.dart';
import 'package:evently/data/model/event.dart';
import 'package:evently/core/widgets/custom_button.dart';
import 'package:evently/features/widget/elevated_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

class EditEventScreen extends StatelessWidget {
  Event event;
  EditEventScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit()..setEvent(event),
      child: BlocConsumer<EventCubit, EventState>(
        listener: (context, state) {},
        builder: (context, state) {
          final eventcubit = context.read<EventCubit>();
          return Scaffold(
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(15),
              child: Elevatedbtn(
                onPressed: () async {
                  if (eventcubit.state.titleController.text.isEmpty ||
                      eventcubit.state.descriptionController.text.isEmpty ||
                      eventcubit.state.selectedDateTime == null ||
                      eventcubit.state.selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.locale.pleaseFillAllFields),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  await eventcubit.updateEvent(event);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppStrings.layout,
                    (context) => false,
                  );
                },
                isBlueColor: true,
                child: Text(
                  context.locale.editEventButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            appBar: AppBar(title: Text(context.locale.updateEvent)),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: Image.asset(
                        Category.cats[eventcubit.state.tabIndex].image ?? " ",
                        fit: BoxFit.fill,
                        excludeFromSemantics: true,
                        gaplessPlayback: true,
                      ),
                    ),
                    SizedBox(height: 15),
                    DefaultTabController(
                      length: Category.cats.length,
                      child: TabBar(
                        onTap: eventcubit.onTapChange,
                        labelPadding: EdgeInsets.all(5),
                        isScrollable: true,
                        indicator: BoxDecoration(),
                        dividerColor: Colors.transparent,
                        dividerHeight: 0,
                        labelStyle: context.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: context.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                        tabAlignment: TabAlignment.start,

                        tabs: Category.cats.map((e) {
                          int i = Category.cats.indexOf(e);
                          bool isSelected = i == eventcubit.state.tabIndex;
                          return Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.purple
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: AppColors.purple),
                              ),
                              child: Row(
                                children: [
                                  Icon(e.icon),
                                  SizedBox(width: 6),
                                  Text(
                                    context.locale.translateCategory(e.id),
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      context.locale.title,
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 7),
                    TextFormField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                      controller: eventcubit.state.titleController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.edit),
                        hintText: context.locale.eventTitle,
                        hintStyle: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      context.locale.description,
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 7),
                    SizedBox(
                      height: 130,
                      child: TextFormField(
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        controller: eventcubit.state.descriptionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: context.locale.eventDescription,
                          hintStyle: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.date_range),
                        SizedBox(width: 5),
                        Text(
                          context.locale.eventDate,
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 90)),
                            ).then((value) {
                              eventcubit.onDateTimeChange(
                                value ?? DateTime.now(),
                              );
                            });
                          },
                          child: Text(
                            eventcubit.state.selectedDateTime == null
                                ? context.locale.chooseDate
                                : DateFormat(
                                    'y / M / d',
                                  ).format(eventcubit.state.selectedDateTime!),
                            style: context.textTheme.labelMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined),
                        SizedBox(width: 5),
                        Text(
                          context.locale.eventTime,
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              eventcubit.onTimeChange(value ?? TimeOfDay.now());
                            });
                          },
                          child: Text(
                            eventcubit.state.selectedTime == null
                                ? context.locale.chooseTime
                                : eventcubit.state.selectedTime!.format(
                                    context,
                                  ),
                            style: context.textTheme.labelMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
