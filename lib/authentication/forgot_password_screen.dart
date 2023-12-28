import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.blue, // Set your preferred color for the AppBar
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Textfield for password reset
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),

            // Reset Password Button
            ElevatedButton(
              onPressed: () async {
                // Implement password reset logic here
                String email = _emailController.text;

                try {
                  // Send password reset email
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password reset email sent. Check your inbox.'),
                      duration: Duration(seconds: 3),
                    ),
                  );

                  // Navigate back to the login screen
                  Navigator.pop(context);
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to send password reset email. Please try again.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  print("Error during password reset: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor, // Use the primary color from the theme
              ),
              child: Text(
                'Reset Password',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}