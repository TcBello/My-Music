import 'package:audio_service/audio_service.dart';

class AudioQueueData{
  List<MediaItem> queue;
  int index;

  AudioQueueData({this.queue, this.index});
}