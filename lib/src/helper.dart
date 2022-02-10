import 'package:flutter/material.dart';
import 'package:group_loan/constants.dart';
import 'package:group_loan/main.dart';
import 'package:group_loan/src/app.dart';
import 'package:group_loan/src/staffs/staffs.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

Widget createTextButton(
  BuildContext context,
  String text,
  IconData icon,
  VoidCallback onPressed, {
  bool isSelected = false,
  bool isDisabled = false,
}) {
  return InkWell(
    onTap: isDisabled ? null : onPressed,
    child: Container(
      //color: isSelected ? Theme.of(context).highlightColor : null,
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            //color: isSelected ? selectedColor : null,
          ),
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
}

List<Widget> createNavMenus(
  BuildContext context, {
  String? selectedButton,
}) {
  return [
    createTextButton(
      context,
      "Staff",
      Icons.person,
      () {
        myNavigator.toReplacement(Staffs.routeName);
      },
      isSelected: selectedButton == 'Staff',
      isDisabled: myNavigator.routeData.path == Staffs.routeName,
    ),
    createTextButton(
      context,
      "Groups",
      Icons.group,
      () {
        myNavigator.toReplacement(Constants.groupRoute);
      },
      isSelected: selectedButton == 'Groups',
      isDisabled: myNavigator.routeData.path == Constants.groupRoute,
    ),
    createTextButton(
      context,
      'Home',
      Icons.home,
      () {},
      isSelected: selectedButton == 'Home',
    ),
    createTextButton(
      context,
      'Profile',
      Icons.person,
      () {},
      isSelected: selectedButton == 'Profile',
    ),
    createTextButton(
      context,
      'Settings',
      Icons.settings,
      () {},
      isSelected: selectedButton == 'Settings',
    ),
  ];
}

Drawer createEndDrawer(List<Widget> navMenus, BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        ...navMenus,
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

AppBar createAppBar(List<Widget> navMenus) {
  return AppBar(
    //leading: const Icon(Icons.money),
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
