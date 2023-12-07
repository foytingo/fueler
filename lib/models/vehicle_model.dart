
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


enum VehicleType {
  car, motorcycle, truck, agriculture
}

extension VehicleTypeName on VehicleType {
  String get typeName {
    switch (this) {
      case VehicleType.car:
      return "Car";
      case VehicleType.motorcycle:
      return "Motorcycle";
      case VehicleType.truck:
      return "Truck";
      case VehicleType.agriculture:
      return "Agriculture";

    }
  }

  String getTypeNameLocal(AppLocalizations language) {
    switch (this) {
      case VehicleType.car:
      return language.car;
      case VehicleType.motorcycle:
      return language.motorcycle;
      case VehicleType.truck:
      return language.truck;
      case VehicleType.agriculture:
      return language.agriculture;
    }
  }
}

extension VehicleTypes on String {
  VehicleType get type {
    switch (this) {
      case "Car":
      return VehicleType.car;
      case "Motorcycle":
      return VehicleType.motorcycle;
      case "Truck":
      return VehicleType.truck;
      case "Agriculture":
      return VehicleType.agriculture;
    }
    return VehicleType.car;

  }
}

extension VehicleTypeIcon on VehicleType {
  IconData get icon {
    switch (this) {
      case VehicleType.car:
      return Icons.directions_car;
      case VehicleType.motorcycle:
      return Icons.motorcycle;
      case VehicleType.truck:
      return Icons.local_shipping;
      case VehicleType.agriculture:
      return Icons.agriculture;

    }
  }
}


class VehicleModel{
  final String uid;
  final String userUid;
  final VehicleType type;
  final String name;
  final String id;
  final String fuelBrand;
  
  VehicleModel({required this.uid, required this.userUid, required this.name, required this.type, required this.id, required this.fuelBrand});

  factory VehicleModel.fromFirestore(DocumentSnapshot<Map<String,dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;
    
    return VehicleModel(
      uid: data["uid"], 
      userUid: data["userUid"],
      name: data["name"],
      type: data["type"].toString().type,
      id: data["id"],
      fuelBrand: data["fuelBrand"],
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "userUid": userUid,
      "type": type.typeName,
      "name": name,
      "id": id,
      "fuelBrand": fuelBrand,
    };
  }

  
}