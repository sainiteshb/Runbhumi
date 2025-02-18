import 'package:Runbhumi/models/Events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Runbhumi/services/auth.dart';
//import 'package:Runbhumi/models/Events.dart';

class EventService {
  CollectionReference _eventCollectionReference =
      FirebaseFirestore.instance.collection('events');

  getCurrentFeed() async {
    return FirebaseFirestore.instance
        .collection("events")
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  Future addPlayerToEvent(Events _event, String playerId) async {
    try {
      await _eventCollectionReference
          .doc(_event.eventId)
          .update({"playerId": FieldValue.arrayUnion(_event.playersId)});
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future getEventDetails(String eventId) async {
    try {
      var eventsData = await _eventCollectionReference.doc(eventId).get();
      return Events.fromSnapshot(eventsData);
    } catch (e) {
      return e.message;
    }
  }
}

//id, userId, "", _chosenSport, _chosenPurpose,[userId], DateTime.now()

void createNewEvent(
    String eventName,
    String creatorId,
    String location,
    String sportName,
    String description,
    List<String> playersId,
    DateTime dateTime) {
  var newDoc = FirebaseFirestore.instance.collection('events').doc();
  String id = newDoc.id;
  newDoc.set(Events.newEvent(id, eventName, creatorId, location, sportName,
          description, playersId, dateTime)
      .toJson());
  FirebaseFirestore.instance
      .collection('users')
      .doc(getCurrentUserId())
      .update({
    "eventsId": FieldValue.arrayUnion([id])
  });
}
