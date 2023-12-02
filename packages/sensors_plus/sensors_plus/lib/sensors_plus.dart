import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

import 'src/sensors.dart';

export 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

export 'src/sensors.dart' if (dart.library.html) 'src/sensors_plus_web.dart';

final _sensors = Sensors();

/// A broadcast stream of events from the device accelerometer.
@Deprecated('Use accelerometerEventStream() instead.')
Stream<AccelerometerEvent> get accelerometerEvents {
  return _sensors.accelerometerEvents;
}

/// A broadcast stream of events from the device gyroscope.
@Deprecated('Use gyroscopeEventStream() instead.')
Stream<GyroscopeEvent> get gyroscopeEvents {
  return _sensors.gyroscopeEvents;
}

/// Events from the device accelerometer with gravity removed.
@Deprecated('Use userAccelerometerEventStream() instead.')
Stream<UserAccelerometerEvent> get userAccelerometerEvents {
  return _sensors.userAccelerometerEvents;
}

/// A broadcast stream of events from the device magnetometer.
@Deprecated('Use magnetometerEventStream() instead.')
Stream<MagnetometerEvent> get magnetometerEvents {
  return _sensors.magnetometerEvents;
}

/// Returns a broadcast stream of events from the device accelerometer at the
/// given sampling frequency.
@override
Stream<AccelerometerEvent> accelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.accelerometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the accelerometer is available.
@override
Future<bool> get isAccelerometerAvailable async {
  return await _sensors.isAccelerometerAvailable;
}

/// Returns a broadcast stream of events from the device gyroscope at the
/// given sampling frequency.
@override
Stream<GyroscopeEvent> gyroscopeEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.gyroscopeEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the gyroscope is available.
@override
Future<bool> get isGyroscopeAvailable async {
  return await _sensors.isGyroscopeAvailable;
}

/// Returns a broadcast stream of events from the device accelerometer with
/// gravity removed at the given sampling frequency.
@override
Stream<UserAccelerometerEvent> userAccelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.userAccelerometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the user accelerometer is
/// available.
@override
Future<bool> get isUserAccelerometerAvailable async {
  return await _sensors.isUserAccelerometerAvailable;
}

/// Returns a broadcast stream of events from the device gravity sensor at the
/// given sampling frequency.
@override
Stream<GravityEvent> gravityEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.gravityEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the gravity sensor is
/// available.
@override
Future<bool> get isGravityAvailable async {
  return await _sensors.isGravityAvailable;
}

/// Returns a broadcast stream of events from the device magnetometer at the
/// given sampling frequency.
@override
Stream<MagnetometerEvent> magnetometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.magnetometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the magnetometer is available.
@override
Future<bool> get isMagnetometerAvailable async {
  return await _sensors.isMagnetometerAvailable;
}
