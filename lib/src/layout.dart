// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'helper.dart';

abstract class Layout extends StatelessWidget {
  List<Widget> buildNavMenus(BuildContext context);
  Widget buildMainContent(BuildContext context);
  Widget? buildFloatingActionButton(BuildContext context);

  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navMenus = buildNavMenus(context);
    var mainContent = buildMainContent(context);
    return Scaffold(
      appBar: createAppBar(DeviceScreenType.desktop, navMenus),
      endDrawer: createEndDrawer(navMenus, context),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(16),
        child: mainContent,
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }
}
