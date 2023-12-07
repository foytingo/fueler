import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 200,),
              Image.asset("assets/no-internet.png", width: 96,),
              const SizedBox(height: 24,),
              Text(language.noInternet, style: Theme.of(context).textTheme.headlineLarge,),
              Text(language.noInternetDesc, style: Theme.of(context).textTheme.bodyLarge,),
            ],
          ),
        ),
      ),
    );
  }
}