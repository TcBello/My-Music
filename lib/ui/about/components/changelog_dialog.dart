import 'package:flutter/material.dart';
import 'package:my_music/model/changelog.dart';
import 'package:my_music/ui/about/components/changelog_content.dart';
import 'package:theme_provider/theme_provider.dart';

class ChangelogDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ThemeProvider.themeOf(context).data.dialogTheme.shape,
      title: Text("Changelog", style: ThemeProvider.themeOf(context).data.dialogTheme.titleTextStyle,),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(changelogs.length, (index) => ChangelogContent(
              version: changelogs[index].version,
              details: changelogs[index].details,
              textStyle: ThemeProvider.themeOf(context).data.dialogTheme.contentTextStyle!,
            ))
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text("CLOSE", style: ThemeProvider.themeOf(context).data.textTheme.button,),
          onPressed: () => Navigator.pop(context),
        )
      ]
    );
  }
}