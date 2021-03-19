import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TileInDrawer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const TileInDrawer(
      {Key key, this.title, this.subtitle, this.icon, this.onTap})
      : assert(title != null),
        assert(icon != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      dense: true,
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Icon(
        Icons.navigate_next,
        size: 30,
      ),
    );
  }
}