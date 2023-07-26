import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:essentiel/auth/auth_page.dart';
import 'package:essentiel/pages/home.dart';
import 'package:essentiel/signup_login/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            splash: 'images/spctLogo.jpg',
            nextScreen: AuthPage(),
            splashTransition: SplashTransition.sizeTransition,
            pageTransitionType: PageTransitionType.leftToRight,
            backgroundColor: Colors.white));
  }
}
