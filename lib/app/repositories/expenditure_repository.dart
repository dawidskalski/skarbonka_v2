import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skarbonka_v2/app/models/expenditure_model.dart';

class ExpenditureRepository {
  Stream<List<ExpenditureModel>> getExpenditureStream() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('Error');
    }

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('expenditure')
        .snapshots()
        .map((querySnapshotEvent) {
      return querySnapshotEvent.docs.map((doc) {
        return ExpenditureModel(
          id: doc.id,
          name: doc['name'],
        );
      }).toList();
    });
  }

  Future<void> removeExpenditure({required String documentID}) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('Error');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('expenditure')
        .doc(documentID)
        .delete();
  }
}
