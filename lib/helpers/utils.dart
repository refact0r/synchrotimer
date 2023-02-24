String timeString(Duration duration) {
  String min = (duration.inMinutes % 60).toString();
  String sec = (duration.inSeconds % 60).toString().padLeft(2, '0');
  String msec = (duration.inMilliseconds % 1000 / 10).floor().toString().padLeft(2, '0');
  return "$min:$sec.$msec";
}

String timeStringShort(int duration) {
  String min = (duration / 60 % 60).floor().toString();
  String sec = (duration % 60).toString().padLeft(2, '0');
  return "$min:$sec";
}
