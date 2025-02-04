import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/ui/elements/snackbar.dart';

class SignScreen extends StatefulWidget {
  @override
  SignScreenState createState() => SignScreenState();
}

class SignScreenState extends State<SignScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Sign Up' : 'Login'),
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
                if (isSignUp) {
                  final response = await AuthLogic.signUp(email, password);
                  if (response != null) {
                    context.showSnackBar(response, isError: true);
                  }
                } else {
                  final response = await AuthLogic.signIn(email, password);
                  if (response != null) {
                    context.showSnackBar(response, isError: true);
                  }
                }
              },
              child: Text(isSignUp ? 'Sign Up' : 'Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthLogic.signInWithGoogle();
              },
              child: Text('Sign In with Google'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isSignUp = !isSignUp;
                });
              },
              child: Text(isSignUp ? 'Already have an account? Login' : 'Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}