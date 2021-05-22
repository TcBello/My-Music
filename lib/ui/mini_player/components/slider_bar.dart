import 'package:flutter/material.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:provider/provider.dart';

class SliderBar extends StatefulWidget {
  SliderBar({
    Key key,
    @required this.positionValue,
    @required this.durationValue,
  }) : super(key: key);

  final double positionValue;
  final double durationValue;

  @override
  _SliderBarState createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  double dragValue;

  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);

    return Slider(
      activeColor:
          Colors.pinkAccent,
      inactiveColor:
          Colors.pink[100],
      value: dragValue ?? widget.positionValue ?? 0.0,
      min: 0.0,
      max: widget.durationValue ?? 0.0,
      onChanged: (double duration) async {
        setState(() {
          dragValue = duration;
        });
      },
      onChangeEnd: (value){
        songPlayerProvider.seek(Duration(milliseconds: value.round()));
        setState(() {
          dragValue = null;
        });
      }
    );
  }
}