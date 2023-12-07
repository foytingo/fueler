import 'package:flutter/material.dart';
import 'package:fueler_new/models/vehicle_model.dart';
import 'package:fueler_new/views/vehicle_cell_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({super.key, required this.vehicles});

  final List<VehicleModel> vehicles;

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(language.selectVehicle),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder:(context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context, vehicles[index]);
          },
          child: VehicleCell(vehicle: vehicles[index]));
      },),
    );
  }
}
