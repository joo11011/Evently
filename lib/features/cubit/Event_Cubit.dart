import 'package:evently/data/model/category.dart';
import 'package:evently/data/model/event.dart';
import 'package:evently/data/web_services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventState {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final int tabIndex;
  DateTime? selectedDateTime;
  final TimeOfDay? selectedTime;
  final bool isLoading;
  final String location;
  final double? latitude;
  final double? longitude;
  final String? errorMessage;

  EventState({
    required this.titleController,
    required this.descriptionController,
    this.tabIndex = 0,
    this.selectedDateTime,
    this.selectedTime,
    this.isLoading = false,
    this.location = '',
    this.latitude,
    this.longitude,
    this.errorMessage,
  });

  EventState copyWith({
    TextEditingController? titleController,
    TextEditingController? descriptionController,
    int? tabIndex,
    DateTime? selectedDateTime,
    TimeOfDay? selectedTime,
    bool? isLoading,
    String? location,
    double? latitude,
    double? longitude,
    String? errorMessage,
  }) {
    return EventState(
      titleController: titleController ?? this.titleController,
      descriptionController:
          descriptionController ?? this.descriptionController,
      tabIndex: tabIndex ?? this.tabIndex,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      selectedTime: selectedTime ?? this.selectedTime,
      isLoading: isLoading ?? this.isLoading,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class EventCubit extends Cubit<EventState> {
  EventCubit()
    : super(
        EventState(
          titleController: TextEditingController(),
          descriptionController: TextEditingController(),
        ),
      );

  void onTapChange(int index) {
    emit(state.copyWith(tabIndex: index));
  }

  void onDateTimeChange(DateTime datetime) {
    emit(state.copyWith(selectedDateTime: datetime));
  }

  void onTimeChange(TimeOfDay time) {
    emit(state.copyWith(selectedTime: time));
  }

  Future<void> addEvent(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      Event eventModel = Event(
        id: 'id',
        userId: FirebaseAuth.instance.currentUser!.uid,
        categoryId: Category.cats[state.tabIndex].id,
        title: state.titleController.text,
        desc: state.descriptionController.text,
        date: state.selectedDateTime.toString(),
        time: state.selectedTime!.format(context),
        image: Category.cats[state.tabIndex].image,
        latitude: state.latitude,
        longitude: state.longitude,
      );
      await EventService.addEvent(eventModel);
      emit(state.copyWith(isLoading: false));
      Navigator.pop(context);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await EventService.deleteEvent(id);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void setEvent(Event event) {
    var index = Category.cats.indexWhere(
      (category) => category.id == event.categoryId,
    );
    DateTime? parsedDate;
    if (event.date != null && event.date!.isNotEmpty) {
      parsedDate = DateTime.tryParse(event.date!);
    }

    TimeOfDay? parsedTime;
    if (event.time != null && event.time!.isNotEmpty) {
      final timeParts = event.time!.split(':');
      if (timeParts.length >= 2) {
        parsedTime = TimeOfDay(
          hour: int.tryParse(timeParts[0]) ?? 0,
          minute: int.tryParse(timeParts[1]) ?? 0,
        );
      }
    }

    emit(
      state.copyWith(
        tabIndex: index != -1 ? index : state.tabIndex,
        selectedDateTime: parsedDate,
        selectedTime: parsedTime,
      ),
    );

    state.titleController.text = event.title ?? '';
    state.descriptionController.text = event.desc ?? '';
  }

  Future<void> updateEvent(Event event) async {
    try {
      emit(state.copyWith(isLoading: true));

      event.title = state.titleController.text;
      event.desc = state.descriptionController.text;

      if (state.selectedDateTime != null) {
        event.date = DateTime(
          state.selectedDateTime!.year,
          state.selectedDateTime!.month,
          state.selectedDateTime!.day,
          state.selectedTime?.hour ?? 0,
          state.selectedTime?.minute ?? 0,
        ).toString();
      }

      await EventService.editEvent(event);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // Change Location for map
  Future<void> changeLocation(LatLng? position) async {
    if (position == null) return;
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placeMarks.isNotEmpty) {
        var first = placeMarks.first;
        String locationString = '${first.country}, ${first.name}';
        emit(
          state.copyWith(
            location: locationString,
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void resetState() {
    state.titleController.clear();
    state.descriptionController.clear();
    emit(
      EventState(
        titleController: state.titleController,
        descriptionController: state.descriptionController,
      ),
    );
  }

  @override
  Future<void> close() {
    state.titleController.dispose();
    state.descriptionController.dispose();
    return super.close();
  }
}
