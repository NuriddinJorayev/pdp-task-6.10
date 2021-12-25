import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> SetImage(File imageFile) async {
    String image_name = "image_" + DateTime.now().toString();
    Reference ref =
        await FirebaseStorage.instance.ref().child("images").child(image_name);
    UploadTask upload = ref.putFile(imageFile);
    TaskSnapshot sanp = await upload.whenComplete(() => () {});
    String url = await sanp.ref.getDownloadURL();
    return url;
  }
}
