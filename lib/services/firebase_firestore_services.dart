
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:fueler_new/models/fuel_model.dart';
import 'package:fueler_new/models/fueler_user_model.dart';
import 'package:fueler_new/models/vehicle_model.dart';
import 'package:intl/intl.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:mailer/mailer.dart';
import 'package:flutter_archive/flutter_archive.dart';

class FirebaseFirestoreServices {

  final _firestore = FirebaseFirestore.instance;

  Future<FuelerUser?> getUserDataWithUid(String userUid) async {
    final ref = _firestore.collection("users").doc(userUid).withConverter(fromFirestore: FuelerUser.fromFirestore, toFirestore: (FuelerUser user, _)=> user.toFirestore());
    final snapshot = await ref.get();
    final user = snapshot.data();
    if(user!=null) {
      return user;
    } 
    return null;

  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    final vehiclesRef = FirebaseFirestore.instance.collection("vehicles").doc(vehicle.userUid);

    Map<String,dynamic> vehicleMap = vehicle.toFirestore();
    await vehiclesRef.update({"vehicles": FieldValue.arrayUnion([vehicleMap])});

  }

  Future<void> deleteVehicle(VehicleModel vehicle) async {
    final vehiclesRef = FirebaseFirestore.instance.collection("vehicles").doc(vehicle.userUid);

    Map<String,dynamic> vehicleMap = vehicle.toFirestore();
    await vehiclesRef.update({"vehicles": FieldValue.arrayRemove([vehicleMap])});

  }

  Future<List<Fuel>?> getFuelsByVehicle(VehicleModel vehicle) async {

      final fuelsRef = FirebaseFirestore.instance.collection("fuels").doc(vehicle.userUid);
      final snapshot = await fuelsRef.get();  
      final data = snapshot.data();
      if(data!=null) {
        final fuelsMapList = data["fuels"] as List;
        final filteredFuelsMapList = fuelsMapList.where((element) => element["vehicleUid"] == vehicle.uid).toList();
        final fuels = filteredFuelsMapList.map((fuel) {
          return Fuel(
            uid: fuel["uid"], 
            userUid: fuel["userUid"], 
            vehicleUid: fuel["vehicleUid"], 
            vehicleName: fuel["vehicleName"], 
            vehicleId: fuel["vehicleId"], 
            fuelBrand: fuel["fuelBrand"], 
            timestamp: fuel["timestamp"], 
            amount: fuel["amount"], 
            isHaveReceiptPhoto: fuel["isHaveReceiptPhoto"]);
        },).toList(); 

        return fuels;

      }

      return null;

    
  }



  Future<List<VehicleModel>?> getVehicles(String userUid) async {
    final vehiclesRef = FirebaseFirestore.instance.collection("vehicles").doc(userUid);
    final snapshot = await vehiclesRef.get();
    final data = snapshot.data();
    if(data!=null) {
      final vehiclesMapList = data["vehicles"] as List;
      final vehicles = vehiclesMapList.map((vehicle) {
          return VehicleModel(
            uid: vehicle["uid"], 
            userUid: vehicle["userUid"], 
            name: vehicle["name"], 
            type: vehicle["type"].toString().type, 
            id: vehicle["id"], 
            fuelBrand: vehicle["fuelBrand"]);
        },).toList();

      return vehicles;
    }
   return null;

  }

  Future<void> addFuel(Fuel fuel) async {
    final fuelsRef = FirebaseFirestore.instance.collection("fuels").doc(fuel.userUid); 
    Map<String,dynamic> fuelMap = fuel.toFirestore();
    await fuelsRef.update({"fuels": FieldValue.arrayUnion([fuelMap])});
  }

  Future<void> deleteFuel(Fuel fuel) async {
    final fuelsRef = FirebaseFirestore.instance.collection("fuels").doc(fuel.userUid); 
    Map<String,dynamic> fuelMap = fuel.toFirestore();
    await fuelsRef.update({"fuels": FieldValue.arrayRemove([fuelMap])});
  }

  Future<void> deleteFuels(List<Fuel> fuels, String userUid) async {
    final fuelsRef = FirebaseFirestore.instance.collection("fuels").doc(userUid);
    List<Map<String,dynamic>> fuelsMap = fuels.map((e) => e.toFirestore()).toList();
    await fuelsRef.update({"fuels": FieldValue.arrayRemove(fuelsMap)});
  }

  Future<List<Fuel>?> getFuels(String userUid) async {
    final fuelsRef = FirebaseFirestore.instance.collection("fuels").doc(userUid);
    final snapshot = await fuelsRef.get();   
    final data = snapshot.data();
     if(data!=null) {
      final fuelsMapList = data["fuels"] as List;
      final fuels = fuelsMapList.map((fuel) {
          return Fuel(
            uid: fuel["uid"], 
            userUid: fuel["userUid"], 
            vehicleUid: fuel["vehicleUid"], 
            vehicleName: fuel["vehicleName"], 
            vehicleId: fuel["vehicleId"], 
            fuelBrand: fuel["fuelBrand"], 
            timestamp: fuel["timestamp"], 
            amount: fuel["amount"], 
            isHaveReceiptPhoto: fuel["isHaveReceiptPhoto"]);
        },).toList();

      return fuels;
    }
   return null;

  }

   Future<List<Fuel>?> getFuelsByNameOrId(String userUid,String query) async {

      final fuelsRef = FirebaseFirestore.instance.collection("fuels").doc(userUid);
      final snapshot = await fuelsRef.get();  
      final data = snapshot.data();
      if(data!=null) {
        final fuelsMapList = data["fuels"] as List;
        final filteredFuelsMapList = fuelsMapList.where((element) => element["vehicleName"].toString().toLowerCase() == query.toLowerCase() || element["vehicleid"].toString().toLowerCase() == query.toLowerCase()).toList();
        final fuels = filteredFuelsMapList.map((fuel) {
          return Fuel(
            uid: fuel["uid"], 
            userUid: fuel["userUid"], 
            vehicleUid: fuel["vehicleUid"], 
            vehicleName: fuel["vehicleName"], 
            vehicleId: fuel["vehicleId"], 
            fuelBrand: fuel["fuelBrand"], 
            timestamp: fuel["timestamp"], 
            amount: fuel["amount"], 
            isHaveReceiptPhoto: fuel["isHaveReceiptPhoto"]);
        },).toList(); 

        return fuels;

      }

      return null;

    
  }


  Future<void> deleteAccount(String userUid) async {
    await FirebaseAuth.instance.currentUser!.delete();
    await FirebaseFirestore.instance.collection("vehicles").doc(userUid).delete();
    await FirebaseFirestore.instance.collection("fuels").doc(userUid).delete();
    await FirebaseFirestore.instance.collection("users").doc(userUid).delete();
  }

   Future<void> deleteData(String userUid) async {
    await FirebaseFirestore.instance.collection("vehicles").doc(userUid).update({"vehicles": []});
    await FirebaseFirestore.instance.collection("fuels").doc(userUid).update({"fuels": []});
  }


  Future<bool?> generateExportDataEmail(String userUid, String email ) async {
    var listForCsv = [["Date","Fuel Amount","Fuel Brand","Vehicle Name","Vehicle Id", "Receipt Photo Name"]];
    List<String> photoNames = [];

    try { 
      var fuelList = await getFuels(userUid);
      if(fuelList !=null && fuelList.isNotEmpty) {
        for(var fuel in fuelList) {
          var date =  DateTime.fromMillisecondsSinceEpoch(fuel.timestamp);
          final DateFormat formatter = DateFormat('dd MMMM yyyy');
          final String formatted = formatter.format(date);
          var newItem = [formatted, fuel.amount.toString(), fuel.fuelBrand, fuel.vehicleName, fuel.vehicleId, fuel.isHaveReceiptPhoto ? "${fuel.uid}.jpg" : "null"];
          if (fuel.isHaveReceiptPhoto) {
            photoNames.add(fuel.uid);
          }

          listForCsv.add(newItem);
        }
      }

      var dir = await path_provider.getTemporaryDirectory();
      var downlaodedImage = 0;
      if(photoNames.isNotEmpty){
          for(var photoName in photoNames) {
            final photoRef = FirebaseStorage.instance.ref().child("$photoName.jpg");
            final imageFilePath = "${dir.path}/receiptPhotos/$photoName.jpg";
            final file = File(imageFilePath);
            await photoRef.writeToFile(file);
            downlaodedImage++;
          }
          
          if(downlaodedImage == photoNames.length) {
            final dataDir = Directory("${dir.path}/receiptPhotos");
            final zipFile = File("${dir.path}/receiptPhotos.zip");
            await ZipFile.createFromDirectory(sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
            final csvFilePath = "${dir.path}/exportedData.csv";
            var csvFile = File(csvFilePath);
            String csv = const ListToCsvConverter().convert(listForCsv);
            await csvFile.writeAsString(csv);
            var smtpServer = SmtpServer("mail.baykor.dev", ssl: true, port: 465, username: "fueler@baykor.dev",password: ";l@hM6%kAtvO" );
            final message = Message()
              ..from = const Address("fueler@baykor.dev", 'Fueler app')
              ..recipients.add(email)
              ..subject = 'Your data from Fueler App'
              ..text = 'Your data and recipt photos are in the attachments.'
              ..attachments = [FileAttachment(csvFile), FileAttachment(zipFile)];
              await send(message, smtpServer).whenComplete(() {
                  dataDir.deleteSync(recursive: true);
                  csvFile.delete();
                  zipFile.delete();

              });
              return true;
          }

      }

    } catch (error) {
      rethrow;
    }
    
    return null;

  }


  
  

}