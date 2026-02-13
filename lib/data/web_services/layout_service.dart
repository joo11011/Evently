import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/data/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LayoutService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference<Event> getCollectionRef() {
    return firestore
        .collection('events')
        .withConverter(
          fromFirestore: (snapshot, options) {
            return Event.fromjson(snapshot.data()!);
          },
          toFirestore: (event, options) => event.tojson(),
        );
  }

  // get events by category future mean one time data
  static Future<List<QueryDocumentSnapshot<Event>>> getEvents(String id) async {
    var ref = getCollectionRef();
    var result = id == 'All'
        ? await ref.get()
        : await ref.where('categoryId', isEqualTo: id).get();
    return result.docs;
  }

  // get events by category stream , stream mean real time data
  static Stream<QuerySnapshot<Event>> getEventsStream(String id) {
    var ref = getCollectionRef();
    var result = id == 'All'
        ? ref.snapshots()
        : ref.where('categoryId', isEqualTo: id).snapshots();
    return result;
  }

  // get favorite events
  static Future<List<QueryDocumentSnapshot<Event>>> getFavorite() async {
    var ref = getCollectionRef();
    String userid = FirebaseAuth.instance.currentUser!.uid;
    var result = await ref.where('usersFav', arrayContains: userid).get();
    return result.docs;
  }

  // toggle favorite events
  static Future<void> toggleEvents(Event event) async {
    var ref = getCollectionRef();
    String userid = FirebaseAuth.instance.currentUser!.uid;
    if (event.usersFav!.contains(userid)) {
      event.usersFav!.remove(userid);
    } else {
      event.usersFav!.add(userid);
    }
    await ref.doc(event.id).set(event);
  }
}
