import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/about/components/changelog_dialog.dart';
import 'package:my_music/utils/utils.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: ADD REAL APP ICON ON POPUP

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
    // await _rateMyApp?.showRateDialog(
    //   context,
    //   message: "Enjoyed using this app? Please write a review",
    //   rateButton: "RATE",
    //   noButton: "NO THANKS",
    //   laterButton: "MAYBE LATER",
    //   onDismissed: () => _rateMyApp?.callEvent(RateMyAppEventType.laterButtonPressed),
    //   listener: (button){
    //     return true;
    //   },
    //   dialogStyle: DialogStyle(
    //     dialogShape: ThemeProvider.themeOf(context).data.dialogTheme.shape
    //   )
    // );

    await _rateMyApp?.showStarRateDialog(
      context,
      title: "",
      message: "Please write a review",
      onDismissed: () => _rateMyApp?.callEvent(RateMyAppEventType.laterButtonPressed),
      dialogStyle: DialogStyle(
        dialogShape: ThemeProvider.themeOf(context).data.dialogTheme.shape,
        messageStyle: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
          color: Colors.black
        ),
        messagePadding: const EdgeInsets.symmetric(vertical: 10),
        titlePadding: EdgeInsets.zero
      ),
      contentBuilder: (context , child){
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.green,
                margin: const EdgeInsets.only(bottom: 30),
              ),
              Text("Enjoying My Music?", style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                color: Colors.black
              ),),
              child
            ],
          ),
        );
      },
      actionsBuilder: (context, value){
        return [
          Center(
            child: Column(
              children: [
                TextButton(
                  child: Text("RATE", style: ThemeProvider.themeOf(context).data.textTheme.button?.copyWith(
                    color: Colors.white
                  )),
                  onPressed: () async{
                    await _rateMyApp?.callEvent(RateMyAppEventType.rateButtonPressed);

                    if(value! <= 3){
                      sendEmail();
                    }
                    else{ 
                      var result = await _rateMyApp?.launchStore();
                      if (result == LaunchStoreResult.errorOccurred){
                        showShortToast(kLaunchStoreError);
                      }
                    }

                    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(color3),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 15
                    )),
                    textStyle: MaterialStateProperty.all(ThemeProvider.themeOf(context).data.textTheme.button?.copyWith(
                      color: Colors.white
                    ))
                  ),
                ),
                SizedBox(height: 5,),
                TextButton(
                  child: Text("NOT NOW", style: ThemeProvider.themeOf(context).data.textTheme.button?.copyWith(
                    color: Colors.black
                  )),
                  onPressed: () async{
                    await _rateMyApp?.callEvent(RateMyAppEventType.laterButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.later);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15
                    )),
                  ),
                ),
              ],
            ),
          )
        ];
      },
    );
  }

  void launchPlayStore() async{
    if(await canLaunch(kPlayStoreLink)){
      var result = await launch(kPlayStoreLink);
      
      if(!result){
        showShortToast(kLaunchStoreError);
      }
    }
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
              onTap: () => launchPlayStore(),
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
            ListTile(
              title: Text("Test Rate Popup", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text("Temporary", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
                color: Colors.white
              ),),
              onTap: rateApp,
            ),
          ],
        ),
      ),
    );
  }
}