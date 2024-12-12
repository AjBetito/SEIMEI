import 'package:flutter/material.dart';
import 'package:seimei/sign_up.dart';
import 'auth_service.dart'; // Import the helper file

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and Title
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 10),
            const Text(
              'Seizing Every Instance to Minimize\nEmpty Interactions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 40),

            // Google Sign-In Button
            ElevatedButton.icon(
              onPressed: () async {
                final user = await AuthService().signInWithGoogle();
                if (user != null) {
                  // Navigate to another page on successful login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Placeholder()), // Replace with Home Page
                  );
                }
              },
              icon: const Icon(Icons.email),
              label: const Text('Sign in with Gmail'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Divider Text
            const Text('or sign in manually', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),

            // Username or Gmail Input
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username or Gmail',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            // Password Input
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Sign-In Button
            ElevatedButton(
              onPressed: () {
                // Add manual Sign-In functionality
              },
              child: const Text('Sign In'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),

            // Sign-Up Redirect
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an Account Yet?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),

            // Footer Section
            const Spacer(),
            const Divider(),
            const Text(
              'SEIMEI\nAn application that tracks the amount of time the user has spent on their phone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 10),
            const Text(
              'Contact Us\nIf you have questions or suggestions about SEIMEI, please do not hesitate to contact us.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
