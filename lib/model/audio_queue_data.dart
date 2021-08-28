import 'package:audio_service/audio_service.dart';

class AudioQueueData{
  List<MediaItem>? queue;
  int index;

  AudioQueueData({
    required this.queue,
    required this.index
  });
}