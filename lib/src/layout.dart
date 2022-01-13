// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:group_loan/src/section/section_item_vertical.dart';
import 'package:responsive_builder/responsive_builder.dart';

abstract class Layout extends StatelessWidget {
  List<Widget> buildNavMenus(BuildContext context);
  Widget buildMainContent(BuildContext context);

  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navMenus = buildNavMenus(context);
    var mainContent = buildMainContent(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.money),
        title: Text('Group Loan'),
        centerTitle: false,
        actions: [
          ResponsiveBuilder(
            builder: (context, sizingInformation) {
              final paddingRight = EdgeInsets.only(right: 10);
              if (sizingInformation.deviceScreenType ==
                  DeviceScreenType.desktop) {
                return Container(
                  padding: paddingRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: navMenus,
                  ),
                );
              } else {
                return Container(
                  padding: paddingRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            ...navMenus,
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(16),
        child: mainContent,
      ),
    );
  }
}
