import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:provider/provider.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';

class AccountScreen extends StatelessWidget {
  final bool isFromSignUp;
  final TextEditingController _fullNameController = TextEditingController();

  AccountScreen({super.key, this.isFromSignUp = false});

  @override
  Widget build(BuildContext context) {
    final accountState = Provider.of<AccountState>(context);
    final user = accountState.user;
    _fullNameController.text = user?.fullName ?? '';

    // if there is no instance of user, navigate to SignScreen
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(AppRoutes.signin);
      });
      return Container();
    }

    // otherwise, let's build the AccountScreen
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        leading: isFromSignUp ? null : BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            SizedBox(height: 16),
            Text(user.email ?? '', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              onChanged: (value) {
                accountState.updateUserName(value);
              },
            ),
            Spacer(),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Save user data
                      await accountState.saveUserData();
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Text(isFromSignUp?'Complete Profile':"Save"),
                  ),
                  SizedBox(height: 16),
                  if (!isFromSignUp) ElevatedButton(
                  onPressed: () async {
                    await AuthLogic.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      // Pop to root and replace with SignScreen
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.signin,
                        (route) => false
                      );
                    }
                  },
                  child: Text('Sign Out'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}