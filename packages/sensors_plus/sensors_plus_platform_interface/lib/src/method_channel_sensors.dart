// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

/// A method channel -based implementation of the SensorsPlatform interface.
class MethodChannelSensors extends SensorsPlatform {
  static const MethodChannel _methodChannel = MethodChannel('dev.fluttercommunity.plus/sensors/method');

  static const EventChannel _accelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/accelerometer');

  static const EventChannel _userAccelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/user_accel');

  static const EventChannel _gravityEventChannel = EventChannel('dev.fluttercommunity.plus/sensors/gravity');

  static const EventChannel _gyroscopeEventChannel = EventChannel('dev.fluttercommunity.plus/sensors/gyroscope');

  static const EventChannel _magnetometerEventChannel = EventChannel('dev.fluttercommunity.plus/sensors/magnetometer');

  static const EventChannel _absoluteOrientationEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/absolute_orientation');

  static const EventChannel _orientationEventChannel = EventChannel('dev.fluttercommunity.plus/sensors/orientation');

  static const EventChannel _absoluteOrientationQuaternionEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/absolute_orientation_quaternion');

  static const EventChannel _orientationQuaternionEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/orientation_quaternion');

  static const EventChannel _absoluteRotationMatrixEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/absolute_rotation_matrix');

  static const EventChannel _rotationMatrixEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/rotation_matrix');

  final logger = Logger('MethodChannelSensors');
  Stream<AccelerometerEvent>? _accelerometerEvents;
  Stream<GyroscopeEvent>? _gyroscopeEvents;
  Stream<UserAccelerometerEvent>? _userAccelerometerEvents;
  Stream<MagnetometerEvent>? _magnetometerEvents;
  Stream<GravityEvent>? _gravityEvents;
  Stream<AbsoluteOrientationEvent>? _absoluteOrientationEvents;
  Stream<OrientationEvent>? _orientationEvents;
  Stream<AbsoluteOrientationQuaternionEvent>? _absoluteOrientationQuaternionEvents;
  Stream<OrientationQuaternionEvent>? _orientationQuaternionEvents;
  Stream<AbsoluteRotationMatrixEvent>? _absoluteRotationMatrixEvents;
  Stream<RotationMatrixEvent>? _rotationMatrixEvents;

  /// Returns a broadcast stream of events from the device accelerometer at the
  /// given sampling frequency.
  @override
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setAccelerometerSamplingPeriod', microseconds);
    _accelerometerEvents ??= _accelerometerEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[3].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return AccelerometerEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(),
          DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
    });
    return _accelerometerEvents!;
  }

  /// Returns a boolean value indicating whether the accelerometer is available.
  @override
  Future<bool> get isAccelerometerAvailable async {
    return await _methodChannel.invokeMethod('isAccelerometerAvailable');
  }

  /// Returns a broadcast stream of events from the device gyroscope at the
  /// given sampling frequency.
  @override
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setGyroscopeSamplingPeriod', microseconds);
    _gyroscopeEvents ??= _gyroscopeEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[3].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return GyroscopeEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(),
          DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
    });
    return _gyroscopeEvents!;
  }

  /// Returns a boolean value indicating whether the gyroscope is available.
  @override
  Future<bool> get isGyroscopeAvailable async {
    return await _methodChannel.invokeMethod('isGyroscopeAvailable');
  }

  /// Returns a broadcast stream of events from the device accelerometer with
  /// gravity removed at the given sampling frequency.
  @override
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setUserAccelerometerSamplingPeriod', microseconds);
    _userAccelerometerEvents ??= _userAccelerometerEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[3].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return UserAccelerometerEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(),
          DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
    });
    return _userAccelerometerEvents!;
  }

  /// Returns a boolean value indicating whether the user accelerometer is
  /// available.
  @override
  Future<bool> get isUserAccelerometerAvailable async {
    return await _methodChannel.invokeMethod('isUserAccelerometerAvailable');
  }

  /// Returns a broadcast stream of events from the device gravity sensor at the
  /// given sampling frequency.
  @override
  Stream<GravityEvent> gravityEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setGravitySamplingPeriod', microseconds);
    _gravityEvents ??= _gravityEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[3].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return GravityEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(),
          DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
    });
    return _gravityEvents!;
  }

  /// Returns a boolean value indicating whether the gravity sensor is
  /// available.
  @override
  Future<bool> get isGravityAvailable async {
    return await _methodChannel.invokeMethod('isGravityAvailable');
  }

  /// Returns a broadcast stream of events from the device magnetometer at the
  /// given sampling frequency.
  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setMagnetometerSamplingPeriod', microseconds);
    _magnetometerEvents ??= _magnetometerEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[3].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return MagnetometerEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(),
          DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
    });
    return _magnetometerEvents!;
  }

  /// Returns a boolean value indicating whether the magnetometer is available.
  @override
  Future<bool> get isMagnetometerAvailable async {
    return await _methodChannel.invokeMethod('isMagnetometerAvailable');
  }

  /// Returns a broadcast stream of events from the device absolute orientation
  /// sensor at the given sampling frequency.
  @override
  Stream<AbsoluteOrientationEvent> absoluteOrientationEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setAbsoluteOrientationSamplingPeriod', microseconds);
    _absoluteOrientationEvents ??= _absoluteOrientationEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[3].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return AbsoluteOrientationEvent(
        list[0].toDouble(),
        list[1].toDouble(),
        list[2].toDouble(),
        DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()),
        accuracy,
      );
    });
    return _absoluteOrientationEvents!;
  }

  /// Returns a boolean value indicating whether the absolute orientation sensor
  /// is available.
  @override
  Future<bool> get isAbsoluteOrientationSensorAvailable async {
    return await _methodChannel.invokeMethod('isAbsoluteOrientationAvailable');
  }

  /// Returns a broadcast stream of events from the device orientation sensor at
  /// the given sampling frequency.
  @override
  Stream<OrientationEvent> orientationEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setOrientationSamplingPeriod', microseconds);
    _orientationEvents ??= _orientationEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[3].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return OrientationEvent(
        list[0].toDouble(),
        list[1].toDouble(),
        list[2].toDouble(),
        DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()),
        accuracy,
      );
    });
    return _orientationEvents!;
  }

  /// Returns a boolean value indicating whether the orientation sensor is
  /// available.
  @override
  Future<bool> get isOrientationSensorAvailable async {
    return await _methodChannel.invokeMethod('isOrientationAvailable');
  }

  /// Returns a broadcast stream of events from the device absolute rotation
  /// quaternion sensor at the given sampling frequency.
  @override
  Stream<AbsoluteOrientationQuaternionEvent> absoluteOrientationQuaternionEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    _methodChannel.invokeMethod('setAbsoluteOrientationQuaternionSamplingPeriod', samplingPeriod.inMicroseconds);
    _absoluteOrientationQuaternionEvents ??=
        _absoluteOrientationQuaternionEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[4].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return AbsoluteOrientationQuaternionEvent(
        list[0].toDouble(),
        list[1].toDouble(),
        list[2].toDouble(),
        list[3].toDouble(),
        DateTime.fromMicrosecondsSinceEpoch(list[5].toInt()),
        accuracy,
      );
    });
    return _absoluteOrientationQuaternionEvents!;
  }

  /// Returns a boolean value indicating whether the absolute rotation
  /// quaternion sensor is available.
  @override
  Future<bool> get isAbsoluteOrientationQuaternionSensorAvailable async {
    return await _methodChannel.invokeMethod('isAbsoluteOrientationQuaternionAvailable');
  }

  /// Returns a broadcast stream of events from the device rotation quaternion
  /// sensor at the given sampling frequency.
  @override
  Stream<OrientationQuaternionEvent> orientationQuaternionEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    _methodChannel.invokeMethod('setOrientationQuaternionSamplingPeriod', samplingPeriod.inMicroseconds);
    _orientationQuaternionEvents ??= _orientationQuaternionEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[4].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return OrientationQuaternionEvent(
        list[0].toDouble(),
        list[1].toDouble(),
        list[2].toDouble(),
        list[3].toDouble(),
        DateTime.fromMicrosecondsSinceEpoch(list[5].toInt()),
        accuracy,
      );
    });
    return _orientationQuaternionEvents!;
  }

  /// Returns a boolean value indicating whether the rotation quaternion sensor
  /// is available.
  @override
  Future<bool> get isOrientationQuaternionSensorAvailable async {
    return await _methodChannel.invokeMethod('isOrientationQuaternionAvailable');
  }

  /// Returns a broadcast stream of events from the device absolute rotation
  /// matrix sensor at the given sampling frequency.
  @override
  Stream<AbsoluteRotationMatrixEvent> absoluteRotationMatrixEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    _methodChannel.invokeMethod('setAbsoluteRotationMatrixSamplingPeriod', samplingPeriod.inMicroseconds);
    _absoluteRotationMatrixEvents ??= _absoluteRotationMatrixEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[9].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return AbsoluteRotationMatrixEvent(
        list[0].toDouble(),
        list[1].toDouble(),
        list[2].toDouble(),
        list[3].toDouble(),
        list[4].toDouble(),
        list[5].toDouble(),
        list[6].toDouble(),
        list[7].toDouble(),
        list[8].toDouble(),
        DateTime.fromMicrosecondsSinceEpoch(list[10].toInt()),
        accuracy,
      );
    });
    return _absoluteRotationMatrixEvents!;
  }

  /// Returns a boolean value indicating whether the absolute rotation matrix
  /// sensor is available.
  @override
  Future<bool> get isAbsoluteRotationMatrixSensorAvailable async {
    return await _methodChannel.invokeMethod('isAbsoluteRotationMatrixAvailable');
  }

  /// Returns a broadcast stream of events from the device rotation matrix
  /// sensor at the given sampling frequency.
  @override
  Stream<RotationMatrixEvent> rotationMatrixEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    _methodChannel.invokeMethod('setRotationMatrixSamplingPeriod', samplingPeriod.inMicroseconds);
    _rotationMatrixEvents ??= _rotationMatrixEventChannel.receiveBroadcastStream().map((dynamic event) {
      final List<num> list = event.cast<num>();
      Accuracy accuracy = Accuracy.unknown;
      switch (list[9].toInt()) {
        case 0:
          accuracy = Accuracy.uncalibrated;
          break;
        case 1:
          accuracy = Accuracy.low;
          break;
        case 2:
          accuracy = Accuracy.medium;
          break;
        case 3:
          accuracy = Accuracy.high;
          break;
      }
      return RotationMatrixEvent(
        list[0].toDouble(),
        list[1].toDouble(),
        list[2].toDouble(),
        list[3].toDouble(),
        list[4].toDouble(),
        list[5].toDouble(),
        list[6].toDouble(),
        list[7].toDouble(),
        list[8].toDouble(),
        DateTime.fromMicrosecondsSinceEpoch(list[10].toInt()),
        accuracy,
      );
    });
    return _rotationMatrixEvents!;
  }

  /// Returns a boolean value indicating whether the rotation matrix sensor is
  /// available.
  @override
  Future<bool> get isRotationMatrixSensorAvailable async {
    return await _methodChannel.invokeMethod('isRotationMatrixAvailable');
  }
}
