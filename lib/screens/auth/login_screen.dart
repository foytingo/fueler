
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_auth_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/helpers/auth_exception_helper.dart';
import 'package:fueler_new/screens/auth/forgot_pw_screen.dart';

import 'package:fueler_new/screens/home_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              Text(language.login, style: Theme.of(context).textTheme.displaySmall,),
              const SizedBox(height: 8,),
              Text(language.loginDesc),
              const SizedBox(height: 48,),
              Form(
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
    
                    const SizedBox(height: 48,),
    
                    GestureDetector(
                      onTap: !_buttonDisable ? () async {
                        if(_formKey.currentState!.validate()) {
                          var email = _emailController.text;
                          var password = _passwordController.text; 
                            setState(() { 
                              _showLoading = true; 
                               _buttonDisable = true;
                            });
    
                            var authResult = await FirebaseAuthServices().loginWithEmail(email, password);
                            if (!context.mounted) { return; }
                            if(authResult == AuthResultStatus.successful) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                              
                            } else {
                              setState(() { 
                                _showLoading = false; 
                                _buttonDisable = false;
                              });
                              var message = AuthExceptionHandler.generateExceptionMessage(authResult, context);
                              showAdaptiveDialog(context: context, builder:(context) {
                                return AlertDialog.adaptive(
                                  title: Text(language.loginError),
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
                      } :() {},
                      
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
                        height: 48,
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                        child: _showLoading 
                        ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25))
                        : Center(child: Text(language.login),),
                      ),
                    ),
    
                    const SizedBox(height: 12,),
    
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPwScreen()));
                        
                      },
                      child: SizedBox(
                        height: 36,
                        child: Center(
                          child: Text(language.fotgotpw, 
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color:Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                
                  ],
                ),
              ),
    
            ]),
        ),
      ),
    );
  }
}