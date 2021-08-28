import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ScanUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Scan", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
        backgroundColor: color2,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: color1,
        child: Column(
          children: [
            SizedBox(
              width: size.width * 0.8,
              height: size.height * 0.4,
              child: Image.asset(kScanLogo),
            ),
            Consumer<SongQueryProvider>(
              builder: (context, songQuery, child) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: songQuery.isIgnoreSongDuration45s,
                  onChanged: (value) => songQuery.setIgnoreSongDuration45(value!),
                  title: Text("Ignore song less than 45 sec songs", style: ThemeProvider.themeOf(context).data.textTheme.bodyText1)
                );
              }
            ),
            Consumer<SongQueryProvider>(
              builder: (context, songQuery, child) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: songQuery.isIgnoreSongDuration30s,
                  onChanged: (value) => songQuery.setIgnoreSongDuration30(value!),
                  title: Text("Ignore song less than 30 sec songs", style: ThemeProvider.themeOf(context).data.textTheme.bodyText1)
                );
              }
            ),
            Expanded(
              child: Container(),
            ),
            Consumer<SongQueryProvider>(
              builder: (context, songQuery, child) {
                return TextButton(
                  onPressed: () async{
                    await songQuery.reset();
                    Navigator.pop(context);
                    songQuery.getSongs();
                  },
                  child: Text("Start Scan"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(color3),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      horizontal: size.width * 0.3,
                      vertical: 20
                    )),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    textStyle: MaterialStateProperty.all(ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                      fontSize: 18
                    ))
                  ),
                );
              }
            ),
            SizedBox(height: 20,)
          ],
        ),
      )
    );
  }
}