import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:group_loan/src/app.dart';
import 'package:group_loan/src/auth/signin.dart';
import 'package:group_loan/src/staffs/staffs.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import '../../main.dart';
import '../groups/group_list.dart';
import '../widgets/navlink.dart';

class WebHome extends StatelessWidget {
  const WebHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        leading: kIsWeb
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.jpeg'),
                ),
              )
            : null,
        title: Row(
          children: [
            const Text('Group Loan'),
            const SizedBox(
              width: 8,
            ),
            OnReactive(
              () {
                return appState.groups.isWaiting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
        centerTitle: false,
        actions: <Widget>[
          const NavLink(title: Constants.staffs, to: Staffs.routeName),
          const NavLink(title: Constants.groups, to: Groups.routeName),
          TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                myNavigator.toAndRemoveUntil(SignIn.routeName);
              }),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: context.routerOutlet,
    );
  }
}
