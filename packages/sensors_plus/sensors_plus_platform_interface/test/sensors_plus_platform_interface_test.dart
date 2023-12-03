// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' show TestDefaultBinaryMessengerBinding, TestWidgetsFlutterBinding;
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';
import 'package:sensors_plus_platform_interface/src/method_channel_sensors.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

final MethodChannelSensors methodChannel = MethodChannelSensors();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('accelerometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/accelerometer';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[1.0, 2.0, 3.0, -1.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setAccelerometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.accelerometerEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.accuracy, Accuracy.unknown);
    expect(event.timestamp, timestamp);
  });

  test('isAccelerometerAvailable are working', () async {
    _initializeFakeMethodChannel('isAccelerometerAvailable', true);

    final isAvailable = await methodChannel.isAccelerometerAvailable;

    expect(isAvailable, true);
  });

  test('gyroscopeEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/gyroscope';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[3.0, 4.0, 5.0, 0.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setGyroscopeSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.gyroscopeEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.accuracy, Accuracy.uncalibrated);
    expect(event.timestamp, timestamp);
  });

  test('isGyroscopeAvailable are working', () async {
    _initializeFakeMethodChannel('isGyroscopeAvailable', true);

    final isAvailable = await methodChannel.isGyroscopeAvailable;

    expect(isAvailable, true);
  });

  test('userAccelerometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/user_accel';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[6.0, 7.0, 8.0, 1.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setUserAccelerometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.userAccelerometerEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.accuracy, Accuracy.low);
    expect(event.timestamp, timestamp);
  });

  test('isUserAccelerometerAvailable are working', () async {
    _initializeFakeMethodChannel('isUserAccelerometerAvailable', true);

    final isAvailable = await methodChannel.isUserAccelerometerAvailable;

    expect(isAvailable, true);
  });

  test('gravityEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/gravity';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[9.0, 10.0, 11.0, 2.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setGravitySamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.gravityEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.accuracy, Accuracy.medium);
    expect(event.timestamp, timestamp);
  });

  test('isGravityAvailable are working', () async {
    _initializeFakeMethodChannel('isGravityAvailable', true);

    final isAvailable = await methodChannel.isGravityAvailable;

    expect(isAvailable, true);
  });

  test('magnetometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/magnetometer';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[9.0, 10.0, 11.0, 2.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setMagnetometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.magnetometerEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.accuracy, Accuracy.medium);
    expect(event.timestamp, timestamp);
  });

  test('isMagnetometerAvailable are working', () async {
    _initializeFakeMethodChannel('isMagnetometerAvailable', true);

    final isAvailable = await methodChannel.isMagnetometerAvailable;

    expect(isAvailable, true);
  });

  test('absoluteOrientationEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/absolute_orientation';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[9.0, 10.0, 11.0, 2.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setAbsoluteOrientationSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.absoluteOrientationEventStream().first;

    expect(event.pitch, sensorData[0]);
    expect(event.roll, sensorData[1]);
    expect(event.yaw, sensorData[2]);
    expect(event.accuracy, Accuracy.medium);
    expect(event.timestamp, timestamp);
  });

  test('isAbsoluteOrientationAvailable are working', () async {
    _initializeFakeMethodChannel('isAbsoluteOrientationAvailable', true);

    final isAvailable = await methodChannel.isAbsoluteOrientationSensorAvailable;

    expect(isAvailable, true);
  });

  test('orientationEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/orientation';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[9.0, 10.0, 11.0, 2.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setOrientationSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.orientationEventStream().first;

    expect(event.pitch, sensorData[0]);
    expect(event.roll, sensorData[1]);
    expect(event.yaw, sensorData[2]);
    expect(event.accuracy, Accuracy.medium);
    expect(event.timestamp, timestamp);
  });

  test('isOrientationAvailable are working', () async {
    _initializeFakeMethodChannel('isOrientationAvailable', true);

    final isAvailable = await methodChannel.isOrientationSensorAvailable;

    expect(isAvailable, true);
  });

  test('absoluteOrientationQuaternionEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/absolute_orientation_quaternion';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[9.0, 10.0, 11.0, 12.0, 2.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setAbsoluteOrientationQuaternionSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.absoluteOrientationQuaternionEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.w, sensorData[3]);
    expect(event.accuracy, Accuracy.medium);
    expect(event.timestamp, timestamp);
  });

  test('isAbsoluteOrientationQuaternionAvailable are working', () async {
    _initializeFakeMethodChannel('isAbsoluteOrientationQuaternionAvailable', true);

    final isAvailable = await methodChannel.isAbsoluteOrientationQuaternionSensorAvailable;

    expect(isAvailable, true);
  });

  test('orientationQuaternionEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/orientation_quaternion';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[9.0, 10.0, 11.0, 12.0, 2.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setOrientationQuaternionSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.orientationQuaternionEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.w, sensorData[3]);
    expect(event.accuracy, Accuracy.medium);
    expect(event.timestamp, timestamp);
  });

  test('isOrientationQuaternionAvailable are working', () async {
    _initializeFakeMethodChannel('isOrientationQuaternionAvailable', true);

    final isAvailable = await methodChannel.isOrientationQuaternionSensorAvailable;

    expect(isAvailable, true);
  });

  test('absoluteRotationMatrixEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/absolute_rotation_matrix';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[
      9.0,
      10.0,
      11.0,
      12.0,
      13.0,
      14.0,
      15.0,
      16.0,
      17.0,
      1.0,
      timestamp.microsecondsSinceEpoch.toDouble()
    ];
    _initializeFakeMethodChannel('setAbsoluteRotationMatrixSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.absoluteRotationMatrixEventStream().first;

    expect(event.matrix, Matrix3.fromList(sensorData.sublist(0, 9)));
    expect(event.accuracy, Accuracy.low);
    expect(event.timestamp, timestamp);
  });

  test('isAbsoluteRotationMatrixAvailable are working', () async {
    _initializeFakeMethodChannel('isAbsoluteRotationMatrixAvailable', true);

    final isAvailable = await methodChannel.isAbsoluteRotationMatrixSensorAvailable;

    expect(isAvailable, true);
  });

  test('rotationMatrixEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/rotation_matrix';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[
      9.0,
      10.0,
      11.0,
      12.0,
      13.0,
      14.0,
      15.0,
      16.0,
      17.0,
      1.0,
      timestamp.microsecondsSinceEpoch.toDouble()
    ];
    _initializeFakeMethodChannel('setRotationMatrixSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await methodChannel.rotationMatrixEventStream().first;

    expect(event.matrix, Matrix3.fromList(sensorData.sublist(0, 9)));
    expect(event.accuracy, Accuracy.low);
    expect(event.timestamp, timestamp);
  });

  test('isRotationMatrixAvailable are working', () async {
    _initializeFakeMethodChannel('isRotationMatrixAvailable', true);

    final isAvailable = await methodChannel.isRotationMatrixSensorAvailable;

    expect(isAvailable, true);
  });
}

void _initializeFakeMethodChannel(String methodName, [dynamic returnValue]) {
  const standardMethod = StandardMethodCodec();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('dev.fluttercommunity.plus/sensors/method', (ByteData? message) async {
    final methodCall = standardMethod.decodeMethodCall(message);
    if (methodCall.method == methodName) {
      return standardMethod.encodeSuccessEnvelope(returnValue);
    } else {
      fail('Expected $methodName');
    }
  });
}

void _initializeFakeSensorChannel(String channelName, List<double> sensorData) {
  const standardMethod = StandardMethodCodec();

  void emitEvent(ByteData? event) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channelName,
      event,
      (ByteData? reply) {},
    );
  }

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(channelName,
      (ByteData? message) async {
    final methodCall = standardMethod.decodeMethodCall(message);
    if (methodCall.method == 'listen') {
      emitEvent(standardMethod.encodeSuccessEnvelope(sensorData));
      emitEvent(null);
      return standardMethod.encodeSuccessEnvelope(null);
    } else if (methodCall.method == 'cancel') {
      return standardMethod.encodeSuccessEnvelope(null);
    } else {
      fail('Expected listen or cancel');
    }
  });
}
