import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class AnimatedPausePlay extends StatefulWidget {
  const AnimatedPausePlay({
    required this.color
  });

  final Color color;
  @override
  _AnimatedPausePlayState createState() => _AnimatedPausePlayState();
}

class _AnimatedPausePlayState extends State<AnimatedPausePlay> with SingleTickerProviderStateMixin {
  Animation<double>? _circleAnimation;
  AnimationController? _animationController;
  bool _animatedOnce = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 7)
    );
    _circleAnimation = 0.0.tweenTo(1.0).animate(_animationController!);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songPlayer = Provider.of<SongPlayerProvider>(context);

    return RepaintBoundary(
      child: ClipOval(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _circleAnimation!,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: widget.color, width: 6)),
              ),
              builder: (context, child){
                return Transform.rotate(
                  angle: _circleAnimation!.value * 6.3,
                  child: child,
                );
              },
            ),
            Positioned.fill(
              child: StreamBuilder<PlaybackState>(
                stream: songPlayer.playbackStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data!.playing && _animatedOnce == false){
                      _animationController?.repeat();
                      _animatedOnce = true;
                    }
                    if(!snapshot.data!.playing && _animatedOnce){
                    _animationController?.stop();
                      _animatedOnce = false;
                    }
    
                    return IconButton(
                      icon: songPlayer.playPausePlayerIcon(snapshot.data!.playing),
                      onPressed: songPlayer.pauseResume,
                    );
                  }
    
                  return IconButton(
                    icon: songPlayer.playPausePlayerIcon(true),
                    onPressed: songPlayer.pauseResume,
                  );
                }),
            ),
          ],
        ),
      ),
    );
  }
}
