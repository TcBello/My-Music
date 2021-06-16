import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class AnimatedPausePlay extends StatefulWidget {
  // const AnimatedPausePlay({@required this.isPlaying});

  // final bool isPlaying;

  @override
  _AnimatedPausePlayState createState() => _AnimatedPausePlayState();
}

class _AnimatedPausePlayState extends State<AnimatedPausePlay> with AnimationMixin {
  Animation<double> circleAnimation;

  @override
  void initState() {
    circleAnimation = 0.0.tweenTo(1.0).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songPlayer = Provider.of<SongPlayerProvider>(context);

    return ClipOval(
      child: Stack(
        children: [
          RotationTransition(
            turns: circleAnimation,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.pinkAccent, width: 6)),
            ),
          ),
          Positioned.fill(
            child: StreamBuilder<PlaybackState>(
                stream: songPlayer.playbackStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    if(snapshot.data.playing){
                      controller.loop(duration: Duration(seconds: 3));
                    }
                    else{
                      controller.stop();
                    }

                    return IconButton(
                      icon: songPlayer.playPausePlayerIcon(snapshot.data.playing),
                      onPressed: songPlayer.pauseResume,
                    );
                  }

                  return IconButton(
                    icon: songPlayer.playPausePlayerIcon(true),
                    onPressed: songPlayer.pauseResume,
                  );
                }),
          ),
          // StreamBuilder(
          //   stream: AudioService.
          // )
        ],
      ),
    );
  }
}
