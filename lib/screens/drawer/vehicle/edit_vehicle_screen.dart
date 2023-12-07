
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/models/vehicle_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditVehicleScreen extends StatefulWidget {
  const EditVehicleScreen({super.key, required this.vehicle});

  final VehicleModel vehicle;

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _brandController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _showLoading = false;
  var _buttonDisable = false;
  
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.vehicle.name;
    _idController.text = widget.vehicle.id;
    _brandController.text= widget.vehicle.fuelBrand;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _idController.dispose();
    _brandController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
     return GestureDetector(
      onTap: (){
         FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
       child: Scaffold(
          appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(language.editVehicle),
        ),
        body:               
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _nameController,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: language.vehicleName,
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return language.vehicleNameValid;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _idController,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: language.vehicleId,
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return language.vehicleIdValid;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _brandController,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: language.fuelBrand,
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return language.fuelBrandValid;
                        }
                        return null;
                      },
                    ),
     
                  ],
     
                ),
              ),
     
              const SizedBox(height: 48,),
     
              GestureDetector(
                onTap: !_buttonDisable ? () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }

                  if(_formKey.currentState!.validate()) {
                  
                    setState(() { 
                      _showLoading = true; 
                      _buttonDisable = true;

                    });

                    final firebaseFirestore = FirebaseFirestoreServices();
                    var userUid = FirebaseAuth.instance.currentUser!.uid;
                    final newVehicle = VehicleModel(uid: widget.vehicle.uid, userUid: userUid, name: _nameController.text, type: widget.vehicle.type, id: _idController.text, fuelBrand: _brandController.text);
                    
                    firebaseFirestore.deleteVehicle(widget.vehicle).then((value) {
                      firebaseFirestore.addVehicle(newVehicle).then((value) {
                        Navigator.pop(context, newVehicle);
                      }).onError((error, stackTrace) {
                        Navigator.pop(context);
                      });
                
                    }).onError((error, stackTrace) {
                      Navigator.pop(context);
                    });

                  }
                } :(){},
              
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
                  height: 48,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: _showLoading 
                  ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 25))
                  : Center(child: Text(language.save),),
                ),
              ),
            ],
          ),
        ),
       ),
     );
  }
}