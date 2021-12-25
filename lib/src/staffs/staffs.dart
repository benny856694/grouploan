import 'package:flutter/material.dart';
import 'package:group_loan/src/helper.dart';
import 'package:group_loan/src/layout.dart';

class Staffs extends Layout {
  static const String routeName = '/staffs';

  const Staffs({Key? key}) : super(key: key);

  @override
  Widget buildMainContent(BuildContext context) {
    return const Text("Staff Screen");
  }

  @override
  List<Widget> buildNavMenus(BuildContext context) => createNavMenus(context);
}
