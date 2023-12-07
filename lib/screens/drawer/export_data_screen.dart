
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
    final FocusNode _focus = FocusNode();
  final _controller = TextEditingController();
  var _showLoading = false;
  var _buttonDisable = false;

 void _onFocusChange() {
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    var email = FirebaseAuth.instance.currentUser!.email!;
    _controller.text = email;


  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title:  Text(language.exportData),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(height: 36,),
            TapRegion(
              onTapOutside: (event) {
                _focus.unfocus();
              },
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focus,
                        controller: _controller,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                          hintText: language.enterNewEmailAdress,
                          labelText: language.emailAdress,
                          suffixIcon: _controller.text.isNotEmpty ? IconButton(onPressed: () {
                            setState(() {
                              _controller.clear();
                            });
                          }, icon: const Icon(Icons.clear),) : null,
                        ),     
                        onChanged: (value) {
                          setState(() {});
                        },

                      ),
                    ),
                    if(_focus.hasFocus)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextButton(onPressed: (){
                        _focus.unfocus();
                      }, child: Text(language.cancel)),
                    )
                  ],
                ),
              ),
            ),
                
            const SizedBox(height: 24,),
            ListTile(
              leading: CircleAvatar(radius: 18, backgroundColor: Theme.of(context).primaryColor ,child: const Icon(Icons.email, color: Colors.white, size: 18,),),
              title: Text(language.exportDesc1, style: Theme.of(context).textTheme.bodyMedium,),
            ),

            ListTile(
              leading: CircleAvatar(radius: 18, backgroundColor: Theme.of(context).primaryColor ,child: const Icon(Icons.description, color: Colors.white, size: 18,),),
              title: Text(language.exportDesc2, style: Theme.of(context).textTheme.bodyMedium,),
            ),


            ListTile(
              leading: CircleAvatar(radius: 18, backgroundColor: Theme.of(context).primaryColor ,child: const Icon(Icons.receipt, color: Colors.white, size: 18,),),
              title: Text(language.exportDesc3, style: Theme.of(context).textTheme.bodyMedium),
            ),



            ListTile(
              leading: CircleAvatar(radius: 18, backgroundColor: Theme.of(context).primaryColor ,child: const Icon(Icons.attach_file, color: Colors.white, size: 18,),),
              title: Text(language.exportDesc4, style: Theme.of(context).textTheme.bodyMedium,),
            ),


            const SizedBox(height: 24,),

             GestureDetector(
              onTap: !_buttonDisable ? ()async {
                
                if(_controller.text.isNotEmpty) {
                  var email = _controller.text;
                  final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

                  if(emailValid) {
                    setState(() {
                    _showLoading = true;
                    _buttonDisable = true;
                  });
                  try {

                    var result = await FirebaseFirestoreServices().generateExportDataEmail(FirebaseAuth.instance.currentUser!.uid, email);
                    if(result !=null && result) {
                      setState(() {
                        _showLoading = false;
                        _buttonDisable = false;
                      });
                      if(!mounted) { return; }
                      showAdaptiveDialog(context: context, builder:(context) {
                        return AlertDialog.adaptive(
                          title: Text(language.success),
                          content: Text(language.exportConfirmation),
                          actions: [
                            adaptiveAction(context: context, onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);

                          }, child: Text(language.ok))],
                        );
                      },);
                    }

                  } catch (error) {
                    if(!mounted) { return; }
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
                  }

                  } else {
                    showAdaptiveDialog(context: context, builder:(context) {
                        return AlertDialog.adaptive(
                          title: Text(language.checkEmail),
                          content: Text(language.checkEmailMessage1),
                          actions: [
                            adaptiveAction(context: context, onPressed: (){
                              Navigator.pop(context);
                          }, child: Text(language.ok))],
                        );
                      },);

                  }
                } else {
                   showAdaptiveDialog(context: context, builder:(context) {
                        return AlertDialog.adaptive(
                          title: Text(language.checkEmail),
                          content: Text(language.checkEmailMessage2),
                          actions: [
                            adaptiveAction(context: context, onPressed: (){
                              Navigator.pop(context);
                          }, child: Text(language.ok))],
                        );
                      },);

                }
              }:() {
                
              },
               child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
                  height: 48,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: _showLoading 
                  ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25))
                  : Center(child: Text(language.export),),
                ),
             ),
            ],
        ),
      ),
    );   
  }
}