import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Fuel {
    final String uid;
    final String userUid;
    final String vehicleUid;
    final String vehicleName;
    final String vehicleId;
    final String fuelBrand;
    final int timestamp;
    final double amount;
    final bool isHaveReceiptPhoto;

    Fuel({required this.uid, required this.userUid, required this.vehicleUid, required this.vehicleName, required this.vehicleId,required this.fuelBrand, required this.timestamp, required this.amount, required this.isHaveReceiptPhoto});

    Map<String, dynamic> toFirestore() {
      return {
        "uid": uid,
        "userUid": userUid,
        "vehicleUid": vehicleUid,
        "vehicleName": vehicleName,
        "vehicleId": vehicleId,
        "fuelBrand": fuelBrand,
        "timestamp": timestamp,
        "amount": amount,
        "isHaveReceiptPhoto": isHaveReceiptPhoto
      };
    }

    factory Fuel.fromFirestore(DocumentSnapshot<Map<String,dynamic>> snapshot, SnapshotOptions? options) {
      final data = snapshot.data();
      return Fuel(
        uid: data?["uid"], 
        userUid: data?["userUid"],
        vehicleUid: data?["vehicleUid"], 
        vehicleName: data?["vehicleName"], 
        vehicleId: data?["vehicleId"], 
        fuelBrand: data?["fuelBrand"], 
        timestamp: data?["timestamp"], 
        amount: data?["amount"], 
        isHaveReceiptPhoto: data?["isHaveReceiptPhoto"]);
    }

     Future<String> getImageUrl() async {
      final storageRef = FirebaseStorage.instance.ref();
      final recipePhotoRef = storageRef.child("$uid.jpg");
      return await recipePhotoRef.getDownloadURL();

    }

}