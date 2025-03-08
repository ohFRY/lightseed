import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/models/user.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:provider/provider.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A screen for displaying and editing user account information.
///
/// This screen serves two purposes:
/// 1. Account setup for new users after sign-up (when [isFromSignUp] is true)
/// 2. Account management for existing users
///
/// When used in sign-up flow, it provides a streamlined onboarding experience
/// and prevents navigation back to sign-in screens.
class AccountScreen extends StatefulWidget {
  /// Determines if this screen is being shown as part of the sign-up flow.
  ///
  /// When true, the screen behavior changes:
  /// - Back button is hidden
  /// - Completion navigates to home instead of popping
  /// - User data may be obtained directly from auth if profile isn't loaded yet
  final bool isFromSignUp;

  const AccountScreen({super.key, this.isFromSignUp = false});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  /// Controller for the full name text field.
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

    // Special handling for sign-up flow - give time for user data to load
    // or allow setup even if user data isn't fully loaded yet
    if (widget.isFromSignUp) {
      // For sign-up flow, use a placeholder user if needed
      final authUser = Supabase.instance.client.auth.currentUser;
      final workingUser = user ?? 
          (authUser != null ? 
            // Use the fromSupabaseUser factory method
            AppUser.fromSupabaseUser(authUser) : null);
            
      if (workingUser != null) {
        // We have enough to show the account setup
        return _buildAccountScreen(context, accountState, workingUser);
      }
      
      // If we're definitely signed in but user data isn't loaded yet, show loading
      if (Supabase.instance.client.auth.currentSession != null) {
        return Scaffold(
          appBar: AppBar(title: Text('Account Setup')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
    }

    // For normal account access (not from sign-up), enforce user data requirement
    if (user == null) {
      // Only redirect if we're not in sign-up flow
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(AppRoutes.signin);
      });
      return Container();
    }

    return _buildAccountScreen(context, accountState, user);
  }

  /// Builds the account screen UI with user data.
  ///
  /// This method creates the actual account screen layout including:
  /// - User avatar
  /// - Email display
  /// - Full name input field
  /// - Save/Complete button
  /// - Sign out button (when not in sign-up flow)
  ///
  /// Parameters:
  ///   [context] - The build context
  ///   [accountState] - The account state provider
  ///   [user] - The user data to display and edit
  ///
  /// Returns a scaffold containing the account UI.
  Widget _buildAccountScreen(BuildContext context, AccountState accountState, AppUser user) {
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
                    
                    // For sign-up flow, go to home screen instead of just popping
                    if (widget.isFromSignUp) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.home,
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.isFromSignUp ? 'Complete Profile' : "Save"),
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