import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_music/song_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final currentList = _prefs.getStringList('images');
    final currentBG = _prefs.getString('currentbg');
    if (currentList == null){
      return _imageList = [];
      // return [];
    }
    else{
      setState(() {
        _imageList = _prefs.getStringList('images');
      });
    }
    // setState(() {
    //   _imageList = _prefs.getStringList('images');
    // });

    if(currentBG != null && currentBG != "assets/imgs/starry.jpg" && File(currentBG).existsSync()){
      setState(() {
        _defaultImage = Image.file(File(currentBG), fit: BoxFit.cover,);
        _currentBG = currentBG;
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
      newList.insert(0, _imgFile.path);

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
                  Container(
                      height: 500,
                      width: 300,
                      child: _isChangeOnce ? Image.file(File(_currentBG)) : _defaultImage
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _blurValue,
                        sigmaY: _blurValue,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                  ),
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
        Text("Blur"),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Slider(
            value: _blurValue,
            min: 0.0,
            max: 10.0,
            divisions: 5,
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
                color: Colors.grey[700],
                child: Center(
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _defaultImage = Image.asset("assets/imgs/starry.jpg", fit: BoxFit.cover,);
                  _currentBG = "assets/imgs/starry.jpg";
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                width: 100,
                height: 150,
                child: Image.asset(
                  "assets/imgs/starry.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            StreamBuilder<List<String>>(
              initialData: [],
              stream: imageStream(),
              builder: (context, snapshot){
                final x = snapshot.data;

                if(snapshot.hasData){
                  // bool fileIsExisting = File(x[0]).existsSync();

                  if(x.isNotEmpty){
                    if(File(x[0]).existsSync()){
                      return Row(
                        children: List.generate(x.length, (index) => InkWell(
                          onTap: (){
                            setState(() {
                              _defaultImage = Image.file(File(x[index]), fit: BoxFit.cover,);
                              _currentBG = x[index];/////////////////
                            });
                          },

                          // TODO: UNABLE TO RETREIVE WALLPAPER HISTORY DUE TO CLEAR CACHE LOSS
                          child: Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 100,
                              height: 150,
                              child: Image.file(File(x[index]), fit: BoxFit.cover,)//////////////////////
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
        appBar: AppBar(
          title: Text("Background Skin"),
          actions: [
            Consumer<SongModel>(
              builder: (context, data, child) {
                return IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  tooltip: "Apply Changes",
                  onPressed: () async {
                    if(_currentBG == "" && _blurValue == 0.0){
                      await data.updateBG("assets/imgs/starry.jpg", _blurValue);
                      await data.getCurrentBackground().then((value){
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                    else{
                      await data.updateBG(_currentBG, _blurValue);
                      await data.getCurrentBackground().then((value){
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
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
