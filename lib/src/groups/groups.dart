import 'package:flutter/material.dart';
import 'package:group_loan/src/groups/group_list.dart';
import 'package:group_loan/src/layout.dart';
import '../helper.dart';

class Groups extends Layout {
  const Groups({Key? key}) : super(key: key);

  static const String routeName = '/groups';

  @override
  Widget buildMainContent(BuildContext context) => const GroupList();

  @override
  List<Widget> buildNavMenus(BuildContext context) => createNavMenus(context);
}
