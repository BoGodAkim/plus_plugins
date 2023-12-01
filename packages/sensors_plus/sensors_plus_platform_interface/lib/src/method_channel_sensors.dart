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

  static const EventChannel _gyroscopeEventChannel = EventChannel('dev.fluttercommunity.plus/sensors/gyroscope');

  static const EventChannel _magnetometerEventChannel = EventChannel('dev.fluttercommunity.plus/sensors/magnetometer');

  final logger = Logger('MethodChannelSensors');
  Stream<AccelerometerEvent>? _accelerometerEvents;
  Stream<GyroscopeEvent>? _gyroscopeEvents;
  Stream<UserAccelerometerEvent>? _userAccelerometerEvents;
  Stream<MagnetometerEvent>? _magnetometerEvents;

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
      return AccelerometerEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(), DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
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
      return GyroscopeEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(), DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
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
      return UserAccelerometerEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(), DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
    });
    return _userAccelerometerEvents!;
  }

  /// Returns a boolean value indicating whether the user accelerometer is
  /// available.
  @override
  Future<bool> get isUserAccelerometerAvailable async {
    return await _methodChannel.invokeMethod('isUserAccelerometerAvailable');
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
      return MagnetometerEvent(list[0].toDouble(), list[1].toDouble(), list[2].toDouble(), DateTime.fromMicrosecondsSinceEpoch(list[4].toInt()), accuracy);
    });
    return _magnetometerEvents!;
  }

  /// Returns a boolean value indicating whether the magnetometer is available.
  @override
  Future<bool> get isMagnetometerAvailable async {
    return await _methodChannel.invokeMethod('isMagnetometerAvailable');
  }
}
