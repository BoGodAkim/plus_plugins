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
Stream<AccelerometerEvent> accelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.accelerometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the accelerometer is available.
Future<bool> get isAccelerometerAvailable async {
  return await _sensors.isAccelerometerAvailable;
}

/// Returns a broadcast stream of events from the device gyroscope at the
/// given sampling frequency.
Stream<GyroscopeEvent> gyroscopeEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.gyroscopeEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the gyroscope is available.
Future<bool> get isGyroscopeAvailable async {
  return await _sensors.isGyroscopeAvailable;
}

/// Returns a broadcast stream of events from the device accelerometer with
/// gravity removed at the given sampling frequency.
Stream<UserAccelerometerEvent> userAccelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.userAccelerometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the user accelerometer is
/// available.
Future<bool> get isUserAccelerometerAvailable async {
  return await _sensors.isUserAccelerometerAvailable;
}

/// Returns a broadcast stream of events from the device gravity sensor at the
/// given sampling frequency.
Stream<GravityEvent> gravityEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.gravityEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the gravity sensor is
/// available.
Future<bool> get isGravityAvailable async {
  return await _sensors.isGravityAvailable;
}

/// Returns a broadcast stream of events from the device magnetometer at the
/// given sampling frequency.
Stream<MagnetometerEvent> magnetometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.magnetometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the magnetometer is available.
Future<bool> get isMagnetometerAvailable async {
  return await _sensors.isMagnetometerAvailable;
}

/// Returns a broadcast stream of events from the device absolute orientation
/// sensor at the given sampling frequency.
Stream<AbsoluteOrientationEvent> absoluteOrientationEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.absoluteOrientationEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the absolute orientation sensor
/// is available.
Future<bool> get isAbsoluteOrientationSensorAvailable {
  return _sensors.isAbsoluteOrientationSensorAvailable;
}

/// Returns a broadcast stream of events from the device orientation sensor at
/// the given sampling frequency.
Stream<OrientationEvent> orientationEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.orientationEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the orientation sensor is
/// available.
Future<bool> get isOrientationSensorAvailable {
  return _sensors.isOrientationSensorAvailable;
}

/// Returns a broadcast stream of events from the device absolute rotation
/// quaternion sensor at the given sampling frequency.
Stream<AbsoluteRotationQuaternionEvent> absoluteRotationQuaternionEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.absoluteRotationQuaternionEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the absolute rotation
/// quaternion sensor is available.
Future<bool> get isAbsoluteRotationQuaternionSensorAvailable {
  return _sensors.isAbsoluteRotationQuaternionSensorAvailable;
}

/// Returns a broadcast stream of events from the device rotation quaternion
/// sensor at the given sampling frequency.
Stream<RotationQuaternionEvent> rotationQuaternionEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.rotationQuaternionEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the rotation quaternion sensor
/// is available.
Future<bool> get isRotationQuaternionSensorAvailable {
  return _sensors.isRotationQuaternionSensorAvailable;
}

/// Returns a broadcast stream of events from the device absolute rotation
/// matrix sensor at the given sampling frequency.
Stream<AbsoluteRotationMatrixEvent> absoluteRotationMatrixEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.absoluteRotationMatrixEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the absolute rotation matrix
/// sensor is available.
Future<bool> get isAbsoluteRotationMatrixSensorAvailable {
  return _sensors.isAbsoluteRotationMatrixSensorAvailable;
}

/// Returns a broadcast stream of events from the device rotation matrix
/// sensor at the given sampling frequency.
Stream<RotationMatrixEvent> rotationMatrixEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.rotationMatrixEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a boolean value indicating whether the rotation matrix sensor is
/// available.
Future<bool> get isRotationMatrixSensorAvailable {
  return _sensors.isRotationMatrixSensorAvailable;
}
