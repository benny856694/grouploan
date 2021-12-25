import 'package:flutter/material.dart';

Widget createTextButton(
  BuildContext context,
  String text,
  IconData icon,
  VoidCallback onPressed,
) {
  return SizedBox(
    height: 40,
    child: TextButton.icon(
      label: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
      icon: Icon(icon),
      onPressed: onPressed,
    ),
  );
}

List<Widget> createNavMenus(BuildContext context) {
  return [
    createTextButton(
      context,
      "Staff",
      Icons.person,
      () {
        Navigator.pushNamed(context, '/staffs');
      },
    ),
    createTextButton(
      context,
      "Groups",
      Icons.group,
      () {
        Navigator.pushNamed(context, '/groups');
      },
    ),
    createTextButton(
      context,
      'Home',
      Icons.home,
      () {},
    ),
    createTextButton(
      context,
      'Profile',
      Icons.person,
      () {},
    ),
    createTextButton(
      context,
      'Settings',
      Icons.settings,
      () {},
    ),
  ];
}
