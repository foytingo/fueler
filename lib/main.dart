import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fueler_new/screens/home_screen.dart';
import 'package:fueler_new/screens/welcoming_screen.dart';
import 'package:fueler_new/views/no_internet_loading_view.dart';
import 'package:fueler_new/views/no_internet_view.dart';

import 'firebase_options.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fueler_new/l10n/l10n.dart';

import 'dart:io';
import 'package:flutter/services.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    String locale = "en";
    var localName = Platform.localeName.split('_')[0];
    if (localName == "tr") {
      locale = "tr";
    } else {
      locale = "en";
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF53C4FF)),
          useMaterial3: true,
        ),
        supportedLocales: L10n.all,
        locale: Locale(locale),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        home: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ConnectivityResult? result = snapshot.data;
              if (result == ConnectivityResult.none) {
                return const NoInternetView();
              } else {
                return FirebaseAuth.instance.currentUser == null
                    ? const WelcomingScreen()
                    : const HomeScreen();
              }
            } else {
              return const NoInternetLoadingView();
            }
          },
        ));
  }
}
