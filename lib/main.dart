import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/main_screen.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

SongModel _songModel = SongModel();

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await _songModel.getCurrentBackground();
  // await _songModel.getImageFileFromAssets();
  runApp(MaterialApp(home: Splash(),));
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

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ChangeNotifierProvider(
      create: (context) => SongModel(),
      child: MaterialApp(
          theme: ThemeData(
            tabBarTheme: tabBarStyle,
            appBarTheme: appBarStyle,
            textTheme: textStyle,
            fontFamily: "Montserrat",
          ),
          home: Material(child: Inits())
      ),
    );

  }
}

class Inits extends StatefulWidget {
  @override
  _InitsState createState() => _InitsState();
}

class _InitsState extends State<Inits> {

  SongModel songModel;
  // Isolate isolate;
  // ReceivePort receivePort;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    songModel = context.read<SongModel>();
    songModel.getCurrentBackground();
    songModel.getDataSong();
    songModel.myPlayer();
    // saveFile();
    songModel.setDefaultAlbumArt();
    // firstTimeCheck();
    // songModel.getImageFileFromAssets();
  }

  @override
  void dispose(){
    super.dispose();
    // songModel.getImageFileFromAssets();
  }

  // void getImageFileFromAssets() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final file = File('${(await getTemporaryDirectory()).path}/defAlbum.png');
  //   print("FILE EXISTS?: ${file.existsSync().toString()}");
  //   if(file.existsSync()){
  //     // defAlbum = file.path;
  //     await prefs.setString('defalbum', file.path);
  //   }
  //   else{
  //     final byteData = await rootBundle.load('assets/imgs/defalbum.png');
  //     Uint8List bdata = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  //     // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //     file.writeAsBytesSync(bdata);
  //     await prefs.setString('defalbum', file.path);
  //   }
  //   // defAlbum = file.path;
  // }

  // Future<bool> isFirstTimeOpen() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   bool isFirst = pref.getBool('isFirstTime');

  //   if(isFirst != null && !isFirst){
  //     await pref.setBool('isFirstTime', false);
  //     return false;
  //   }
  //   else{
  //     await pref.setBool('isFirstTime', false);
  //     return true;
  //   }
  // }

  // void firstTimeCheck() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String pathDir = prefs.getString('defalbum');

  //   bool isFirst = await isFirstTimeOpen();

  //   if(isFirst){
  //     getImageFileFromAssets();
  //   }

  //   if(pathDir == null){
  //     // return '';
  //     songModel.setDefAlbum(''); 
  //   }
  //   else{
  //     songModel.setDefAlbum(pathDir);
  //   }
  // }





  Future<String> getDir() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    String dirPath = directory.path;
    String filePath = "${dirPath}/defalbum.png";

    return filePath;
  }

  void saveFile() async {
    File file = File(await getDir());

    if(await file.exists()){
      songModel.defAlbum = file.path;
    }
    else{
      ByteData byteData = await rootBundle.load('assets/imgs/defalbum.png');
      file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      songModel.defAlbum = file.path;
    }
  }


  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

