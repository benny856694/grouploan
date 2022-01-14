import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

Widget createTextButton(
  BuildContext context,
  String text,
  IconData icon,
  VoidCallback onPressed, {
  bool isSelected = false,
}) {
  return InkWell(
    onTap: onPressed,
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
        Navigator.pushNamed(context, '/staffs');
      },
      isSelected: selectedButton == 'Staff',
    ),
    createTextButton(
      context,
      "Groups",
      Icons.group,
      () {
        Navigator.pushNamed(context, '/groups');
      },
      isSelected: selectedButton == 'Groups',
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
    leading: const Icon(Icons.money),
    title: const Text('Group Loan'),
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
            return Container(
              padding: paddingRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    ],
  );
}
