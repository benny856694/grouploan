import 'package:flutter/material.dart';
import 'package:group_loan/constants.dart';
import 'package:group_loan/src/model/group.dart';

import '../widgets/group.dart';

class GroupEditPage extends StatelessWidget {
  static const String routeName = Constants.groupEdit;
  final Group? group;
  const GroupEditPage({Key? key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group == null ? 'Add Group' : 'Edit Group'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GroupEdit(group: group),
        ),
      ),
    );
  }
}
