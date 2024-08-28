import 'package:authority_panel/Screen/Signup.dart';
import 'package:authority_panel/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }






  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zoom clone',
        themeMode: ThemeMode.system,
        theme: TAppTheme.lighttheme,
      darkTheme: TAppTheme.darktheme,
        home: SignUp(),
        );
  }
}


