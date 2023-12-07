import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/models/vehicle_model.dart';
import 'package:fueler_new/screens/drawer/vehicle/add_vehicle_screen.dart';
import 'package:fueler_new/screens/drawer/vehicle/vehicle_details.dart';
import 'package:fueler_new/views/vehicle_cell_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(language.myVehicle),
        actions: [
          IconButton(onPressed: () async {
            var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddVehicleScreen(isItFirstVehicle: false),fullscreenDialog: true));
            if(result==null) return;
            if(result) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language.vehicleAddWithSuccess)));
                }
              
            } else if(!result) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language.vehicleAddWithSuccess)));
                }
            }
          }, icon: const Icon(Icons.add))
         
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("vehicles").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasError) return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));
          if(snapshot.connectionState == ConnectionState.waiting) return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));
          if(snapshot.hasData) {
            var data = snapshot.data!.data()!;
            if(data.isNotEmpty) {
              final vehiclesMapList = data["vehicles"] as List;
              if(vehiclesMapList.isNotEmpty) {
                final vehicles = vehiclesMapList.map((vehicle) {
                  return VehicleModel(
                    uid: vehicle["uid"], 
                    userUid: vehicle["userUid"], 
                    name: vehicle["name"], 
                    type: vehicle["type"].toString().type, 
                    id: vehicle["id"], 
                    fuelBrand: vehicle["fuelBrand"]);
                },).toList();

                return ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder:(context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final deleteResult = await Navigator.push(context, MaterialPageRoute(builder: (context)=>VehicleDetailsScreen(vehicle: vehicles[index])));
                        if(deleteResult==null) return;
                        if(deleteResult) {

                        if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language.vehicleDeleteWithSuccess)));
                          }
                        
                      } else if(!deleteResult) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language.vehicleDeleteWithError)));
                          }
                      }
                      },
                      child: VehicleCell(vehicle: vehicles[index]));
                  
                },);

              } else {
               return Center(child: Text(language.emptyVehicle, textAlign: TextAlign.center,),);
              }
            }
          }
          return Container();
          
        },)
    );
  }
}