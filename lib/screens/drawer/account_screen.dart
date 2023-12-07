
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/screens/welcoming_screen.dart';
import 'package:fueler_new/views/loading_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(language.account),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            child: ListTile(
              leading: const CircleAvatar( backgroundColor: Colors.red,child: Icon(Icons.delete, color: Colors.white,),),
              title: Text(language.deleteData, style: const TextStyle(color: Colors.red),),
              subtitle: Text(language.deleteDataDesc),
              trailing: const Icon(Icons.chevron_right),    
              onTap: () {
                showAdaptiveDialog(context: context, builder:(context) {
                  return AlertDialog.adaptive(
                    title: Text(language.deleteData),
                    content: Text(language.deleteDataConfirmation),
                    actions: [
                      adaptiveAction(context: context, onPressed: (){
                        Navigator.pop(context);
                      }, child: Text(language.cancel)),
                      adaptiveAction(context: context, onPressed: (){
                        LoadingView(context).startLoading();
                        var userUid = FirebaseAuth.instance.currentUser!.uid;
                        FirebaseFirestoreServices().deleteData(userUid).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showAdaptiveDialog(context: context, builder:(context) {
                            return AlertDialog.adaptive(
                              title: Text(language.somethingWentWrong),
                              content: Text(error.toString()),
                              actions: [
                                adaptiveAction(context: context, onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text(language.ok)),
                              ],
                            );
                          },);

                        });
                      
                        
                      }, child: Text(language.yesDelete, style: const TextStyle(color: Colors.red),)),
                    ],
                  );
                },);

              },
            ),
          ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.red,child: Icon(Icons.delete_forever, color: Colors.white,),),
              title: Text(language.deleteAccount, style: const TextStyle(color: Colors.red),),
              subtitle: Text(language.deleteWithAllData),
              trailing: const Icon(Icons.chevron_right),    
              onTap:  () {
                showAdaptiveDialog(context: context, builder:(context) {
                  return AlertDialog.adaptive(
                    title: Text(language.deleteAccount),
                    content: Text(language.deleteDataConfirmation),
                    actions: [
                      adaptiveAction(context: context, onPressed: (){
                        Navigator.pop(context);
                      }, child: Text(language.cancel)),
                      adaptiveAction(context: context, onPressed: (){
                         LoadingView(context).startLoading();

                        var userUid = FirebaseAuth.instance.currentUser!.uid;
                        FirebaseFirestoreServices().deleteAccount(userUid).then((value) {
                          
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const WelcomingScreen()), (route) => false);
                        }).onError((error, stackTrace) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showAdaptiveDialog(context: context, builder:(context) {
                            return AlertDialog.adaptive(
                              title: Text(language.somethingWentWrong),
                              content: Text(error.toString()),
                              actions: [
                                adaptiveAction(context: context, onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text(language.ok)),
                              ],
                            );
                          },);

                        });
                       
                        
                      }, child: Text(language.yesDelete, style: const TextStyle(color: Colors.red),)),
                    ],
                  );
                },);
              },
            ),
          )
        ]),
    );
  }
}