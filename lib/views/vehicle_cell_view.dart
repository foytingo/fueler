import 'package:flutter/material.dart';
import 'package:fueler_new/models/vehicle_model.dart';

class VehicleCell extends StatelessWidget {
  const VehicleCell({super.key,required this.vehicle});

  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 18,right: 18, top: 12),
      padding: const EdgeInsets.all(18),
      height: 96,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer , borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Icon(vehicle.type.icon, size: 36,),
          ),
          const SizedBox(width: 24,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.name, style: Theme.of(context).textTheme.titleLarge,),
                Text("id: ${vehicle.id}", style: Theme.of(context).textTheme.bodyMedium,),
              ],
            ),
          ),

          Icon(Icons.chevron_right, size: 36, color: Theme.of(context).colorScheme.onSecondaryContainer),
        ],
      )
    );
  }
}
