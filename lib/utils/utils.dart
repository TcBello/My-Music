import 'package:flutter/material.dart';

double valueFromPercentageInRange(
    {@required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({@required final double min, max, value}) {
  return (value - min) / (max - min);
}

String toMinSecFormat(Duration duration) {
    if (duration.inMinutes < 60) {
      String minutes = (duration.inSeconds / 60).truncate().toString();
      String seconds =
          (duration.inSeconds % 60).truncate().toString().padLeft(2, '0');

      return "$minutes:$seconds";
    } else {
      String hours = (duration.inMinutes / 60).truncate().toString();
      String minutes =
          (duration.inMinutes % 60).truncate().toString().padLeft(2, '0');
      String seconds =
          (duration.inSeconds % 60).truncate().toString().padLeft(2, '0');

      return "$hours:$minutes:$seconds";
    }
  }

  String toMinSecFormatWhileDragging(double dragPosition, Duration duration) {
    if ((Duration(milliseconds: dragPosition.toInt()).inMinutes) < 60) {
      if (duration.inSeconds.toDouble() > dragPosition) {
        double newDouble = duration.inSeconds.toDouble() - dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String minutes = (newDuration.inSeconds / 60).truncate().toString();
        String seconds =
            (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$minutes:$seconds";
      } else {
        double newDouble = duration.inSeconds.toDouble() + dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String minutes = (newDuration.inSeconds / 60).truncate().toString();
        String seconds =
            (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$minutes:$seconds";
      }
    } else {
      if (duration.inSeconds.toDouble() > dragPosition) {
        double newDouble = duration.inSeconds.toDouble() - dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String hours = (newDuration.inMinutes / 60).truncate().toString();
        String minutes =
            (newDuration.inMinutes % 60).truncate().toString().padLeft(2, '0');
        String seconds =
            (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$hours:$minutes:$seconds";
      } else {
        double newDouble = duration.inSeconds.toDouble() + dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String hours = (newDuration.inMinutes / 60).truncate().toString();
        String minutes =
            (newDuration.inMinutes % 60).truncate().toString().padLeft(2, '0');
        String seconds =
            (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$hours:$minutes:$seconds";
      }
    }
  }