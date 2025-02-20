import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:provider/provider.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';

class AccountScreen extends StatefulWidget {
  final bool isFromSignUp;

  const AccountScreen({super.key, this.isFromSignUp = false});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the current user's name
    final user = context.read<AccountState>().user;
    _fullNameController.text = user?.fullName ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountState = Provider.of<AccountState>(context);
    final user = accountState.user;

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
        leading: widget.isFromSignUp ? null : BackButton(),
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
                accountState.updateUserName(value, controller: _fullNameController);
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
                    child: Text(widget.isFromSignUp?'Complete Profile':"Save"),
                  ),
                  SizedBox(height: 16),
                  if (!widget.isFromSignUp) ElevatedButton(
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