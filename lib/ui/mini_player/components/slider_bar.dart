import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:provider/provider.dart';

class SliderBar extends StatefulWidget {
  SliderBar({
    @required this.position,
    @required this.duration,
  });

  final Duration position;
  final Duration duration;

  @override
  _SliderBarState createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  double _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);

    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }

    try{
      return Slider(
        activeColor:
            Colors.pinkAccent,
        inactiveColor:
            Colors.pink[100],
        value: min(
          _dragValue ?? widget.position.inMilliseconds.toDouble(),
          widget.duration.inMilliseconds.toDouble()
        ),
        min: 0.0,
        max: widget.duration.inMilliseconds.toDouble(),
        onChanged: (double duration) async {
          if (!_dragging) {
            _dragging = true;
          }
          setState(() {
            _dragValue = duration;
          });
        },
        onChangeEnd: (value){
          _dragging = false;
          songPlayerProvider.seek(Duration(milliseconds: value.round()));
        }
      );
    }
    catch(e){
      return Slider(
        activeColor:
            Colors.pinkAccent,
        inactiveColor:
            Colors.pink[100],
        value: 1.0,
        min: 0.0,
        max: 1.0,
        onChanged: (double duration){}
      );
    }
  }
}