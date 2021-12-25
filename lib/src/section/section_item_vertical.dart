import 'package:flutter/material.dart';

class SectionItemVertical extends StatelessWidget {
  final String _title;
  final IconData _icon;

  const SectionItemVertical(this._icon, this._title, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            _icon,
            size: 80,
          ),
          Text(
            _title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
