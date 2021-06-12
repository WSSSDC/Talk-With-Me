import 'dart:async';
import 'package:audio_visualizer/audio_visualizer.dart';
import 'package:sound_stream/sound_stream.dart';

class MicInput {
  static const int bufferSize = 2048;
  static const int sampleRate = 44100;

  static RecorderStream micStream = RecorderStream();
  static Stream audioStream;
  static StreamSubscription _audioSubscription;
  static StreamController<List<double>> audioFFT;

  static setup() async {
    audioStream = micStream.audioStream;

    final visualizer = AudioVisualizer(
      windowSize: bufferSize,
      bandType: BandType.TwentySixBand,
      sampleRate: sampleRate,
      zeroHzScale: 0.05,
      fallSpeed: 0.5,
      sensibility: 100.0,
    );

    audioFFT = StreamController<List<double>>();
    _audioSubscription = audioStream.listen((buffer) => buffer);

    _audioSubscription.onData((buffer) {
      if (buffer != null) {
        print(buffer);
        final samples = buffer as List<int>;
        audioFFT.add(visualizer.transform(samples, minRange: 0, maxRange: 255));
      }
    });

    await micStream.initialize();
    await micStream.start();
  }
}