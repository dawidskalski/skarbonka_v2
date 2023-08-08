import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileImageRepository {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference child = storageRef.child(childName);
    UploadTask uploadTask = child.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveProfileImage(
      {String name = '', required Uint8List file}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      final String imageUrl = await uploadImageToStorage(name, file);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profile')
          .add(
        {
          'name': name,
          'image_URL': imageUrl,
        },
      );
    } catch (error) {
      print(
        error.toString(),
      );
    }
  }
}
