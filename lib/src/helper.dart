import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_loan/constants.dart';
import 'package:group_loan/main.dart';
import 'package:group_loan/src/app.dart';
import 'package:group_loan/src/auth/authgate.dart';
import 'package:group_loan/src/auth/signin.dart';
import 'package:group_loan/src/staffs/staffs.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget createTextButton(
  BuildContext context,
  String text,
  Widget icon,
  VoidCallback onPressed, {
  bool isSelected = false,
  bool isDisabled = false,
}) {
  return ResponsiveBuilder(
    builder: (context, sizeConstraints) {
      if (sizeConstraints.isMobile) {
        return ListTile(
          onTap: isDisabled ? null : onPressed,
          leading: icon,
          title: Text(
            text,
            style: isSelected
                ? const TextStyle(fontWeight: FontWeight.w800)
                : null,
          ),
        );
      }

      return InkWell(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          //color: isSelected ? Theme.of(context).highlightColor : null,
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(
                width: 8,
              ),
              Text(
                text,
                style: isSelected
                    ? const TextStyle(fontWeight: FontWeight.w800)
                    : null,
              ),
            ],
          ),
        ),
      );
    },
  );
}

List<Widget> createNavMenus(
  BuildContext context, {
  String? selectedButton,
}) {
  return [
    createTextButton(
      context,
      "Staff",
      const FaIcon(FontAwesomeIcons.user),
      () {
        myNavigator.toReplacement(Staffs.routeName);
      },
      isSelected: selectedButton == 'Staff',
      isDisabled: myNavigator.routeData.path == Staffs.routeName,
    ),
    createTextButton(
      context,
      "Groups",
      const FaIcon(FontAwesomeIcons.users),
      () {
        myNavigator.toReplacement(Constants.groupRoute);
      },
      isSelected: selectedButton == 'Groups',
      isDisabled: myNavigator.routeData.path == Constants.groupRoute,
    ),
    createTextButton(
      context,
      'Home',
      const FaIcon(FontAwesomeIcons.home),
      () {},
      isSelected: selectedButton == 'Home',
    ),
    createTextButton(
      context,
      'Profile',
      const FaIcon(FontAwesomeIcons.user),
      () {},
      isSelected: selectedButton == 'Profile',
    ),
    createTextButton(
      context,
      'Settings',
      const FaIcon(FontAwesomeIcons.cog),
      () {},
      isSelected: selectedButton == 'Settings',
    ),
    createTextButton(
      context,
      'CrashApp',
      const FaIcon(FontAwesomeIcons.bug),
      () {
        FirebaseCrashlytics.instance.crash();
      },
      isSelected: selectedButton == 'Settings',
    ),
    if (FirebaseAuth.instance.currentUser != null)
      Tooltip(
        message: '${FirebaseAuth.instance.currentUser!.email}',
        child: createTextButton(
          context,
          'Logout',
          const FaIcon(FontAwesomeIcons.arrowRight),
          () async {
            await FirebaseAuth.instance.signOut();
            myNavigator.toReplacement(SignIn.routeName);
          },
        ),
      ),
  ];
}

Drawer createEndDrawer(List<Widget> navMenus, BuildContext context) {
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Group Loan",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              if (FirebaseAuth.instance.currentUser != null)
                Text(
                  FirebaseAuth.instance.currentUser!.email ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
        ...navMenus,
      ],
    ),
  );
}

AppBar createAppBar(List<Widget> navMenus) {
  return AppBar(
    automaticallyImplyLeading: !kIsWeb,
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
    actions: [
      ResponsiveBuilder(
        builder: (context, sizingInformation) {
          const paddingRight = EdgeInsets.only(right: 10);
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            return Container(
              padding: paddingRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: navMenus,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    ],
  );
}
