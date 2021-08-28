import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/about/components/changelog_dialog.dart';
import 'package:my_music/utils/utils.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';

// class AboutUI extends StatelessWidget {

//   RateMyApp _rateMyApp = RateMyApp(
//     minDays: 0,
//     remindDays: 0,
//     minLaunches: 0,
//     remindLaunches: 0,
//     googlePlayIdentifier: "com.tcbello.my_music"
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color1,
//       appBar: AppBar(
//         backgroundColor: color2,
//         title: Text("About", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: [
//             ListTile(
//               title: Text("Changelog", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
//                 fontWeight: FontWeight.bold
//               ),),
//               subtitle: Text("See what's new", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
//                 color: Colors.white
//               ),),
//               onTap: (){
//                 Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
//                   showDialog(context: context, builder: (context) => ChangelogDialog());
//                 });
//               }
//             ),
//             ListTile(
//               isThreeLine: true,
//               title: Text("Report Bugs", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
//                 fontWeight: FontWeight.bold
//               ),),
//               subtitle: Text("Discovered a bug? have suggestion? report it to the developer directly", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
//                 color: Colors.white
//               ),),
//               onTap: (){
//                 Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
//                   sendEmail();
//                 });
//               },
//             ),
//             ListTile(
//               title: Text("Rate this app", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
//                 fontWeight: FontWeight.bold
//               ),),
//               subtitle: Text("Enjoyed using this app? Write a review", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
//                 color: Colors.white
//               ),),
//             ),
//             ListTile(
//               title: Text("Share", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
//                 fontWeight: FontWeight.bold
//               ),),
//               subtitle: Text("Share this app with your friends and families", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
//                 color: Colors.white
//               ),),
//               onTap: (){
//                 Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
//                   Share.share(kShareMessage);
//                 });
//               },
//             ),
//             ListTile(
//               title: Text("Version", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
//                 fontWeight: FontWeight.bold
//               ),),
//               subtitle: Text(kVersion, style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
//                 color: Colors.white
//               ),),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class AboutUI extends StatefulWidget {

  @override
  _AboutUIState createState() => _AboutUIState();
}

class _AboutUIState extends State<AboutUI> {
  RateMyApp? _rateMyApp;

  @override
  void initState() {
    _rateMyApp = RateMyApp(
      googlePlayIdentifier: kAppId
    );
    _rateMyApp?.init();
    super.initState();
  }

  void rateApp() async{
    await _rateMyApp?.showRateDialog(
      context,
      title: "Rate this app",
      message: "Enjoyed using this app? Please write a review",
      rateButton: "RATE",
      noButton: "NO THANKS",
      laterButton: "MAYBE LATER",
      listener: (button){
        return true;
      },
        ignoreNativeDialog: true,
        onDismissed: () => _rateMyApp?.callEvent(RateMyAppEventType.laterButtonPressed),
      );
  }

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
              onTap: () => rateApp(),
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
              subtitle: Text(kVersion, style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
                color: Colors.white
              ),),
            ),
          ],
        ),
      ),
    );
  }
}