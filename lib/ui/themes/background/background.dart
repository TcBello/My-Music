import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class Background extends StatefulWidget {
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with TickerProviderStateMixin {
  TabController? _tabController;
  double _blurValue = 0.0;
  List<String> _imageList = [];
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
    _tabController?.dispose();
  }

  Future<void> prefInit() async {
    final appDir = await getApplicationDocumentsDirectory();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final currentBackgroundId = _prefs.getString('backgroundId');
    final currentList = _prefs.getStringList('images') ?? [];
    final currentBlur = _prefs.getDouble('currentblur') ?? 0.0;
    final image = "${appDir.path}/background-$currentBackgroundId";

    if(currentBackgroundId != null && File(image).existsSync()){
      setState(() {
        _currentBG = image;
        _imageList = currentList;
        _blurValue = currentBlur;
      });
    }
  }

  Future<void> _openGallery() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> newList = _prefs.getStringList('images') ?? [];
    final _imgFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if(_imgFile != null){
      newList.insert(0, _imgFile.path);

      if(newList.length >= 11){
        newList.removeLast();
      }

      var result = await _prefs.setStringList('images', newList);
      if(result){
        setState(() {});
      }
      else{
        showShortToast("An error has occured");
      }
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
                  Consumer<CustomThemeProvider>(
                    builder: (context, theme, child) {
                      return RepaintBoundary(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          clipBehavior: Clip.hardEdge,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: _blurValue,
                              sigmaY: _blurValue
                            ),
                            child: Container(
                                height: 500,
                                width: 300,
                                child: _isChangeOnce
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(File(_currentBG), fit: BoxFit.cover),
                                  )
                                  : theme.backgroundFilePath != ""
                                    ? Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(File(_currentBG), fit: BoxFit.cover),
                                      )
                                    )
                                    : Container(
                                      color: color2
                                    )
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  RepaintBoundary(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        backgroundColor: Colors.transparent,
                        body: NestedScrollView(
                          headerSliverBuilder: (BuildContext context, bool isScreenScrolled) {
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
                    ),
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
            min: 0.0,
            max: 10.0,
            divisions: 10,
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
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10,),
            InkWell(
              onTap: () async {
                await _openGallery();
              },
              child: Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  color: color5,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
            StreamBuilder<List<String>>(
              initialData: [],
              stream: imageStream(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final imageList = snapshot.data!;

                  if(imageList.isNotEmpty){
                    if(File(imageList[0]).existsSync()){
                      return Row(
                        children: List.generate(imageList.length, (index) => Row(
                          children: [
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  _currentBG = imageList[index];
                                  if(!_isChangeOnce) _isChangeOnce = true;
                                });
                              },
                              child: Container(
                                  width: 100,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(imageList[index]),
                                      fit: BoxFit.cover,
                                    )
                                  )
                              ),
                            ),
                          ],
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
          title: Text("Background", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
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
                      Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                    else{
                      await theme.updateBG(_currentBG, _blurValue);
                      await theme.getCurrentBackground();
                      Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15),
                  child: Text(
                    "Preview",
                    style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,
                  ),
                ),
                _previewWidget(context),
                _blurWidget(),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 15),
                  child: Text(
                    "Wallpapers",
                    style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,
                  ),
                ),
                _wallpaperWidget(context),
              ],
            ),
          ),
        ));
  }
}
