import 'package:bill_app/view/widgets/title_text.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final TitleText? title;
  final AppBar? appBar;
  final List<Widget>? widgets;

  /// you can add more fields that meet your needs

  const BaseAppBar(
      {Key? key, this.title, this.appBar, this.backgroundColor, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: backgroundColor,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar!.preferredSize.height);
}
