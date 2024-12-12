import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and Title
            Image.asset('assets/logo.png', height: 100), // Replace with your logo asset
            const SizedBox(height: 10),
            const Text(
              'Seizing Every Instance to Minimize\nEmpty Interactions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),

            // Username Input
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.person, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Email Input
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Gmail',
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.email, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Birthday Input
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Birthday',
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  // Handle date input
                }
              },
            ),
            const SizedBox(height: 20),

            // Password Input
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.lock, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Confirm Password Input
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.lock, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Sign-Up Button
            ElevatedButton(
              onPressed: () {
                // Perform sign-up logic
              },
              child: const Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 40),

            // Footer Section
            const Divider(color: Colors.white),
            const Text(
              'SEIMEI\nAn application that tracks the amount of time the user has spent on their phone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Contact Us\nIf you have questions or suggestions about SEIMEI, please do not hesitate to contact us.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
