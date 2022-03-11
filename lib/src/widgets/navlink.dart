import 'package:flutter/material.dart';

import '../app.dart';

class NavLink extends StatelessWidget {
  const NavLink({
    Key? key,
    required this.title,
    required this.to,
    this.exact = false,
  }) : super(key: key);
  final String title;
  final String to;
  final bool exact;
  @override
  Widget build(BuildContext context) {
    final location = myNavigator.routeData.location;
    final isActive = exact ? location == to : location.startsWith(to);
    return TextButton(
      onPressed: () => myNavigator.toAndRemoveUntil(to),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: isActive ? FontWeight.bold : null,
          decoration: isActive ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}
