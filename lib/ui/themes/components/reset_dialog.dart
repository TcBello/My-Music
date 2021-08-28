import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ResetDialog extends StatelessWidget {
  const ResetDialog({
    required this.onPressedDelete,
    required this.title,
    required this.content
  });

  final Function() onPressedDelete;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ThemeProvider.themeOf(context).data.dialogTheme.shape,
      title: Text(title, style: ThemeProvider.themeOf(context).data.dialogTheme.titleTextStyle,),
      content: Text(content, style: ThemeProvider.themeOf(context).data.dialogTheme.contentTextStyle),
      actions: [
        TextButton(
          child: Text("CANCEL", style: ThemeProvider.themeOf(context).data.textTheme.button),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text("RESET", style: ThemeProvider.themeOf(context).data.textTheme.button,),
          onPressed: onPressedDelete
        ),
      ],
    );
  }
}