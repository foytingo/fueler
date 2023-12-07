import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fueler_new/screens/drawer/vehicle/vehicles_screen.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/services/firebase_storage_services.dart';
import 'package:fueler_new/models/fuel_model.dart';
import 'package:fueler_new/models/vehicle_model.dart';
import 'package:fueler_new/screens/fuel/vehicle_list_for_add_fuel.dart';
import 'package:fueler_new/views/keyboard_overlay_view.dart';
import 'package:fueler_new/helpers/adaptive_dialog_helper.dart';
import 'package:fueler_new/views/loading_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFuelScreen extends StatefulWidget {
  const AddFuelScreen({super.key, required this.vehicles});

  final List<VehicleModel> vehicles;

  @override
  State<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends State<AddFuelScreen> {
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2023);
  DateTime last = DateTime(2025);
  var format =
      NumberFormat.simpleCurrency(locale: Platform.localeName.split('_')[1]);

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: selected,
      firstDate: initial,
      lastDate: last,
    );

    if (date != null) {
      setState(() {
        selected = date;
      });
    }
  }

  FocusNode priceFocusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _compressedImage;

  @override
  void initState() {
    super.initState();
    priceFocusNode.addListener(() {
      bool hasFocus = priceFocusNode.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    selectedVehicle = widget.vehicles.first;
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    super.dispose();
  }

  void _setReceiptPhoto(ImageSource source) async {
    imageCache.clear();
    _compressedImage = null;
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage == null) return;

    final dir = await path_provider.getTemporaryDirectory();

    final targetPath = "${dir.path}/temp.jpg";

    await FlutterImageCompress.compressAndGetFile(
            File(pickedImage.path).path, targetPath,
            quality: 25)
        .then((value) {
      File(pickedImage.path).delete();
      setState(() {
        _compressedImage = File(value!.path);
      });
    });
  }

  void _removeReceiptPhoto() async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = "${dir.absolute.path}/temp.jpg";
    final photoFile = File(targetPath);
    if (photoFile.existsSync()) {
      await photoFile.delete().then((value) {
        setState(() {
          _compressedImage = null;
        });
      });
    }
  }

  late VehicleModel selectedVehicle;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final language = AppLocalizations.of(context)!;
    Widget receiptContent;
    if (_compressedImage != null) {
      receiptContent = Image.file(_compressedImage!);
    } else {
      receiptContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            language.addPhoto,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    _setReceiptPhoto(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(
                    language.selectFromGallery,
                    textScaler: const TextScaler.linear(0.8),
                  )),
              TextButton.icon(
                  onPressed: () {
                    _setReceiptPhoto(ImageSource.camera);
                  },
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(
                    language.takePhoto,
                    textScaler: const TextScaler.linear(0.8),
                  )),
            ],
          )
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(language.addFuelButtonTitle),
        actions: [
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  priceFocusNode.unfocus();
                  var uuid = const Uuid();
                  var timestamp = selected.millisecondsSinceEpoch;
                  var amount = double.parse(textController.text);

                  if (_compressedImage == null) {
                    showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog.adaptive(
                            title: Text(language.receiptPhotoNotFound),
                            content: Text(language.didNotAddReceiptPhoto),
                            actions: [
                              adaptiveAction(
                                  context: context,
                                  onPressed: () {
                                    var isHaveReceiptPhoto = false;
                                    var newFuel = Fuel(
                                        uid: uuid.v4(),
                                        userUid: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        vehicleUid: selectedVehicle.uid,
                                        vehicleName: selectedVehicle.name,
                                        vehicleId: selectedVehicle.id,
                                        fuelBrand: selectedVehicle.fuelBrand,
                                        timestamp: timestamp,
                                        amount: amount,
                                        isHaveReceiptPhoto: isHaveReceiptPhoto);

                                    LoadingView(context).startLoading();
                                    FirebaseFirestoreServices()
                                        .addFuel(newFuel)
                                        .then((value) {
                                      LoadingView(context).stopLoading();
                                      Navigator.pop(context);
                                      Navigator.pop(context, true);
                                    }).onError((error, stackTrace) {
                                      LoadingView(context).stopLoading();
                                      Navigator.pop(context);
                                      Navigator.pop(context, false);
                                    });
                                  },
                                  child: Text(language.continueWithoutPhoto)),
                              adaptiveAction(
                                  context: context,
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(language.turnBackReceipt))
                            ],
                          );
                        });
                  } else {
                    var isHaveReceiptPhoto = true;
                    var receiptPhoto = _compressedImage;
                    var uid = uuid.v4();
                    LoadingView(context).startLoading();
                    FirebaseStorageServices()
                        .uploadReceiptImage(uid, receiptPhoto!)
                        .then((result) {
                      if (result) {
                        var newFuel = Fuel(
                            uid: uid,
                            userUid: FirebaseAuth.instance.currentUser!.uid,
                            vehicleUid: selectedVehicle.uid,
                            vehicleName: selectedVehicle.name,
                            vehicleId: selectedVehicle.id,
                            fuelBrand: selectedVehicle.fuelBrand,
                            timestamp: timestamp,
                            amount: amount,
                            isHaveReceiptPhoto: isHaveReceiptPhoto);

                        FirebaseFirestoreServices()
                            .addFuel(newFuel)
                            .then((value) {
                          LoadingView(context).stopLoading();
                          Navigator.pop(context, true);
                        }).onError((error, stackTrace) {
                          LoadingView(context).stopLoading();
                          Navigator.pop(context, false);
                        });
                      }
                    }).onError((error, stackTrace) {
                      LoadingView(context).stopLoading();
                      Navigator.pop(context, false);
                    });
                  }
                }
              },
              child: Text(
                language.save,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 64,
                    height: 36,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        format.currencyName!,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer),
                      ),
                    )),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      controller: textController,
                      focusNode: priceFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return language.enterFuelExpense;
                        }
                        return null;
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                          fontSize: 24.0,
                          height: 1.1,
                          color: Theme.of(context).colorScheme.onBackground),
                      decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 24, horizontal: 12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                CustomIconView(icon: selectedVehicle.type.icon),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      priceFocusNode.unfocus();
                      if (widget.vehicles.length > 1) {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VehicleList(vehicles: widget.vehicles)))
                            .then((newVehicle) {
                          if (newVehicle != null) {
                            setState(() {
                              selectedVehicle = newVehicle;
                            });
                          }
                        });
                      } else {
                        showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog.adaptive(
                                title: Text(language.addVehicle),
                                content: Text(language.oneVehicleError),
                                actions: [
                                  adaptiveAction(
                                      context: context,
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(language.ok)),
                                  adaptiveAction(
                                      context: context,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const VehiclesScreen()));
                                      },
                                      child: Text(language.goToVehicle))
                                ],
                              );
                            });
                      }
                    },
                    child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                selectedVehicle.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
                              const Icon(
                                Icons.edit_outlined,
                                size: 16,
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CustomIconView(icon: Icons.calendar_month),
                const SizedBox(width: 8),
                Expanded(
                    child: GestureDetector(
                  onTap: () => displayDatePicker(context),
                  child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              selected.toLocal().toString().split(" ")[0],
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                            const Icon(
                              Icons.edit_outlined,
                              size: 16,
                            )
                          ],
                        ),
                      )),
                ))
              ],
            ),
            SizedBox(height: _compressedImage == null ? 24 : 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.receiptPhoto),
                if (_compressedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextButton(
                        onPressed: _removeReceiptPhoto,
                        child: Text(language.remove)),
                  )
              ],
            ),
            if (_compressedImage == null)
              const SizedBox(
                height: 12,
              ),
            Container(
                height: screenHeight * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12)),
                child: receiptContent),
          ],
        ),
      )),
    );
  }
}

class CustomIconView extends StatelessWidget {
  const CustomIconView({
    super.key,
    required this.icon,
  });

  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 48,
      width: 48,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8)),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Icon(
          icon,
          size: 18,
        ),
      ),
    );
  }
}
