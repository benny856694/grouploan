import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:group_loan/src/app.dart';

import '../groups/group_list.dart';

class SignIn extends StatelessWidget {
  

  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(
        providerConfigs: const [
          EmailProviderConfiguration(),
        ],
        showAuthActionSwitch: false,
        headerBuilder: (context, constraints, _) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                'assets/images/logo.jpeg',
              ),
            ),
          );
        },
        sideBuilder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                'assets/images/logo.jpeg',
              ),
            ),
          );
        },
        subtitleBuilder: (context, action) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Welcome to Group Loan! Please sign in to continue.'),
          );
        },
        footerBuilder: (context, action) {
          return const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'By signing in, you agree to our Terms of Service and Privacy Policy.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
        actions: [
          AuthStateChangeAction<SignedIn>(
            (context, _) {
              myNavigator.toReplacement(Groups.routeName);
            },
          ),
        ],
      ),
    );
  }
}
