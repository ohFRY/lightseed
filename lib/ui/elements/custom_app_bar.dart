import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData leftIcon;
  final String title;
  final IconData rightIcon;
  final VoidCallback onLeftIconPressed;
  final VoidCallback onRightIconPressed;

  const CustomAppBar({
    required this.leftIcon,
    required this.title,
    required this.rightIcon,
    required this.onLeftIconPressed,
    required this.onRightIconPressed,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(leftIcon),
        onPressed: onLeftIconPressed,
      ),
      title: Text(title, textAlign: TextAlign.center),
      actions: [
        IconButton(
          icon: Icon(rightIcon),
          onPressed: onRightIconPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}