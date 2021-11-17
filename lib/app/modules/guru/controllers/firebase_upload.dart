import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, Uint8List file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}
