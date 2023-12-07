
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fueler_new/services/firebase_auth_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/helpers/auth_exception_helper.dart';
import 'package:fueler_new/screens/drawer/vehicle/add_vehicle_screen.dart';
import 'package:fueler_new/screens/auth/login_screen.dart';
import 'package:fueler_new/screens/auth/signup_screen.dart';
import 'package:fueler_new/screens/home_screen.dart';
import 'package:fueler_new/views/auth_method_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomingScreen extends StatefulWidget {
  const WelcomingScreen({super.key});

  @override
  State<WelcomingScreen> createState() => _WelcomingScreenState();
}

class _WelcomingScreenState extends State<WelcomingScreen> {
  var _showLoading = false;
  var _buttonDisable = false;

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
  
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Image.asset("assets/oil-price.png", width: 96,),
            const SizedBox(height: 12,),
            Text("Fueler", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),
            Text(language.fuelerTitle, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary), textScaler: const TextScaler.linear(0.85)),
            const Expanded(child: SizedBox()),
      
            if(Platform.isIOS)
      
              GestureDetector(
                onTap: !_buttonDisable ? () async {
                  setState(() { 
                    _showLoading = true; 
                    _buttonDisable = true;
                  });
                  var authResult = await FirebaseAuthServices().loginWithApple();
                  if (!context.mounted) { return; }
                  if(authResult == AuthResultStatus.successfulWithNoVehicle) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AddVehicleScreen(isItFirstVehicle: true,)), (route) => false);
                  } else if(authResult == AuthResultStatus.successful) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                  } else {
                    setState(() { 
                      _showLoading = false; 
                      _buttonDisable = false;
                    });
                    var message = AuthExceptionHandler.generateExceptionMessage(authResult, context);
                    showAdaptiveDialog(context: context, builder:(context) {
                      return AlertDialog.adaptive(
                        title: Text(language.appleLoginError),
                        content: Text(message.toString()),
                        actions: [
                          adaptiveAction(context: context, onPressed: (){
                            Navigator.pop(context);
                          }, child: Text(language.ok))
                        ],
                        
                      );
                    },);
                    }
                }:(){},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                  height: 58,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Theme.of(context).colorScheme.secondaryContainer),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _showLoading ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25)): AuthMethodButton(icon: FontAwesomeIcons.apple, title: language.continueWithApple),
                ),
              ),
      
            if(Platform.isAndroid)
      
              GestureDetector(
                onTap: () async {
                setState(() { 
                    _showLoading = true; 
                    _buttonDisable = true;
                  });
                  var authResult = await FirebaseAuthServices().loginWithGoogle();
                  if (!context.mounted) { return; }
                  if(authResult == AuthResultStatus.successfulWithNoVehicle) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AddVehicleScreen(isItFirstVehicle: true,)), (route) => false);
                  } else if(authResult == AuthResultStatus.successful) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                  } else {
                      setState(() { 
                      _showLoading = false; 
                      _buttonDisable = false;
                    });
                    var message = AuthExceptionHandler.generateExceptionMessage(authResult, context);
                    showAdaptiveDialog(context: context, builder:(context) {
                      return AlertDialog.adaptive(
                        title: Text(language.googleLoginError),
                        content: Text(message.toString()),
                        actions: [
                          adaptiveAction(context: context, onPressed: (){
                            Navigator.pop(context);
                          }, child: Text(language.ok))
                        ],
                      
                      );
                    },);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                  height: 58,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Theme.of(context).colorScheme.secondaryContainer),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _showLoading ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25)):  AuthMethodButton(icon: FontAwesomeIcons.google, title: language.continueWithGoogle),
                ),
              ),
      
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 48.0),
              child: Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0), 
                    child: Text(language.or, style: Theme.of(context).textTheme.bodyMedium),),
                  const Expanded(child: Divider()),
                ],
              ),
            ),
      
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
                height: 58,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Theme.of(context).colorScheme.secondaryContainer),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(child: Text(language.createAccount, style: Theme.of(context).textTheme.bodyMedium,)),
              )
              
            ),
      
            const Expanded(child: SizedBox()),
      
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: Text(language.haveAnAccount),
              ),
            )  
      
          ],
        ),
      ),
    );
  }
}



