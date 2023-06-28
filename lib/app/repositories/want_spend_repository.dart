import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skarbonka_v2/app/models/want_spend_model.dart';

class WantspendRepository {
  Stream<List<WantspendModel>> getWantSpendStream() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('Error');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('wantspend')
        .snapshots()
        .map((querySnapshotEvent) {
      return querySnapshotEvent.docs.map((doc) {
        return WantspendModel(
          id: doc.id,
          saving: doc['saving'],
          value: doc['value'],
        );
      }).toList();
    });
  }

  Future<void> removeWantspend({required documentID}) {
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

  Future<void> addtWantspend({
    required addEarningsController,
    required addSavingsController,
    var result,
    var earningControllerValue,
    var savingsControllerValue,
  }) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }

    earningControllerValue = int.parse(addEarningsController);
    savingsControllerValue = int.parse(addSavingsController);
    result = earningControllerValue - savingsControllerValue;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('wantspend')
        .add(
      {
        'value': result.toString(),
        'saving': savingsControllerValue.toString(),
      },
    );
  }
}
