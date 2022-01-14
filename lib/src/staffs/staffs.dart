import 'package:flutter/material.dart';
import 'package:group_loan/src/helper.dart';

class Staffs extends StatelessWidget {
  static const String routeName = '/staffs';

  const Staffs({Key? key}) : super(key: key);

  Widget buildMainContent(BuildContext context) {
    return const Text("Staff Screen");
  }

  List<Widget> buildNavMenus(BuildContext context) => createNavMenus(
        context,
        selectedButton: "Staff",
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildMainContent(context),
    );
  }
}
