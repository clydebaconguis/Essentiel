import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:essentiel/auth/auth_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

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
            nextScreen: const AuthPage(),
            splashTransition: SplashTransition.sizeTransition,
            backgroundColor: Colors.white));
  }
}
