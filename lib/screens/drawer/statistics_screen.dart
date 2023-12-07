import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/models/fuel_model.dart';
import 'package:fueler_new/models/vehicle_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName.split('_')[1]);
    Future<List<VehicleModel>?> vehicles = FirebaseFirestoreServices().getVehicles(FirebaseAuth.instance.currentUser!.uid);
    Future<List<Fuel>?> fuels = FirebaseFirestoreServices().getFuels(FirebaseAuth.instance.currentUser!.uid);
     return Scaffold(
       appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(language.statistics),
      ),
      body: FutureBuilder(
        future: Future.wait([vehicles,fuels]), 
        builder:(context, snapshot) {
          if (snapshot.hasError) return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));
          if(snapshot.connectionState == ConnectionState.waiting) { return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));}
          if(snapshot.hasData) {
            var vehiclesData = snapshot.data![0] as List<VehicleModel>;
            var fuelsData = snapshot.data![1] as List<Fuel>;
            
            var vehicleCount = vehiclesData.length;
            var fuelsCount = fuelsData.length;
            var fuelsAmountByVehicle = {};
            var fuelsCountByVehicle = {};

            var totalFuelExpense = 0.0;

            for(var fuel in fuelsData) {
              totalFuelExpense += fuel.amount;
            }

            for(var vehicle in vehiclesData) {
              fuelsAmountByVehicle[vehicle.uid] = 0;
              fuelsCountByVehicle[vehicle.uid] = 0;
              for(var fuel in fuelsData) {
                if(fuel.vehicleUid == vehicle.uid) {
                  fuelsAmountByVehicle[vehicle.uid] += fuel.amount;
                  fuelsCountByVehicle[vehicle.uid]++;
                }
                
              }
            }

            return ListView.builder(
              itemCount: vehicleCount+1,
              itemBuilder:(context, index) { 
                if(index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 12),
                        child: Text(language.general, style: Theme.of(context).textTheme.titleMedium,),
                      ),
                      Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer , borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,child: const Icon(Icons.directions_car, color: Colors.white,),),
                              title: Text(language.vehicleCount),
                              trailing: Text(vehicleCount.toString()),
                              leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
                            ),     
                            ListTile(
                              leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,child: const Icon(Icons.local_gas_station, color: Colors.white,),),
                              title: Text(language.fuelExpense),
                              trailing: Text(fuelsCount.toString()),
                              leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            ListTile(
                              leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,child: const Icon(Icons.payments, color: Colors.white,), ),
                              title: Text(language.totalExpenseAmount),
                              trailing: Text("$totalFuelExpense"),
                              leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            
                          ],
                          
                        ),
                        
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                        child: Text(language.byVehicle, style: Theme.of(context).textTheme.titleMedium,),
                      ),
                    ],
                  );
                } else {
                  var newIndex = index-1;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal:12, vertical: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer , borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(backgroundColor: Colors.white ,child: Icon(vehiclesData[newIndex].type.icon, color: Theme.of(context).primaryColor,),),
                          title: Text(vehiclesData[newIndex].name),
                          subtitle: Text("id: ${vehiclesData[newIndex].id} - ${language.fuelBrandInText} ${vehiclesData[newIndex].fuelBrand}"),
                        ),   
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(language.fuelCount, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade600),),
                                const SizedBox(height: 4,),
                                Text("${fuelsCountByVehicle[vehiclesData[newIndex].uid]}"),
                              ],
                            ),
                            const SizedBox(width: 54,),
                            Column(
                              children: [
                                Text(language.totalExpense, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade600),),
                                const SizedBox(height: 4,),
                                Text("${format.currencySymbol} ${fuelsAmountByVehicle[vehiclesData[newIndex].uid]}"),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 12,)
                      ],
                    )
                  );

                }

              }
            );
          }
         return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));
          
        },)
      
      
      
    );
  }
}