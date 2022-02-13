import 'package:flutter/material.dart';
import 'package:group_loan/main.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = appState.groups.item(context)!;
    return Container();
  }
}
