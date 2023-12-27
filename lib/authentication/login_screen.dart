import 'package:firebase_connection/authentication/signup_screen.dart';
import 'package:firebase_connection/home/HomeScreen.dart';
import 'package:firebase_connection/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Textfield
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),

            // Password Textfield
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),

            // Login Button
            ElevatedButton(
              onPressed: () async {
                // Obtain user-entered email and password
                String email = _emailController.text;
                String password = _passwordController.text;

                try {
                  // Sign in with Firebase
                  UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Save uid to shared preferences
                  saveUidToSharedPreferences(userCredential.user!.uid);

                  // Navigate to the home screen on successful login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(userCredential.user!.uid)),
                  );
                } catch (e) {
                  // Handle login errors (show an error message, etc.)
                  print("Error during login: $e");
                  // You can display a user-friendly error message to the user
                  // using a Snackbar, AlertDialog, or any other appropriate method.
                }
              },
              child: Text('Login'),
            ),

            // Optional: Forgot Password
            TextButton(
              onPressed: () {
                // Implement your forgot password logic here
              },
              child: Text('Forgot Password?'),
            ),

            // Sign Up Link
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(
                    color: Colors.blue, // Change color as needed
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveUidToSharedPreferences(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
