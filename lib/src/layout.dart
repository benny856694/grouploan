// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:group_loan/src/section/section_item_vertical.dart';

abstract class Layout extends StatelessWidget {
  List<Widget> buildNavMenus(BuildContext context);
  Widget buildMainContent(BuildContext context);

  const Layout({Key? key}) : super(key: key);

  Widget _wideLayout(BuildContext context) {
    var navMenus = buildNavMenus(context);
    var mainContent = buildMainContent(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.money),
        title: Text('Group Loan'),
        //centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/groups');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/staffs');
            },
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 16),
        child: mainContent,
      ),
    );
  }

  Widget _narrowLayout(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 3,
        children: const [
          SectionItemVertical(Icons.person, 'Staff'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    late Widget w;
    if (width >= 600) {
      w = _wideLayout(context);
    } else {
      w = _narrowLayout(context);
    }

    return w;
  }
}
