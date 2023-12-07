import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_auth_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/helpers/auth_exception_helper.dart';
import 'package:fueler_new/screens/drawer/vehicle/add_vehicle_screen.dart';
import 'package:fueler_new/screens/auth/login_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _showLoading = false;
  var _buttonDisable = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.createAccount, style: Theme.of(context).textTheme.displaySmall,),
              const SizedBox(height: 8,),
              Text(language.createAccountDesc),
        
              const SizedBox(height: 48,),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                     TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
                        ),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return language.validEmailAlert;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24,),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: language.password,
                          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
                        ),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return language.enterPw;
                          }
                          return null;
                        },
                      ),
                  ]
                )
              ),
                
              const SizedBox(height: 48,),
        
              GestureDetector(
                onTap: !_buttonDisable ? () async {
                   if(_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      var email = _emailController.text;
                      var password = _passwordController.text;
                      setState(() { 
                         _showLoading = true;
                         _buttonDisable = true;
                          
                      });
                      var authResult = await FirebaseAuthServices().sigupWithEmail(email, password);
                      if (!context.mounted) { return; }
                       if(authResult == AuthResultStatus.successful) {
                          
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AddVehicleScreen(isItFirstVehicle: true,)), (route) => false);
                        } else {
                          setState(() { 
                            _showLoading = false; 
                            _buttonDisable = false;
                          });
                          var message = AuthExceptionHandler.generateExceptionMessage(authResult,context);
                          showAdaptiveDialog(context: context, builder:(context) {
                            return AlertDialog.adaptive(
                              title: Text(language.signUpError),
                              content: Text(message.toString()),
                              actions: [
                                adaptiveAction(context: context, onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text(language.ok))
                              ],
                            
                            );
                          },);
                        }
                   }
                } : (){},
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
                  height: 48,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: _showLoading 
                  ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25))
                  : Center(child: Text(language.createAccount),),
                ),
              ),
        
              const Expanded(child: SizedBox()),        
        
              Center(child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }, child: Text(language.haveAnAccount)),
              ))
            ],
          ),
        ),
      ),
    );
  }
}