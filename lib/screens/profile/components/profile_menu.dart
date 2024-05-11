import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        child: ListTile(
          onTap: press,
          leading: SvgPicture.asset(
            icon,
            color: Theme.of(context).buttonColor,
            width: 22,
          ),
          title: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
