import 'package:flutter/material.dart';
import 'package:fueler_new/services/firebase_firestore_services.dart';
import 'package:fueler_new/services/firebase_storage_services.dart';
import 'package:fueler_new/models/fuel_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

class FuelDetailsScreen extends StatefulWidget {
  const FuelDetailsScreen({super.key, required this.fuel});

  final Fuel fuel;

  @override
  State<FuelDetailsScreen> createState() => _FuelDetailsScreenState();
}

class _FuelDetailsScreenState extends State<FuelDetailsScreen> {
  var _showLoading = false;

  var format =
      NumberFormat.simpleCurrency(locale: Platform.localeName.split('_')[1]);

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    final language = AppLocalizations.of(context)!;
    var date = DateTime.fromMillisecondsSinceEpoch(widget.fuel.timestamp);
    final DateFormat formatter = DateFormat.yMMMMd(locale);
    final String formatted = formatter.format(date);

    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(language.fuelDetails),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.fuelDetails),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(
                    left: 18, top: 12, bottom: 18, right: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text(
                      formatted,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      width: 128,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(
                        "${format.currencySymbol} ${widget.fuel.amount.toInt()}",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textScaler: const TextScaler.linear(0.9),
                      )),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              language.fuelBrand,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textScaler: const TextScaler.linear(0.9),
                            ),
                            Text(
                              widget.fuel.fuelBrand,
                              style: Theme.of(context).textTheme.titleLarge,
                              textScaler: const TextScaler.linear(0.9),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              language.vehicle,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textScaler: const TextScaler.linear(0.9),
                            ),
                            Text(
                              widget.fuel.vehicleName,
                              style: Theme.of(context).textTheme.titleLarge,
                              textScaler: const TextScaler.linear(0.9),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(language.receiptPhoto),
              const SizedBox(height: 8),
              FutureBuilder(
                  future: widget.fuel.getImageUrl(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          height: screenHeight * 0.4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12)),
                          child: Image.network(snapshot.data!));
                    } else if (snapshot.hasError) {
                      return Container(
                          height: screenHeight * 0.4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text(language.photoNotFound)));
                    } else {
                      return Container(
                          height: screenHeight * 0.4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Theme.of(context).colorScheme.primary,
                              size: 100,
                            ),
                          ));
                    }
                  }),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _showLoading = true;
                  });

                  FirebaseFirestoreServices()
                      .deleteFuel(widget.fuel)
                      .then((value) {
                    if (widget.fuel.isHaveReceiptPhoto) {
                      FirebaseStorageServices()
                          .deleteReceiptImage(widget.fuel.uid)
                          .then((value) {
                        Navigator.pop(context, true);
                      }).onError((error, stackTrace) {
                        Navigator.pop(context, false);
                      });
                    } else {
                      Navigator.pop(context, true);
                    }
                  }).onError((error, stackTrace) {
                    Navigator.pop(context, false);
                  });
                },
                child: Center(
                  child: Container(
                    width: 164,
                    height: 36,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(12)),
                    child: _showLoading
                        ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white, size: 25))
                        : Center(
                            child: Text(
                            language.delete,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.white),
                          )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
