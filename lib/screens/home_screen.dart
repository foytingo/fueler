import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/models/fuel_model.dart';
import 'package:fueler_new/screens/fuel/add_fuel_screen.dart';
import 'package:fueler_new/screens/fuel/fuel_details_screen.dart';
import 'package:fueler_new/screens/fuel/search_screen.dart';
import 'package:fueler_new/views/drawer_view.dart';
import 'package:fueler_new/views/fuel_cell_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final firebaseAuth = FirebaseAuth.instance;
final firebaseFirestore = FirebaseFirestoreServices();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  
  Widget build(BuildContext context) {
    
    final language = AppLocalizations.of(context)!;
      return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(language.fuels),
          actions: [IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SearchScreen()));
          }, icon: const Icon(Icons.search))],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("fuels").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder:(context, snapshot) {
            if(snapshot.hasError) return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));
            if(snapshot.connectionState == ConnectionState.waiting) return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));
            if(snapshot.hasData) {
             
              var data = snapshot.data!.data();
              if(data == null) { return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));}
              if(data.isNotEmpty) {
                final fuelsMapList = data["fuels"] as List;
                if(fuelsMapList.isNotEmpty) {
                   final fuels = fuelsMapList.reversed.map((fuel) {
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

                    return ListView.builder(itemCount: fuels.length,
                    itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: ()async {
                        final deleteResult = await Navigator.push(context, MaterialPageRoute(builder: (context)=>FuelDetailsScreen(fuel: fuels[index])));
                        if(deleteResult==null) return;
                        if(deleteResult) {
                        if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language.fuelsDeleteWithSuccess)));
                          }
                        
                      } else if(!deleteResult) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language.fuelsDeleteWithError)));
                          }
                      }
                        
                      },
                      child: FuelCell(fuel: fuels[index]));
                    },);


                } else {
                  return Center(child: Text(language.emptyFuelList, textAlign: TextAlign.center,),);
                }
               
              }
              
            }
            return Container();
            
          },
          ),
       
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          heroTag: null,
          onPressed: () async {
            firebaseFirestore.getVehicles(firebaseAuth.currentUser!.uid).then((vehicles) async {
              if(vehicles!.isNotEmpty) {
                 final addFuelResult = await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFuelScreen(vehicles: vehicles,), fullscreenDialog: true));
                  if(addFuelResult==null) return;
                  if(addFuelResult) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language.fuelsAddWithSuccess)));
                    }
                  
                } else if(!addFuelResult) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(language.fuelsAddWithError)));
                    }
                }

              } else {
                showAdaptiveDialog(context: context, builder: (context){
                  return AlertDialog.adaptive(
                    title: Text(language.vehicleError),
                    content: Text(language.noVehicleError),
                    actions: [
                      adaptiveAction(context: context, onPressed: (){
                        Navigator.pop(context);
                      }, child: Text(language.ok))
                    ],
                  );
                });
              }
             

            }).onError((error, stackTrace) {
                showAdaptiveDialog(context: context, builder: (context){
                  return AlertDialog.adaptive(
                    title: Text(language.error),
                    content: Text(language.somethingWentWrong),
                    actions: [
                      adaptiveAction(context: context, onPressed: (){
                        Navigator.pop(context);
                      }, child: Text(language.ok))
                    ],
                  );
                });
            });

          }, 
          label: Text(language.addFuelButtonTitle),
          icon: const Icon(Icons.add),
          ),
      );

     
    
    
  }
}
