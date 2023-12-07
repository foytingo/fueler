
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/screens/drawer/account_screen.dart';
import 'package:fueler_new/screens/drawer/export_data_screen.dart';
import 'package:fueler_new/screens/drawer/statistics_screen.dart';
import 'package:fueler_new/screens/drawer/vehicle/vehicles_screen.dart';
import 'package:fueler_new/screens/welcoming_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
  final language = AppLocalizations.of(context)!;
   return SizedBox(
    width: 248,
     child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
              DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/oil-price.png',),
                        ),
                      
                      ),
                      const SizedBox(width: 12,),
                      Text("Fueler", style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
                    ],
                  ),
                  const SizedBox(height: 24,),
                  Text(FirebaseAuth.instance.currentUser!.email!, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary), maxLines: 1, textScaler: const TextScaler.linear(0.9),),
                ],
              )
              ),
   
              ListTile(
                title: Text(language.myVehicle),
                leading: const Icon(Icons.directions_car_outlined),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
   
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const VehiclesScreen()));
                },
              ),
              ListTile(
                title: Text(language.account),
                leading: const Icon(Icons.manage_accounts_outlined),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
   
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const AccountScreen()));
                },
              ),
              ListTile(
                title: Text(language.statistics),
                leading: const Icon(Icons.show_chart),
                trailing:const  Icon(Icons.chevron_right),
                onTap: () {
   
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsScreen()));
                },
              ),
              ListTile(
                title: Text(language.exportData),
                leading: const Icon(Icons.upload_outlined),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ExportDataScreen()));
                },
              ),
   
   
              ListTile(
                title: Text(language.logout, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),),
                leading: const Icon(Icons.logout_outlined, color: Colors.red,),
                onTap: () async {
                    await FirebaseAuth.instance.signOut();
                      if (context.mounted) { 
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const WelcomingScreen()), (route) => false);
                      }
                },
              ),
   
   
              Divider(
                thickness: 1.0, 
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8,),
              Center(child: Text(language.appVersion)),
              const Center(child: Text("v2.0.0")),
                  
   
                  
              ],
            ),
   
          ),
   );
  }
}