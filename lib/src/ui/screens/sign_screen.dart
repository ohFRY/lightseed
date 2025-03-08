import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:lightseed/src/ui/elements/snackbar.dart';

/// A screen that handles user authentication flows for both sign-up and sign-in.
///
/// This screen provides a unified interface for:
/// - Creating a new account (sign-up)
/// - Logging into an existing account (sign-in)
/// - Social authentication via Google
///
/// The screen adapts its UI based on the chosen authentication mode and
/// the current network connectivity status.
class SignScreen extends StatefulWidget {
  @override
  SignScreenState createState() => SignScreenState();
}

class SignScreenState extends State<SignScreen> {
  /// Controller for the email input field.
  final TextEditingController emailController = TextEditingController();
  
  /// Controller for the password input field.
  final TextEditingController passwordController = TextEditingController();
  
  /// Determines if the screen is in sign-up mode (true) or sign-in mode (false).
  bool isSignUp = true;
  
  /// Tracks the loading state during authentication operations.
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    print('DEBUG: SignScreen build');
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isSignUp ? 'Sign Up' : 'Login'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: NetworkStatus(
          child: StreamBuilder<bool>(
            stream: NetworkStatus.of(context)?.networkStatusStream,
            builder: (context, snapshot) {
              final bool isOnline = snapshot.data ?? true;
              
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(labelText: 'Email'),
                                style: TextStyle(fontSize: 18),
                                enabled: isOnline,
                              ),
                              TextField(
                                controller: passwordController,
                                decoration: InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                style: TextStyle(fontSize: 18),
                                enabled: isOnline,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: isOnline ? () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  
                                  final email = emailController.text;
                                  final password = passwordController.text;
                                  
                                  if (!mounted) return;
                                  final scaffoldContext = context;
                                  
                                  try {
                                    String? response;
                                    if (isSignUp) {
                                      response = await AuthLogic.signUp(email, password);
                                    } else {
                                      response = await AuthLogic.signIn(email, password);
                                    }

                                    if (!context.mounted) return;
                                    
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    
                                    // Only show snackbar for errors
                                    if (!response!.contains('successful')) {
                                      scaffoldContext.showSnackBar(
                                        response,
                                        isError: true,
                                      );
                                    }

                                    if (response.contains('successful')) {
                                      if (!mounted) return;
                                      
                                      if (isSignUp) {
                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                          AppRoutes.accountSetup,
                                          (route) => false, // Remove all previous routes
                                        );
                                      } else {
                                        Navigator.pushReplacementNamed(context, AppRoutes.loading);
                                      }
                                    }
                                  } catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (!mounted) return;
                                    scaffoldContext.showSnackBar(e.toString(), isError: true);
                                  }
                                } : null,
                                child: _isLoading 
                                    ? const SizedBox(
                                        height: 20, 
                                        width: 20, 
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)
                                      )
                                    : Text(isSignUp ? 'Sign Up' : 'Login'),
                              ),
                              ElevatedButton(
                                onPressed: isOnline ? () async {
                                  await AuthLogic.signInWithGoogle();
                                } : null,
                                child: Text('Sign In with Google'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUp = !isSignUp;
                        });
                      },
                      child: Text(isSignUp
                          ? 'Already have an account? Login'
                          : 'Don\'t have an account? Sign Up'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}