import 'package:audio_service/audio_service.dart';
import 'package:my_music/service/audio_player_handler.dart';

class AudioHandlerSingleton{
  static final _instance = AudioHandlerSingleton._internal();

  factory AudioHandlerSingleton() => _instance;

  AudioHandlerSingleton._internal(){
    _audioHandler = AudioPlayerService();
  }

  late AudioHandler _audioHandler;
  AudioHandler get audioHandler => _audioHandler;

  Future<void> setHandler() async {
    _audioHandler = await AudioService.init(
      builder: () => AudioPlayerService(),
      config: AudioServiceConfig(
        androidStopForegroundOnPause: true,
      )
    );
  }
}