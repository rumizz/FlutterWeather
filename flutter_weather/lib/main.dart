import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_weather/login/login_notifier.dart';
import 'package:flutter_weather/weather/history.dart';
import 'package:flutter_weather/weather/map.dart';
import 'package:flutter_weather/weather/route_notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'weather/weather_notifier.dart';
import 'firebase/firebase_options.dart';
import 'login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions options;
  if (kIsWeb) {
    options = DefaultFirebaseOptions.web;
  } else if (Platform.isAndroid) {
    options = DefaultFirebaseOptions.android;
  } else {
    throw Exception("Unsupported platform");
  }
  await Firebase.initializeApp(
    options: options,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primaryColor: Colors.blue[200],
        fontFamily: 'Poppins',
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      builder: (BuildContext context, _) {
        return ChangeNotifierProvider<LoginNotifier>(
            create: (_) => LoginNotifier(),
            builder: (context, _) {
              if (context.watch<LoginNotifier>().loading) {
                return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                        color: Theme.of(context).primaryColor, size: 50));
              }
              if (!context.watch<LoginNotifier>().loggedIn) {
                return const LoginPage();
              } else {
                return MultiProvider(
                    providers: [
                      ChangeNotifierProvider<WeatherNotifier>(
                          create: (_) => WeatherNotifier()),
                      ChangeNotifierProvider<RouteNotifier>(
                          create: (_) => RouteNotifier()),
                    ],
                    builder: (context, _) {
                      String route = context.watch<RouteNotifier>().route;
                      return route == "history"
                          ? HistoryPage()
                          : const MapPage();
                    });
              }
            });
      },
    );
  }
}
