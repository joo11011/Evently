import 'package:firebase_auth/firebase_auth.dart';

class Event {
  String? id;
  String? categoryId;
  String? userId;
  String? title;
  String? desc;
  String? date;
  String? time;
  String? image;
  double? latitude;
  double? longitude;
  bool? isFavorite;
  List<String>? usersFav;
  Event({
    required this.id,
    required this.categoryId,
    required this.userId,
    required this.title,
    required this.desc,
    required this.date,
    required this.time,
    required this.image,
    this.latitude,
    this.longitude,
    this.isFavorite = false,
    this.usersFav = const [],
  });
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'userId': userId,
      'title': title,
      'desc': desc,
      'date': date,
      'time': time,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'usersFav': usersFav,
      'isFavorite': isFavorite,
    };
  }

  factory Event.fromjson(Map<String, dynamic> json) {
    String userid = FirebaseAuth.instance.currentUser!.uid;
    bool isFav = false;
    List<String> users = [];
    if (json['usersFav'] != null) {
      json['usersFav'].map((e) {
        users.add(e.toString());
      }).toList();
      isFav = users.contains(userid);
    }
    return Event(
      id: json['id'],
      categoryId: json['categoryId'],
      userId: json['userId'],
      title: json['title'],
      desc: json['desc'],
      date: json['date'],
      time: json['time'],
      image: json['image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      usersFav: users,
      isFavorite: isFav,
    );
  }
}
