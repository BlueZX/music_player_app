import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar(
      {super.key,
      required this.position,
      required this.duration,
      this.onChanged,
      this.onChangeEnd});

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formatTime(_dragValue != null
                    ? Duration(seconds: _dragValue!.round())
                    : widget.position),
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
              ),
              Text(
                formatTime(widget.duration),
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
              value: _dragValue ?? widget.position.inSeconds.toDouble(),
              min: 0.0,
              max: widget.duration.inSeconds.toDouble(),
              onChanged: (value) {
                _dragValue = value;
                setState(() {});
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(seconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(seconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ]);
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
