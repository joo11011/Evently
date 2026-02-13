import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/data/model/event.dart';

class EventService {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference<Event> getCollectionRef() {
    return firebaseFirestore
        .collection('events')
        .withConverter(
          fromFirestore: (snapshot, options) {
            return Event.fromjson(snapshot.data()!);
          },
          toFirestore: (event, options) => event.tojson(),
        );
  }

  static Future<void> addEvent(Event event) async {
    var ref = getCollectionRef();
    var doc = ref.doc();
    event.id = doc.id;
    doc.set(event);
  }

  static Future<void> deleteEvent(String id) async {
    var ref = getCollectionRef();
    var doc = ref.doc(id);
    await doc.delete();
  }

  static Future<void> editEvent(Event event) async {
    var ref = getCollectionRef();
    var doc = ref.doc(event.id);
    await doc.update(event.tojson());
  }
}
