import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class BackgroundSkin extends StatefulWidget {
  @override
  _BackgroundSkinState createState() => _BackgroundSkinState();
}

class _BackgroundSkinState extends State<BackgroundSkin>
    with TickerProviderStateMixin {
  TabController _tabController;
  double _blurValue = 0.0;
  List<String> _imageList = [];
  Image _defaultImage = Image.asset("assets/imgs/starry.jpg", fit: BoxFit.cover,);
  String _currentBG = "";
  bool _isChangeOnce = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    prefInit();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    // prefInit();
    // imageStream();
  }

  Future<void> prefInit() async {
    final appDir = await getApplicationDocumentsDirectory();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final currentBackgroundId = _prefs.getString('backgroundId');
    final currentList = _prefs.getStringList('images') ?? [];
    // final currentBG = _prefs.getString('currentbg');
    final currentBlur = _prefs.getDouble('currentblur') ?? 0.0;
    final image = "${appDir.path}/background-$currentBackgroundId";

    // if (currentList == null){
    //   return _imageList = [];
    //   // return [];
    // }
    // else{
    //   setState(() {
    //     _imageList = _prefs.getStringList('images');
    //   });
    // }
    // setState(() {
    //   _imageList = _prefs.getStringList('images');
    // });

    if(currentBackgroundId != null && File(image).existsSync()){
      setState(() {
        _defaultImage = Image.file(File(image), fit: BoxFit.cover,);
        _currentBG = image;
        _imageList = currentList;
        _blurValue = currentBlur;
      });
    }
  }

  Future<void> _openGallery() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> newList = _prefs.getStringList('images');
    final _imgFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if(newList == null){
      setState(() {
        newList = [_imgFile.path];
      });
      await _prefs.setStringList('images', newList);
    }
    else{
      if(_imgFile != null) newList.insert(0, _imgFile.path);

      //DELETE IMAGE WHEN LIST LENGTH HIT 11
      if(newList.length >= 11){
        newList.removeLast();
      }

      await _prefs.setStringList('images', newList);
    }
  }

  Stream<List<String>> imageStream() async*{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final list = _prefs.getStringList('images');
    if(list != null){
      setState(() {
        _imageList = list;
      });
      yield _imageList;
    }
    else{
      yield _imageList;
    }
  }

  Widget _previewWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          IgnorePointer(
            child: SizedBox(
              height: 500,
              width: 300,
              child: Stack(
                children: [
                  ClipRect(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: _blurValue,
                        sigmaY: _blurValue
                      ),
                      child: Container(
                          height: 500,
                          width: 300,
                          child: _isChangeOnce ? Image.file(File(_currentBG)) : _defaultImage
                      ),
                    ),
                  ),
                  // Container(
                  //       height: 500,
                  //       width: 300,
                  //       child: _isChangeOnce ? Image.file(File(_currentBG)) : _defaultImage
                  // ),
                  // BackdropFilter(
                  //   filter: ImageFilter.blur(
                  //     sigmaX: _blurValue,
                  //     sigmaY: _blurValue
                  //   ),
                  //   child: Container(
                  //     height: 500,
                  //     width: 300,
                  //     color: Colors.white.withOpacity(0.0),
                  //   ),
                  // ),
                  Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.transparent,
                    body: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool isScreenScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              backgroundColor: Colors.transparent,
                              forceElevated: true,
                              title: Text("Music"),
                              leading: IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: Icon(Icons.menu),
                              ),
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {},
                                )
                              ],
                              bottom: TabBar(
                                controller: _tabController,
                                indicatorColor: Colors.pinkAccent,
                                tabs: <Widget>[
                                  Tab(
                                    text: "Songs",
                                  ),
                                  Tab(
                                    text: "Artists",
                                  ),
                                  Tab(
                                    text: "Albums",
                                  ),
                                  Tab(
                                    text: "Playlists",
                                  )
                                ],
                              ),
                            )
                          ];
                        },
                        body: TabBarView(controller: _tabController, children: [
                          Container(),
                          Container(),
                          Container(),
                          Container()
                        ])),
                    drawer: Drawer(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _blurWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
        ),
        Text("Blur", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Slider(
            value: _blurValue,
            activeColor: color3,
            inactiveColor: color5,
            // min: 0.0,
            // max: 12.5,
            min: 0.0,
            max: 12.0,
            divisions: 3,
            onChanged: (val) {
              setState(() {
                _blurValue = val;
              });
            },
          ),
        )
      ],
    );
  }

  Widget _wallpaperWidget(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                await _openGallery();
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                width: 100,
                height: 150,
                color: color5,
                child: Center(
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
            StreamBuilder<List<String>>(
              initialData: [],
              stream: imageStream(),
              builder: (context, snapshot){
                final imageList = snapshot.data;

                if(snapshot.hasData){
                  // bool fileIsExisting = File(x[0]).existsSync();

                  if(imageList.isNotEmpty){
                    if(File(imageList[0]).existsSync()){
                      return Row(
                        children: List.generate(imageList.length, (index) => InkWell(
                          onTap: (){
                            setState(() {
                              _defaultImage = Image.file(File(imageList[index]), fit: BoxFit.cover,);
                              _currentBG = imageList[index];
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 100,
                              height: 150,
                              child: Image.file(File(imageList[index]), fit: BoxFit.cover,)
                          ),
                        ),),
                      ); 
                    }
                    else{
                      SharedPreferences.getInstance().then((prefs) async {
                        List<String> formattedList = [];
                        await prefs.setStringList('images', formattedList);
                      });
                    }
                  }
                  else{
                    return Container();
                  }
                }
                
                return Container();
              },
            )
          ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
        appBar: AppBar(
          backgroundColor: color2,
          title: Text("Background Skin", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
          actions: [
            Consumer<CustomThemeProvider>(
              builder: (context, theme, child) {
                return IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  tooltip: "Apply Changes",
                  onPressed: () async {
                    if(_currentBG == "" && _blurValue == 0.0){
                      await theme.updateBG("", _blurValue);
                      await theme.getCurrentBackground();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                    else{
                      await theme.updateBG(_currentBG, _blurValue);
                      // await theme.getCurrentBackground().then((value){
                      //   Navigator.pop(context);
                      //   Navigator.pop(context);
                      // });
                      await theme.getCurrentBackground();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                );
              }
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _previewWidget(context),
                _blurWidget(),
                _wallpaperWidget(context),
              ],
            ),
          ),
        ));
  }
}
