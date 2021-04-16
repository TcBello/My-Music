import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_music/ui/main_screen/main_screen.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SongModel(),
      child: MaterialApp(home: Splash(),)
    )
  );
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      backgroundColor: Colors.white,
      loaderColor: Colors.white,
      loadingText: Text("Temporary SplashScreen"),
      navigateAfterSeconds: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    return MaterialApp(
        theme: ThemeData(
          tabBarTheme: tabBarStyle,
          appBarTheme: appBarStyle,
          textTheme: textStyle,
          fontFamily: "Montserrat",
        ),
        home: Material(child: Inits())
    );
  }
}

class Inits extends StatefulWidget {
  @override
  _InitsState createState() => _InitsState();
}

class _InitsState extends State<Inits> {

  SongModel songModel;

  @override
  void initState() {
    super.initState();
    songModel = context.read<SongModel>();
    songModel.getCurrentBackground();
    songModel.getDataSong();
    songModel.myPlayer();
    songModel.setDefaultAlbumArt();
  }

  // Future<String> getDir() async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   String dirPath = directory.path;
  //   String filePath = "$dirPath/defalbum.png";

  //   return filePath;
  // }

  // void saveFile() async {
  //   File file = File(await getDir());

  //   if(await file.exists()){
  //     songModel.defAlbum = file.path;
  //   }
  //   else{
  //     ByteData byteData = await rootBundle.load('assets/imgs/defalbum.png');
  //     file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //     songModel.defAlbum = file.path;
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

