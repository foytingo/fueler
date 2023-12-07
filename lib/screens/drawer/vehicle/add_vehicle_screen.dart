import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/models/vehicle_model.dart';
import 'package:fueler_new/screens/home_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key, required this.isItFirstVehicle});

  final bool isItFirstVehicle;

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  VehicleType _vehicleType = VehicleType.car;

  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _brandController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _showLoading = false;
  var _buttonDisable = false;

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
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text(language.addVehicle),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   language.addVehicle,
                //   style: Theme.of(context).textTheme.displaySmall,
                // ),
                // const SizedBox(
                //   height: 8,
                // ),
                if (widget.isItFirstVehicle) Text(language.firtVehicleDesc),
                widget.isItFirstVehicle
                    ? const SizedBox(height: 18)
                    : const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  height: 128,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _vehicleType = VehicleType.car;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: _vehicleType == VehicleType.car
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                    borderRadius: BorderRadius.circular(24)),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  child: const Icon(
                                    Icons.directions_car,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _vehicleType = VehicleType.motorcycle;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: _vehicleType ==
                                            VehicleType.motorcycle
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                    borderRadius: BorderRadius.circular(24)),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  child: const Icon(
                                    Icons.motorcycle,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _vehicleType = VehicleType.truck;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: _vehicleType == VehicleType.truck
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                    borderRadius: BorderRadius.circular(24)),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  child: const Icon(
                                    Icons.local_shipping,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _vehicleType = VehicleType.agriculture;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: _vehicleType ==
                                            VehicleType.agriculture
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                    borderRadius: BorderRadius.circular(24)),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  child: const Icon(
                                    Icons.agriculture,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(language.selectedVehicleType,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.normal)),
                            Text(
                              _vehicleType.getTypeNameLocal(language),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ]),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
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
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return language.vehicleNameValid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _idController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: language.vehicleId,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return language.vehicleIdValid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _brandController,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: language.fuelBrand,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return language.fuelBrandValid;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: !_buttonDisable
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _showLoading = true;
                              _buttonDisable = true;
                            });
                            final firebaseFirestore =
                                FirebaseFirestoreServices();
                            var uuid = const Uuid();
                            var userUid =
                                FirebaseAuth.instance.currentUser!.uid;
                            final newVehicle = VehicleModel(
                                uid: uuid.v4(),
                                userUid: userUid,
                                name: _nameController.text,
                                type: _vehicleType,
                                id: _idController.text,
                                fuelBrand: _brandController.text);
                            firebaseFirestore
                                .addVehicle(newVehicle)
                                .then((value) {
                              if (widget.isItFirstVehicle) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                    (route) => false);
                              } else {
                                Navigator.pop(context, true);
                              }
                            }).onError((error, stackTrace) {
                              if (widget.isItFirstVehicle) {
                                setState(() {
                                  _showLoading = false;
                                  _buttonDisable = false;
                                });
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog.adaptive(
                                      title: Text(language.addVehicleError),
                                      content:
                                          Text(language.somethingWentWrong),
                                      actions: [
                                        adaptiveAction(
                                            context: context,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(language.ok))
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Navigator.pop(context, false);
                              }
                            });
                          }
                        }
                      : () {},
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 48, vertical: 9),
                    height: 48,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12)),
                    child: _showLoading
                        ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Theme.of(context).colorScheme.primary,
                                size: 25))
                        : Center(
                            child: Text(language.done),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
