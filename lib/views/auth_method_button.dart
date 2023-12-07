import 'package:flutter/material.dart';

class AuthMethodButton extends StatelessWidget {
  const AuthMethodButton({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon),
          const SizedBox(width: 12,),
          Padding(
            padding: const EdgeInsets.only(top:3.0),
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium,),
          ),
        ],
    );
  }
}