import 'package:flutter/material.dart';
import 'package:fueler_new/models/fuel_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class FuelCell extends StatelessWidget {
  const FuelCell({super.key, required this.fuel});

  final Fuel fuel;

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(fuel.timestamp);
    String locale = Localizations.localeOf(context).languageCode;
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName.split('_')[1]);

    final DateFormat formatter = DateFormat.yMMMMd(locale);
    final String formatted = formatter.format(date);

    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18, top: 12),
      padding: const EdgeInsets.only(left: 18, top: 18, bottom: 18, right: 8),
      height: 96,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text(
              "${format.currencySymbol} ${fuel.amount.toInt()}",
              style: Theme.of(context).textTheme.headlineSmall,
              textScaler: const TextScaler.linear(0.85),
            )),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatted,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textScaler: const TextScaler.linear(0.9),
                ),
                Text(
                  fuel.vehicleName,
                  style: Theme.of(context).textTheme.titleLarge,
                  textScaler: const TextScaler.linear(0.9),
                )
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 36,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ],
      ),
    );
  }
}
