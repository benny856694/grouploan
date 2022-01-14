import 'package:flutter/material.dart';
import '../helper.dart';

class GroupList extends StatelessWidget {
  const GroupList({Key? key}) : super(key: key);

  

  Widget buildMainContent(BuildContext context) => const GroupList();

  List<Widget> buildNavMenus(BuildContext context) => createNavMenus(
        context,
        selectedButton: 'Groups',
      );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
    );
  }
}
