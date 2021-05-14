import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(File file, String fileName) async {
    var snapshot = await storage
        .ref()
        .child('productImages/$fileName')
        .putFile(file)
        .whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadVendorImage(File file, String fileName) async {
    var snapshot = await storage
        .ref()
        .child('vendorImages/$fileName')
        .putFile(file)
        .whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }
}
