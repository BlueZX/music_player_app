import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlButtons extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const ControlButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  IconData _playBtn = Icons.play_arrow;
  bool _isPlaying = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  late StreamSubscription<Duration> _positionStream;
  late StreamSubscription<Duration?> _durationStream;
  late StreamSubscription<PlayerState> _playerStateStream;

  @override
  void initState() {
    super.initState();
    try {
      widget.audioPlayer.play();
      _isPlaying = true;

      _durationStream = widget.audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          _duration = duration;
          setState(() {});
        }
      });
      _positionStream = widget.audioPlayer.positionStream.listen((position) {
        _position = position;
        setState(() {});
      });

      listenToEvent();
    } on Exception catch (_) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _durationStream.cancel();
    _positionStream.cancel();
    _playerStateStream.cancel();
  }

  void listenToEvent() {
    _playerStateStream = widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        _isPlaying = true;
        _playBtn = Icons.pause;
      } else {
        _isPlaying = false;
        _playBtn = Icons.play_arrow;
      }
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        _playBtn = Icons.play_arrow;
      }
      setState(() {});
    });
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    widget.audioPlayer.seek(newPos);
  }

  void onPlayPause() {
    if (_isPlaying) {
      widget.audioPlayer.pause();
    } else {
      if (_position >= _duration) {
        seekToSec(0);
      } else {
        widget.audioPlayer.play();
      }
    }
    _isPlaying = !_isPlaying;
    setState(() {});
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formatTime(_position),
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
              ),
              Text(
                formatTime(_duration),
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(
                disabledThumbRadius: 4,
                enabledThumbRadius: 4,
              ),
              trackHeight: 4,
              trackShape: _CustomTrackShape(),
              overlayColor: Colors.white,
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 10,
              ),
            ),
            child: Slider(
              value: min(_position.inMilliseconds.toDouble(),
                  _position.inSeconds.toDouble()),
              min: 0.0,
              max: _duration.inSeconds.toDouble() + 1,
              onChanged: (value) => seekToSec(value.toInt()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 45.0,
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(
                  Icons.skip_previous,
                ),
              ),
              IconButton(
                iconSize: 62.0,
                color: Colors.white,
                onPressed: onPlayPause,
                icon: Icon(_playBtn),
              ),
              IconButton(
                iconSize: 45.0,
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(
                  Icons.skip_next,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
