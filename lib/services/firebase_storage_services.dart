
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageServices {

  final _storage = FirebaseStorage.instance;

  Future<bool> uploadReceiptImage(String uid, File photo) async {
    final recipePhotoRef = _storage.ref().child("$uid.jpg");
    try {
      await recipePhotoRef.putFile(photo);
      return true;
    } catch (e){
      return Future.error(e);
    }
    

  }


  Future<bool> deleteReceiptImage(String uid) async {
    final recipePhotoRef = _storage.ref().child("$uid.jpg");
     try {
      await recipePhotoRef.delete();
      return true;
    } catch (e){
      return Future.error(e);
    }

  }
}