import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final List<Color>? backgroundColorGradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double elevation;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColorGradient,
    this.backgroundColor,
    this.textColor,
    this.elevation = 4.0,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor,
      flexibleSpace: backgroundColorGradient != null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: backgroundColorGradient!,
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
            )
          : null,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
