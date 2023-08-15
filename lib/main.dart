import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:essentiel/auth/auth_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyHomePage());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCube
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.green
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.green
    ..textColor = Colors.green
    ..maskColor = Colors.white
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context)
              .textTheme, // Apply Poppins font to the default text theme
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: '',
      home: AnimatedSplashScreen(
        splashIconSize: 100,
        duration: 2000,
        centered: true,
        splash: 'images/essentiel.png',
        nextScreen: const AuthPage(),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.white,
      ),
      builder: EasyLoading.init(),
    );
  }
}
