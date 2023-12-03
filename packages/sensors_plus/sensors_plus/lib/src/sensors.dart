import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

/// The Sensors implementation.
class Sensors extends SensorsPlatform {
  /// Constructs a singleton instance of [Sensors].
  ///
  /// [Sensors] is designed to work as a singleton.
  factory Sensors() => _singleton ??= Sensors._();

  Sensors._();

  static Sensors? _singleton;

  static SensorsPlatform get _platform => SensorsPlatform.instance;

  /// Returns a broadcast stream of events from the device accelerometer at the
  /// given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.accelerometerEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the accelerometer is available.
  @override
  Future<bool> get isAccelerometerAvailable async {
    return await _platform.isAccelerometerAvailable;
  }

  /// Returns a broadcast stream of events from the device gyroscope at the
  /// given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.gyroscopeEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the gyroscope is available.
  @override
  Future<bool> get isGyroscopeAvailable async {
    return await _platform.isGyroscopeAvailable;
  }

  /// Returns a broadcast stream of events from the device accelerometer with
  /// gravity removed at the given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.userAccelerometerEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the user accelerometer is
  /// available.
  @override
  Future<bool> get isUserAccelerometerAvailable async {
    return await _platform.isUserAccelerometerAvailable;
  }

  /// Returns a broadcast stream of events from the device gravity sensor at the
  /// given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<GravityEvent> gravityEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.gravityEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the gravity sensor is
  /// available.
  @override
  Future<bool> get isGravityAvailable async {
    return await _platform.isGravityAvailable;
  }

  /// Returns a broadcast stream of events from the device magnetometer at the
  /// given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.magnetometerEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the magnetometer is available.
  @override
  Future<bool> get isMagnetometerAvailable async {
    return await _platform.isMagnetometerAvailable;
  }

  /// Returns a broadcast stream of events from the device orientation sensor at
  /// the given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<OrientationEvent> orientationEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.orientationEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the orientation sensor is
  /// available.
  @override
  Future<bool> get isOrientationSensorAvailable async {
    return await _platform.isOrientationSensorAvailable;
  }

  /// Returns a broadcast stream of events from the device absolute orientation
  /// sensor at the given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<AbsoluteOrientationEvent> absoluteOrientationEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.absoluteOrientationEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the absolute orientation sensor
  /// is available.
  @override
  Future<bool> get isAbsoluteOrientationSensorAvailable async {
    return await _platform.isAbsoluteOrientationSensorAvailable;
  }

  /// Returns a broadcast stream of events from the device rotation quaternion
  /// sensor at the given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<OrientationQuaternionEvent> orientationQuaternionEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.orientationQuaternionEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the rotation quaternion sensor
  /// is available.
  @override
  Future<bool> get isOrientationQuaternionSensorAvailable async {
    return await _platform.isOrientationQuaternionSensorAvailable;
  }

  /// Returns a broadcast stream of events from the device absolute rotation
  /// quaternion sensor at the given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<AbsoluteOrientationQuaternionEvent> absoluteOrientationQuaternionEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.absoluteOrientationQuaternionEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the absolute rotation
  /// quaternion sensor is available.
  @override
  Future<bool> get isAbsoluteOrientationQuaternionSensorAvailable async {
    return await _platform.isAbsoluteOrientationQuaternionSensorAvailable;
  }

  /// Returns a broadcast stream of events from the device game rotation
  /// matrix sensor at the given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<RotationMatrixEvent> rotationMatrixEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.rotationMatrixEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the rotation matrix sensor is
  /// available.
  @override
  Future<bool> get isRotationMatrixSensorAvailable async {
    return await _platform.isRotationMatrixSensorAvailable;
  }

  /// Returns a broadcast stream of events from the device absolute rotation
  /// matrix sensor at the given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<AbsoluteRotationMatrixEvent> absoluteRotationMatrixEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.absoluteRotationMatrixEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a boolean value indicating whether the absolute rotation matrix
  /// sensor is available.
  @override
  Future<bool> get isAbsoluteRotationMatrixSensorAvailable async {
    return await _platform.isAbsoluteRotationMatrixSensorAvailable;
  }
}
