
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/models/fuel_model.dart';
import 'package:fueler_new/models/vehicle_model.dart';
import 'package:fueler_new/screens/drawer/vehicle/edit_vehicle_screen.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key, required this.vehicle});

  final VehicleModel vehicle;

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late VehicleModel changeableVehicle;
  late List<Fuel> fuelList;
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName.split('_')[1]);
  
  
@override
  void initState() {
    super.initState();
    changeableVehicle = widget.vehicle;

  }
  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    Future<List<Fuel>?> fuels = FirebaseFirestoreServices().getFuelsByVehicle(changeableVehicle);
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(language.vehicleDetails),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 128),
          child: Column(
            children: [
            SizedBox(
              height: 128,
              width: 128,
              child: Icon(widget.vehicle.type.icon, size: 100,),
            ),
            const SizedBox(height: 24,),
            Text(changeableVehicle.name, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),),
            const SizedBox(height: 8,),
            Text("${changeableVehicle.id} - ${changeableVehicle.fuelBrand}", style: Theme.of(context).textTheme.bodyLarge,),
            const SizedBox(height: 24,),
            FutureBuilder(
              future: fuels,
              builder:(context, snapshot) {
                if(snapshot.hasError) return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25));
                if(snapshot.connectionState == ConnectionState.waiting) return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25));
                if(snapshot.hasData && snapshot.data != null) {
                  final fuels = snapshot.data!;
                  fuelList = fuels;
                  var totalFuelCount = fuels.length;
                  var totalFuelExpenses = 0.0;
                  for(var fuel in fuels) {
                    totalFuelExpenses += fuel.amount;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    Column(
                      children: [
                        Text(language.fuelCount,style: Theme.of(context).textTheme.bodyLarge,),
                        Text("$totalFuelCount",style: Theme.of(context).textTheme.bodyLarge,)
                      ],
                    ),
                    Column(
                      children: [
                        Text(language.totalSpent, style: Theme.of(context).textTheme.bodyLarge,),
                        Text("${format.currencySymbol} $totalFuelExpenses", style: Theme.of(context).textTheme.bodyLarge,)
                      ],
                    )
                    ],
                  );
                }
                return Container();
              },),
             
            const Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () async {
               Navigator.push(context, MaterialPageRoute(builder: (context) => EditVehicleScreen(vehicle: changeableVehicle))).then((value) {
                 if (value != null) {
                  setState(() {
                    changeableVehicle = value;
                  });
                }
               });
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
                  height: 48,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(language.edit, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),),),
              ),
            ),
            GestureDetector(
              onTap: () {
                showAdaptiveDialog(context: context, builder:(context) {
                   return AlertDialog.adaptive(
                      title: Text(language.deleteVehicle),
                      content: Text(language.deleteDesc),
                      actions: [
                         adaptiveAction(context: context, onPressed: (){
                          FirebaseFirestoreServices().deleteVehicle(changeableVehicle).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          }).onError((error, stackTrace){
                            Navigator.pop(context);
                            Navigator.pop(context, false);
                          });
                         }, child: Text(language.deleteJustVehicle, style: const TextStyle(color: Colors.red),)),
                          adaptiveAction(context: context, onPressed: (){


                            FirebaseFirestoreServices().deleteFuels(fuelList, changeableVehicle.userUid).then((value) {
                              FirebaseFirestoreServices().deleteVehicle(changeableVehicle).then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context, true);
                              }).onError((error, stackTrace) {
                                Navigator.pop(context);
                                Navigator.pop(context, false);
                              });
                            }).onError((error, stackTrace) {
                                Navigator.pop(context);
                                Navigator.pop(context, false);

                            });

                         }, child: Text(language.deleteWithExpenses ,style: const TextStyle(color: Colors.red))),
                           adaptiveAction(context: context, onPressed: (){
                            Navigator.pop(context);
                         }, child: Text(language.cancel)),
                      ],
                   );
                  
                },);
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  height: 48,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.error, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(language.delete, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),),),
              ),
            ),
          

          ],),
        ),
      )
    );
  }
}