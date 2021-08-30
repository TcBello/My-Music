import 'package:flutter/material.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class DataPlaceholder extends StatelessWidget {
  const DataPlaceholder({
    required this.text
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(text, style: ThemeProvider.themeOf(context).data.textTheme.headline6!.copyWith(
          color: Color(theme.textHexColor)
        )),
      ),
    );
  }
}