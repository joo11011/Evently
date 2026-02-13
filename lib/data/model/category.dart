import 'package:flutter/material.dart';

class Category {
  String? id;
  String? name;
  String? image;
  IconData icon;
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      // TODO: implement ==
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image &&
          icon == other.icon;

  @override
  // TODO: implement hashCode
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ image.hashCode ^ icon.hashCode;

  static List<Category> cats = [
    Category(
      id: 'Birthday',
      name: 'Birthday',
      image: 'assets/images/birthday.png',
      icon: Icons.cake,
    ),
    Category(
      id: 'Book Club',
      name: 'Book Club',
      image: 'assets/images/Book Club.png',
      icon: Icons.auto_stories,
    ),
    Category(
      id: 'Eating',
      name: 'Eating',
      image: 'assets/images/eating.png',
      icon: Icons.restaurant,
    ),
    Category(
      id: 'Exhibition',
      name: 'Exhibition',
      image: 'assets/images/exhibition.png',
      icon: Icons.palette,
    ),
    Category(
      id: 'Gaming',
      name: 'Gaming',
      image: 'assets/images/gaming.png',
      icon: Icons.videogame_asset,
    ),
    Category(
      id: 'Sport',
      name: 'Sport',
      image: 'assets/images/sport.png',
      icon: Icons.directions_bike,
    ),
    Category(
      id: 'Meeting',
      name: 'Meeting',
      image: 'assets/images/meeting.png',
      icon: Icons.people_alt_rounded,
    ),
    Category(
      id: 'Work Shop',
      name: 'Work Shop',
      image: 'assets/images/workshop.png',
      icon: Icons.business_center_sharp,
    ),
    Category(
      id: 'Holiday',
      name: 'Holiday',
      image: 'assets/images/holiday.png',
      icon: Icons.beach_access,
    ),
  ];

  static List<Category> catwithall = [
    Category(
      id: 'All',
      name: 'All',
      image: 'assets/images/birthday.png',
      icon: Icons.all_inclusive,
    ),
    Category(
      id: 'Birthday',
      name: 'Birthday',
      image: 'assets/images/birthday.png',
      icon: Icons.cake,
    ),
    Category(
      id: 'Book Club',
      name: 'Book Club',
      image: 'assets/images/Book Club.png',
      icon: Icons.auto_stories,
    ),
    Category(
      id: 'Eating',
      name: 'Eating',
      image: 'assets/images/eating.png',
      icon: Icons.restaurant,
    ),
    Category(
      id: 'Exhibition',
      name: 'Exhibition',
      image: 'assets/images/exhibition.png',
      icon: Icons.palette,
    ),
    Category(
      id: 'Gaming',
      name: 'Gaming',
      image: 'assets/images/gaming.png',
      icon: Icons.videogame_asset,
    ),
    Category(
      id: 'Sport',
      name: 'Sport',
      image: 'assets/images/sport.png',
      icon: Icons.directions_bike,
    ),
    Category(
      id: 'Meeting',
      name: 'Meeting',
      image: 'assets/images/meeting.png',
      icon: Icons.people_alt_rounded,
    ),
    Category(
      id: 'Work Shop',
      name: 'Work Shop',
      image: 'assets/images/workshop.png',
      icon: Icons.business_center_sharp,
    ),
    Category(
      id: 'Holiday',
      name: 'Holiday',
      image: 'assets/images/holiday.png',
      icon: Icons.beach_access,
    ),
  ];
}
