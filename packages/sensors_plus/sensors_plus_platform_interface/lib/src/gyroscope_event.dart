// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';

import 'accuracy.dart';

/// Discrete reading from a gyroscope. Gyroscopes measure the rate or rotation of
/// the device in 3D space.
class GyroscopeEvent {
  /// Constructs an instance with the given [x], [y], and [z] values.
  GyroscopeEvent(double x, double y, double z, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3(x, y, z),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a list of 3 doubles [gyroscopeList].
  GyroscopeEvent.fromList(List<double> gyroscopeList, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3.array(gyroscopeList),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a [vector].
  /// The vector is copied.
  GyroscopeEvent.fromVector3(Vector3 vector, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3.copy(vector),
        timestamp = timestamp ?? DateTime.now();

  /// Vector describing the rotation rate of the device in rad/s.
  /// 
  /// This uses a right-handed coordinate system. So when the device is held
  /// upright and facing the user axis are:
  /// 
  /// x(pitch) - the top of the device will tilt towards or away from the
  /// user as this value changes.
  /// 
  /// y(yaw) - the lengthwise edge of the device will rotate towards or away from
  /// the user as this value changes.
  /// 
  /// z(roll) - the face of the device should remain facing
  /// forward, but the orientation will change from portrait to landscape and so
  final Vector3 vector;

  /// Rate of rotation around the x axis measured in rad/s.
  ///
  /// When the device is held upright, this can also be thought of as describing
  /// "pitch". The top of the device will tilt towards or away from the
  /// user as this value changes.
  double get x => vector.x;

  /// Rate of rotation around the y axis measured in rad/s.
  ///
  /// When the device is held upright, this can also be thought of as describing
  /// "yaw". The lengthwise edge of the device will rotate towards or away from
  /// the user as this value changes.
  double get y => vector.y;

  /// Rate of rotation around the z axis measured in rad/s.
  ///
  /// When the device is held upright, this can also be thought of as describing
  /// "roll". When this changes the face of the device should remain facing
  /// forward, but the orientation will change from portrait to landscape and so
  /// on.
  double get z => vector.z;

  /// Timestamp when this event occurred.
  final DateTime timestamp;

  /// The accuracy of this reading.
  final Accuracy accuracy;

  @override
  String toString() => '[GyroscopeEvent (x: $x, y: $y, z: $z, timestamp: $timestamp, accuracy: ${accuracy.name})]';
}
