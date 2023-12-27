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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                hintText: 'Enter your password (at least 6 characters)',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),

            // Sign Up Button
            ElevatedButton(
              onPressed: () async {
                // Obtain user-entered email and password
                String email = _emailController.text;
                String password = _passwordController.text;

                if (password.length < 6) {
                  // Display an error message for passwords less than 6 characters
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Password must be at least 6 characters.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return; // Exit the function to prevent further execution
                }

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
                  // You can display a user-friendly error message to the user
                  // using a Snackbar, AlertDialog, or any other appropriate method.
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
