import 'dart:async';
import 'package:noise_meter/noise_meter.dart';

class MicInput {
  static NoiseMeter _noiseMeter = NoiseMeter((e) => print(e));
  static Stream<NoiseReading> noiseStream;

  static setup() async {
    try {
      noiseStream = _noiseMeter.noiseStream;
      noiseStream.listen(null);
    } catch (exception) {
      print(exception);
    }
  }
}
