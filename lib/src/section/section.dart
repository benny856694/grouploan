// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:group_loan/src/section/section_item_vertical.dart';

class Sections extends StatefulWidget {
  const Sections({Key? key}) : super(key: key);

  @override
  _SectionsState createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  final routeName = '/';
  Widget? _mainContent;

  Widget _wideLayout(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [],
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            child: _mainContent,
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
