// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';

import 'accuracy.dart';
import 'accelerometer_event.dart';

/// Like [AccelerometerEvent], this is a discrete reading from an accelerometer
/// and measures the velocity of the device. However, unlike
/// [AccelerometerEvent], this event does not include the effects of gravity.
class UserAccelerometerEvent {
  /// Constructs an instance with the given [x], [y], and [z] values.
  UserAccelerometerEvent(double x, double y, double z,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3(x, y, z),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a list of 3 doubles [accelerometerList].
  UserAccelerometerEvent.fromList(List<double> accelerometerList,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3.array(accelerometerList),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a [vector].
  /// The vector is copied.
  UserAccelerometerEvent.fromVector3(Vector3 vector,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3.copy(vector),
        timestamp = timestamp ?? DateTime.now();

  /// Vector describing the acceleration of the device in m/s^2 (excluding
  /// gravity).
  ///
  /// This uses a right-handed coordinate system. So when the device is held
  /// upright and facing the user axis are:
  /// x - positive along the right side of the device when it is facing the user
  /// y - positive along the top of the device when it is facing the user
  /// z - positive coming out of the screen when it is facing the user
  final Vector3 vector;

  /// Acceleration force along the x axis (excluding gravity) measured in m/s^2.
  ///
  /// When the device is held upright facing the user, positive values mean the
  /// device is moving to the right and negative mean it is moving to the left.
  double get x => vector.x;

  /// Acceleration force along the y axis (excluding gravity) measured in m/s^2.
  ///
  /// When the device is held upright facing the user, positive values mean the
  /// device is moving towards the sky and negative mean it is moving towards
  /// the ground.
  double get y => vector.y;

  /// Acceleration force along the z axis (excluding gravity) measured in m/s^2.
  ///
  /// This uses a right-handed coordinate system. So when the device is held
  /// upright and facing the user, positive values mean the device is moving
  /// towards the user and negative mean it is moving away from them.
  double get z => vector.z;

  /// Timestamp when this event occurred.
  final DateTime timestamp;

  /// The accuracy of this reading.
  final Accuracy accuracy;

  @override
  String toString() => '[UserAccelerometerEvent (x: $x, y: $y, z: $z, timestamp: $timestamp, accuracy: ${accuracy.name})]';
}
