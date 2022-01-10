import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/model/changelog.dart';
import 'package:my_music/ui/about/components/changelog_dialog.dart';
import 'package:my_music/utils/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';

class AboutUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color2,
        title: Text("About", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            ListTile(
              title: Text("Changelog", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text("See what's new", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
                color: Colors.white
              ),),
              onTap: (){
                Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
                  showDialog(context: context, builder: (context) => ChangelogDialog());
                });
              }
            ),
            ListTile(
              isThreeLine: true,
              title: Text("Report Bugs", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text("Discovered a bug? have suggestion? report it to the developer directly", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
                color: Colors.white
              ),),
              onTap: (){
                Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
                  sendEmail();
                });
              },
            ),
            ListTile(
              title: Text("Rate this app", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text("Enjoyed using this app? Write a review", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
                color: Colors.white
              ),),
            ),
            ListTile(
              title: Text("Share", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text("Share this app with your friends and families", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
                color: Colors.white
              ),),
              onTap: (){
                Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
                  Share.share(kShareMessage);
                });
              },
            ),
            ListTile(
              title: Text("Version", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text(changelogs[0].version, style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
                color: Colors.white
              ),),
            ),
          ],
        ),
      ),
    );
  }
}