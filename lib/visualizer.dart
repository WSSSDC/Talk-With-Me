import 'package:flutter/material.dart';
import 'status-handler.dart';
import 'visualizer-input.dart';
import 'dart:math';

class Visualizer extends StatefulWidget {
  const Visualizer({ Key key }) : super(key: key);

  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  final Random rng = new Random();
  final List<double> fakeEQ = [70.0,65.0,60.0,50.0,48.0,50.0,60.0,65.0,70.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: StreamBuilder(
        stream: SessionHandler.status == TalkStatus.user_talking ? MicInput.noiseStream : Stream<LoadingStream>.periodic(Duration(milliseconds: 100), (x) => LoadingStream()..meanDecibel = (sin(x) + 1) * 50),
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: fakeEQ.map((e) => Bar(snapshot.data.meanDecibel + (rng.nextDouble() * snapshot.data.meanDecibel / 50), e)).toList(),
          );
        },
      )
    );
  }
}

class Bar extends StatelessWidget {
  const Bar(this.live, this.sub, { Key key }) : super(key: key);
  final double live;
  final double sub;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      width: 15,
      //height: SessionHandler.status == TalkStatus.user_talking ? (live - sub).clamp(0, 100).toDouble() * 1.5 : 0,
      height: (live - sub).clamp(0, 100).toDouble() * 1.5,
      child: Card(
        color: SessionHandler.status == TalkStatus.user_talking ? Colors.black : Colors.blue.withOpacity(0.5),
      ),
    );
  }
}

class LoadingStream {
  double meanDecibel;
}