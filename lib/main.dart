import 'package:firebase_connection/authentication/login_screen.dart';
import 'package:firebase_connection/event/event.dart';
import 'package:firebase_connection/firebase_options.dart';
import 'package:firebase_connection/home/HomeScreen.dart';
import 'package:firebase_connection/home/home_page.dart';
import 'package:firebase_connection/user/userProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//git remote add origin https://github.com/MUHAMMAD-AZEEM-AZAM/firebase_connection.git

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crowd Connect',
      home: Scaffold(body: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add a 2-second delay before checking shared preferences
    Future.delayed(Duration(seconds: 2), () {
      checkLoggedInUser(context);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo or name could go here
            Image.asset('lib/Images/CrowdConnect.gif', width: 200, height: 200),
            SizedBox(height: 20),
            // Text(
            //   'Crowd Connect',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> checkLoggedInUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid != null) {
      // User is already logged in, navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(uid)),
      );
    } else {
      // User is not logged in, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
