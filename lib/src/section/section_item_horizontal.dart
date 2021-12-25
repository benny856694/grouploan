import 'package:flutter/material.dart';

class SectionItemHorizontal extends StatelessWidget {
  final Widget _title;
  final Widget _icon;
  final void Function()? onTap;
  const SectionItemHorizontal(this._icon, this._title, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Theme.of(context).hoverColor,
      mouseCursor: SystemMouseCursors.click,
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            _icon,
            const SizedBox(width: 8),
            _title,
          ],
        ),
      ),
    );
  }
}
