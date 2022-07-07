import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taxi/home_page.dart';
import 'package:taxi/list_page.dart';
import 'package:taxi/login_page.dart';
import 'package:taxi/resources/theme.dart';
import 'package:taxi/tarif_page.dart';
import 'package:wakelock/wakelock.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MaterialApp(
    darkTheme: usualTheme,
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    routes: user==null ? {
      '/settings': (BuildContext context) => const TarifPage(),
      '/': (BuildContext context) => HomePage(),
      '/list': (BuildContext context) => ListPage(),

    } : {
      '/settings': (BuildContext context) => const TarifPage(),
      '/': (BuildContext context) => HomePage(),
      '/list': (BuildContext context) => ListPage(),

    },
  ));
}

