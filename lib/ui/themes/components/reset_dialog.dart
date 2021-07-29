import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ResetDialog extends StatelessWidget {
  const ResetDialog({this.index, this.onPressedDelete, this.title, this.content});

  final int index;
  final Function onPressedDelete;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ThemeProvider.themeOf(context).data.dialogTheme.shape,
      title: Text(title, style: ThemeProvider.themeOf(context).data.dialogTheme.titleTextStyle,),
      content: Text(content, style: ThemeProvider.themeOf(context).data.dialogTheme.contentTextStyle),
      actions: [
        FlatButton(
          child: Text("CANCEL", style: ThemeProvider.themeOf(context).data.textTheme.button),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("RESET", style: ThemeProvider.themeOf(context).data.textTheme.button,),
          onPressed: onPressedDelete
        ),
      ],
    );
  }
}