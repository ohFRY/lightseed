import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                await AuthLogic.signUp(email, password);
              },
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthLogic.signInWithGoogle();
              },
              child: Text('Sign Up with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
