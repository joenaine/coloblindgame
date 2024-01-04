import 'package:colorblindgame/pages/records/records.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:colorblindgame/pages/home/home.dart';
import 'package:colorblindgame/pages/game/game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyC_NF6nwH087rVUeNOXwCZ_ddfw-uupZuo",
        authDomain: "colorblind-game.firebaseapp.com",
        projectId: "colorblind-game",
        storageBucket: "colorblind-game.appspot.com",
        messagingSenderId: "637075402495",
        appId: "1:637075402495:web:85557a9ceac714f111a6ca"),
  );
  runApp(MyApp());
}

// add two routes

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // final rand = Random();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ColorBlind Game',
      theme: ThemeData(
        primarySwatch: ([...Colors.primaries]..shuffle()).first,
        fontFamily: 'Bebas',
      ),
      home: Home(),
      // defaultRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/game': (context) => Game(),
        '/records': (context) => Records()
      },
    );
  }
}
