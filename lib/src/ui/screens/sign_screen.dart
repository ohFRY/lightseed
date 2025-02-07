import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/ui/app.dart';
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isSignUp ? 'Sign Up' : 'Login'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Image.asset(
                'assets/logo.png',
                height: 100, // Adjust the height as needed
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        style: TextStyle(fontSize: 18), // Increased text size
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        style: TextStyle(fontSize: 18), // Increased text size
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final email = emailController.text;
                          final password = passwordController.text;
                          String? response;
                          if (isSignUp) {
                            response = await AuthLogic.signUp(email, password);
                          } else {
                            response = await AuthLogic.signIn(email, password);
                          }

                          if (response != null) {
                            if (context.mounted) {
                              context.showSnackBar(response, isError: true);
                            }
                          }
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          }
                        },
                        child: Text(isSignUp ? 'Sign Up' : 'Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
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
                    child: Text(isSignUp
                        ? 'Already have an account? Login'
                        : 'Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}