import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_weather/map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'history.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/map': (context) => const MapPage(),
        '/history': (context) => HistoryPage(),
      },
    );
  }
}
