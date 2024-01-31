import 'package:firebase_connection/authentication/signup_screen.dart';
import 'package:firebase_connection/home/home_page.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password_screen.dart'; // Import the new screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue, // Set your preferred color
      ),
      backgroundColor: Colors.white, // Set your preferred background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo (Replace 'lib/Images/Logo.jpg' with the actual path to your image)
            Image.asset(
              'lib/Images/Logo.png',
              height: 50, // Adjust the height as needed
            ),
            SizedBox(height: 50),

            // Email Textfield
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),

            // Password Textfield with peek feature
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible,
            ),
            SizedBox(height: 16),

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

                   saveUidToSharedPreferences(userCredential.user!.uid);

                  // Navigate to the home screen on successful login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(userCredential.user!.uid)),
                  );

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login successful!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect email or password. Please try again.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  print("Error during login: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Set your preferred color
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white), // Set your preferred text color
              ),
            ),

            // Forgot Password Button
            TextButton(
              onPressed: () {
                // Navigate to the Forgot Password screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                );
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blue), // Set your preferred text color
              ),
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
                    color: Colors.blue, // Set your preferred text color
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

  bool _passwordVisible = false;
}