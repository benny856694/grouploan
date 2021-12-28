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
    return Row(
      children: [
        Container(
          color: Theme.of(context).drawerTheme.backgroundColor,
          padding: const EdgeInsets.all(8),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: navMenus,
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16),
            padding: EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 16),
            child: mainContent,
          ),
        ),
      ],
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

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.topCenter,
        child: w,
      ),
    );
  }
}
