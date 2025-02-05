import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:provider/provider.dart';
import '../../logic/account_state_screen.dart';

class AccountScreen extends StatelessWidget {
  final bool isFromSignUp;

  const AccountScreen({super.key, this.isFromSignUp = false});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AccountState>(context).user;
    final fullNameController = TextEditingController(text: user?.fullName);

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
            Text(user?.email ?? '', style: TextStyle(fontSize: 18)),
            TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
              controller: fullNameController,
              onChanged: (value) {
                user?.fullName = value;
              },
            ),
            Spacer(),
            if (isFromSignUp)
              ElevatedButton(
                onPressed: () async {
                  // Save user data and navigate to the main app
                  await Provider.of<AccountState>(context, listen: false).saveUserData();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  /* Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyApp()),
                  ); */
                },
                child: Text('Complete Profile'),
              )
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Save user data
                      await Provider.of<AccountState>(context, listen: false).saveUserData();
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                  onPressed: () async {
                    await AuthLogic.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pop();
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