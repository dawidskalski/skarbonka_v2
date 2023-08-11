import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skarbonka_v2/app/models/reminder_model.dart';

class ReminderRepository {
  Stream<List<ReminderModel>> getReminderStream() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('User is not logged in ');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('reminder')
        .snapshots()
        .map((querySnapshotDocuments) {
      return querySnapshotDocuments.docs.map((document) {
        return ReminderModel(
          id: document.id,
          title: document['title'],
          note: document['note'],
          date: (document['date'] as Timestamp).toDate(),
          time: document['time'],
          color: document['color'],
          whenToRemind: document['whenToRemind'],
        );
      }).toList();
    });
  }

  Future<void> addReminder({
    required String title,
    required String note,
    required DateTime date,
    required String time,
    required String color,
    required String whenToRemind,
  }) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('Error');
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('reminder')
        .add({
      'title': title,
      'note': note,
      'date': date,
      'time': time,
      'color': color,
      'whenToRemind': whenToRemind
    });
  }

  Future<void> removeReminder({required documentID}) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('Problem with deletion');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('reminder')
        .doc(documentID)
        .delete();
  }
}
