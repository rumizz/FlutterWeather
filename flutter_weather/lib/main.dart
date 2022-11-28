import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_weather/network/firebase_api.dart';
import 'package:flutter_weather/page/history.dart';
import 'package:flutter_weather/page/map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'network/firebase_options.dart';
import 'page/login.dart';

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

  Widget withLoggedIn(BuildContext context, Widget widget) {
    if (FirebaseAPI.instance.isLoggedIn()) {
      return widget;
    } else {
      Navigator.pushReplacementNamed(context, "/");
      return const Text("Loading...");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue[200],
        fontFamily: 'Poppins',
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: FirebaseAPI.instance.isLoggedIn() ? '/map' : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/map': (context) => withLoggedIn(context, const MapPage()),
        '/history': (context) => withLoggedIn(context, HistoryPage()),
      },
    );
  }
}
