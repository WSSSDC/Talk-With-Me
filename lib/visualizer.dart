import 'package:flutter/material.dart';
import 'package:talk_with_me/visualizer-input.dart';
import 'package:audio_visualizer/visualizers/bar_visualizer.dart';

class Visualizer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: StreamBuilder(
        stream: MicInput.audioFFT.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();

          final buffer = snapshot.data as List<double>;
          final wave = buffer.map((e) => e-0.25).toList();

          return Container(
            child: CustomPaint(
              painter: BarVisualizer(
                waveData: wave,
                color: Colors.pinkAccent,
                density: wave.length,
                gap: 2,
              ),
              child: new Container(),
            ),
          );
        },
      )
    );
  }
}

class Bar extends StatelessWidget {
  const Bar(this.height, { Key key }) : super(key: key);
  final int height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: 1,
      height: height.toDouble(),
    );
  }
}