
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_auth_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/helpers/auth_exception_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPwScreen extends StatefulWidget {
  const ForgotPwScreen({super.key});

  @override
  State<ForgotPwScreen> createState() => _ForgotPwScreenState();
}

class _ForgotPwScreenState extends State<ForgotPwScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _showLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(language.fotgotpw, style: Theme.of(context).textTheme.displaySmall,),
            const SizedBox(height: 8,),
            Text(language.fotgotpwDesc),
            const SizedBox(height: 48,),
            Form(
              key: _formKey,
              child: TextFormField(
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
            ),
    
            const SizedBox(height: 48,),
             
              GestureDetector(
                onTap: () async {
                  if(_formKey.currentState!.validate()) {
                    var email = _emailController.text;
                    setState(() { 
                      _showLoading = true; 
                    });
                    var authResult = await FirebaseAuthServices().resetPw(email);
                     setState(() { 
                      _showLoading = false; 
                    });
                    if(authResult == AuthResultStatus.successful) {
                      if (!context.mounted) { return; }
                        showAdaptiveDialog(context: context, builder:(context) {
                          return AlertDialog.adaptive(
                             title: Text(language.emailWasSent),
                             content: Text(language.emailWasSentDecs),
                             actions: [
                              adaptiveAction(context: context,
                                onPressed: (){
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }, 
                                child: Text(language.ok))
                              ],
                          );
                        },);
                        
                      } else {
                        if (!context.mounted) { return; }
                        var message = AuthExceptionHandler.generateExceptionMessage(authResult, context);
                        showAdaptiveDialog(context: context, builder:(context) {
                          return AlertDialog.adaptive(
                             title: Text(language.error),
                             content: Text(message),
                             actions: [
                              adaptiveAction(context: context,
                                onPressed: (){
                                  Navigator.pop(context);
                                }, 
                                child: Text(language.ok))
                              ],
                          );
                        },);
                      }
                  
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
                  height: 48,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: _showLoading 
                  ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25)) 
                  : Center(child: Text(language.resetPwButtonTitle),),
                ),
              ),
            ]
          ),
        
        ),
      ),
    );
  }
}