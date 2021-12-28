import 'package:flutter/material.dart';

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
      color: isSelected ? Theme.of(context).highlightColor : null,
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).buttonTheme.colorScheme?.primary
                : null,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.button,
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
