// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart'
    show TestDefaultBinaryMessengerBinding, TestWidgetsFlutterBinding;
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';
import 'package:sensors_plus_platform_interface/src/method_channel_sensors.dart';
import 'package:test/test.dart';

final MethodChannelSensors methodChannel = MethodChannelSensors();

/// Returns a broadcast stream of events from the device accelerometer at the
/// given sampling frequency.
@override
Stream<AccelerometerEvent> accelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return methodChannel.accelerometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device gyroscope at the
/// given sampling frequency.
@override
Stream<GyroscopeEvent> gyroscopeEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return methodChannel.gyroscopeEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device accelerometer with
/// gravity removed at the given sampling frequency.
@override
Stream<UserAccelerometerEvent> userAccelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return methodChannel.userAccelerometerEventStream(
      samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device magnetometer at the
/// given sampling frequency.
@override
Stream<MagnetometerEvent> magnetometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return methodChannel.magnetometerEventStream(samplingPeriod: samplingPeriod);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('accelerometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/accelerometer';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[1.0, 2.0, 3.0, -1.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setAccelerometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await accelerometerEventStream().first;

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

    final event = await gyroscopeEventStream().first;

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

    final event = await userAccelerometerEventStream().first;

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

  test('magnetometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/magnetometer';
    final DateTime timestamp = DateTime.now();
    final sensorData = <double>[9.0, 10.0, 11.0, 2.0, timestamp.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setMagnetometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await magnetometerEventStream().first;

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
}

void _initializeFakeMethodChannel(String methodName, [dynamic returnValue]) {
  const standardMethod = StandardMethodCodec();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('dev.fluttercommunity.plus/sensors/method',
          (ByteData? message) async {
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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
      channelName,
      event,
      (ByteData? reply) {},
    );
  }

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler(channelName, (ByteData? message) async {
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
