import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:lightseed/src/shared/router.dart';
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

                                    if (!mounted) return;
                                    
                                    scaffoldContext.showSnackBar(
                                      response ?? 'Unknown error',
                                      isError: !response!.contains('successful'),
                                    );

                                    if (response.contains('successful')) {
                                      if (!mounted) return;
                                      if (isSignUp) {
                                        Navigator.pushReplacementNamed(scaffoldContext, AppRoutes.accountSetup);
                                      } else {
                                        Navigator.pushReplacementNamed(scaffoldContext, AppRoutes.home);
                                      }
                                    }
                                  } catch (e) {
                                    if (!mounted) return;
                                    scaffoldContext.showSnackBar(e.toString(), isError: true);
                                  }
                                } : null,
                                child: Text(isSignUp ? 'Sign Up' : 'Login'),
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