import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue, // Set your preferred color
      ),
      backgroundColor: Colors.white, // Set your preferred background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Image.asset(
              'lib/Images/Logo.jpg',
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
            SizedBox(height: 16),

            // Password Textfield
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                labelText: 'Password',
                hintText: 'Enter your password (at least 6 characters)',
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
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

            // Confirm Password Textfield
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
              ),
              obscureText: !_passwordVisible,
            ),
            SizedBox(height: 24),

            // Sign Up Button
            ElevatedButton(
              onPressed: () async {
                // Obtain user-entered email and passwords
                String email = _emailController.text;
                String password = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;

                // Validate email format
                if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(email)) {
                  // Display an error message for invalid emails
                  _showErrorDialog(context, 'Invalid Email', 'Please enter a valid email address.');
                  return;
                }

                // Validate password length
                if (password.length < 6) {
                  // Display an error message for passwords less than 6 characters
                  _showErrorDialog(context, 'Password Error', 'Password must be at least 6 characters.');
                  return;
                }

                // Validate password match
                if (password != confirmPassword) {
                  // Display an error message for password mismatch
                  _showErrorDialog(context, 'Password Mismatch', 'Passwords do not match.');
                  return;
                }

                // Continue with user registration
                try {
                  // Create user in Firebase Authentication
                  UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Show a dialog with an option to go back to the login screen
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Registration Successful'),
                      content: Text('You can now go back to the login screen.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.pop(context); // Go back to the previous screen (SignUpScreen)
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  // Handle registration errors (show an error message, etc.)
                  print("Error during registration: $e");
                  _showErrorDialog(context, 'Registration Error', 'An error occurred during registration. Please try again.');
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Set your preferred color
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white), // Set your preferred text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}