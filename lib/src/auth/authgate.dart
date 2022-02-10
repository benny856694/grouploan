import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:group_loan/src/app.dart';
import 'package:group_loan/src/groups/group_list.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: const [
              EmailProviderConfiguration(),
            ],
            showAuthActionSwitch: false,
            actions: [AuthStateChangeAction<SignedIn>((context, _) {
              
            })],
          );
        }

        return const Groups();
      },
    );
  }
}
