// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sensors_plus_platform_interface/src/method_channel_sensors.dart';
import 'package:sensors_plus_platform_interface/src/sensor_interval.dart';

import 'src/accelerometer_event.dart';
import 'src/gyroscope_event.dart';
import 'src/magnetometer_event.dart';
import 'src/user_accelerometer_event.dart';
import 'src/gravity_event.dart';
import 'src/absolute_orientation_event.dart';
import 'src/orientation_event.dart';
import 'src/absolute_orientation_quaternion_event.dart';
import 'src/orientation_quaternion_event.dart';
import 'src/absolute_rotation_matrix_event.dart';
import 'src/rotation_matrix_event.dart';

export 'src/accelerometer_event.dart';
export 'src/gyroscope_event.dart';
export 'src/magnetometer_event.dart';
export 'src/user_accelerometer_event.dart';
export 'src/gravity_event.dart';
export 'src/absolute_orientation_event.dart';
export 'src/orientation_event.dart';
export 'src/absolute_orientation_quaternion_event.dart';
export 'src/orientation_quaternion_event.dart';
export 'src/absolute_rotation_matrix_event.dart';
export 'src/rotation_matrix_event.dart';
export 'src/sensor_interval.dart';
export 'src/accuracy.dart';

/// The common platform interface for sensors.
abstract class SensorsPlatform extends PlatformInterface {
  /// Constructs a SensorsPlatform.
  SensorsPlatform() : super(token: _token);

  static final Object _token = Object();

  static SensorsPlatform _instance = MethodChannelSensors();

  /// The default instance of [SensorsPlatform] to use.
  ///
  /// Defaults to [MethodChannelSensors].
  static SensorsPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SensorsPlatform] when they register themselves.
  static set instance(SensorsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// A broadcast stream of events from the device accelerometer.
  @nonVirtual
  @Deprecated('Use accelerometerEventStream() instead.')
  Stream<AccelerometerEvent> get accelerometerEvents {
    return accelerometerEventStream();
  }

  /// A broadcast stream of events from the device gyroscope.
  @nonVirtual
  @Deprecated('Use gyroscopeEventStream() instead.')
  Stream<GyroscopeEvent> get gyroscopeEvents {
    return gyroscopeEventStream();
  }

  /// Events from the device accelerometer with gravity removed.
  @nonVirtual
  @Deprecated('Use userAccelerometerEventStream() instead.')
  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    return userAccelerometerEventStream();
  }

  /// A broadcast stream of events from the device magnetometer.
  @nonVirtual
  @Deprecated('Use magnetometerEventStream() instead.')
  Stream<MagnetometerEvent> get magnetometerEvents {
    return magnetometerEventStream();
  }

  /// Returns a broadcast stream of events from the device accelerometer at the
  /// given sampling frequency.
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('listenToAccelerometerEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the accelerometer is available.
  Future<bool> get isAccelerometerAvailable {
    throw UnimplementedError('isAccelerometerAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device gyroscope at the
  /// given sampling frequency.
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('gyroscopeEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the gyroscope is available.
  Future<bool> get isGyroscopeAvailable {
    throw UnimplementedError('isGyroscopeAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device accelerometer with
  /// gravity removed at the given sampling frequency.
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('userAccelerometerEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the user accelerometer is
  /// available.
  Future<bool> get isUserAccelerometerAvailable {
    throw UnimplementedError('isUserAccelerometerAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device gravity sensor at the
  /// given sampling frequency.
  Stream<GravityEvent> gravityEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('gravityEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the gravity sensor is
  /// available.
  Future<bool> get isGravityAvailable {
    throw UnimplementedError('isGravityAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device magnetometer at the
  /// given sampling frequency.
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('magnetometerEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the magnetometer is available.
  Future<bool> get isMagnetometerAvailable {
    throw UnimplementedError('isMagnetometerAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device absolute orientation
  /// sensor at the given sampling frequency.
  Stream<AbsoluteOrientationEvent> absoluteOrientationEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('absoluteOrientationEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the absolute orientation sensor
  /// is available.
  Future<bool> get isAbsoluteOrientationSensorAvailable {
    throw UnimplementedError('isAbsoluteOrientationSensorAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device orientation sensor at
  /// the given sampling frequency.
  Stream<OrientationEvent> orientationEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('orientationEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the orientation sensor is
  /// available.
  Future<bool> get isOrientationSensorAvailable {
    throw UnimplementedError('isOrientationSensorAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device absolute rotation
  /// quaternion sensor at the given sampling frequency.
  Stream<AbsoluteOrientationQuaternionEvent> absoluteOrientationQuaternionEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('absoluteOrientationQuaternionEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the absolute rotation
  /// quaternion sensor is available.
  Future<bool> get isAbsoluteOrientationQuaternionSensorAvailable {
    throw UnimplementedError('isAbsoluteOrientationQuaternionSensorAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device rotation quaternion
  /// sensor at the given sampling frequency.
  Stream<OrientationQuaternionEvent> orientationQuaternionEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('orientationQuaternionEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the rotation quaternion sensor
  /// is available.
  Future<bool> get isOrientationQuaternionSensorAvailable {
    throw UnimplementedError('isOrientationQuaternionSensorAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device absolute rotation
  /// matrix sensor at the given sampling frequency.
  Stream<AbsoluteRotationMatrixEvent> absoluteRotationMatrixEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('absoluteRotationMatrixEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the absolute rotation matrix
  /// sensor is available.
  Future<bool> get isAbsoluteRotationMatrixSensorAvailable {
    throw UnimplementedError('isAbsoluteRotationMatrixSensorAvailable has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device rotation matrix
  /// sensor at the given sampling frequency.
  Stream<RotationMatrixEvent> rotationMatrixEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('rotationMatrixEvents has not been implemented.');
  }

  /// Returns a boolean value indicating whether the rotation matrix sensor is
  /// available.
  Future<bool> get isRotationMatrixSensorAvailable {
    throw UnimplementedError('isRotationMatrixSensorAvailable has not been implemented.');
  }
}
