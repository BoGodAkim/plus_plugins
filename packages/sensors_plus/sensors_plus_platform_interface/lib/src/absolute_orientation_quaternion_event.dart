// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';

import 'accuracy.dart';
import 'orientation_quaternion_event.dart';

/// This is composite sensor which uses the accelerometer, gyroscope, and
/// magnetometer to compute the device's absolute rotation quaternion.
/// [AbsoluteOrientationQuaternionEvent] is more accurate than [OrientationQuaternionEvent],
/// but less energy efficient.
/// AbsoluteOrientationQuaternion is a unit quaternion representing the device's rotation
/// relative to the world's coordinate system which is defined as a direct orthonormal basis,
/// where:
/// - X is defined as the vector product Y.Z (It is tangential to the ground at
/// the device's current location and roughly points East).
/// - Y is tangential to the ground at the device's current location and points
/// towards the magnetic North Pole.
/// - Z points towards the sky and is perpendicular to the ground.
class AbsoluteOrientationQuaternionEvent {
  /// Constructs an instance with the given [x], [y], [z], and [w] values.
  AbsoluteOrientationQuaternionEvent(double x, double y, double z, double w,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : quaternion = Quaternion(x, y, z, w),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a list of 4 doubles [quaternionList].
  AbsoluteOrientationQuaternionEvent.fromList(List<double> quaternionList,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : quaternion = Quaternion(quaternionList[0], quaternionList[1], quaternionList[2], quaternionList[3]),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a [quaternion].
  /// The quaternion is copied.
  AbsoluteOrientationQuaternionEvent.fromQuaternion(Quaternion quaternion,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : quaternion = Quaternion.copy(quaternion),
        timestamp = timestamp ?? DateTime.now();

  /// AbsoluteOrientationQuaternion is a unit quaternion representing the device's rotation
  /// relative to the world's coordinate system which is defined as a direct orthonormal basis,
  /// where:
  /// - X is defined as the vector product Y.Z (It is tangential to the ground at
  /// the device's current location and roughly points East).
  /// - Y is tangential to the ground at the device's current location and points
  /// towards the magnetic North Pole.
  /// - Z points towards the sky and is perpendicular to the ground.
  ///   
  /// A unit quaternion represents a rotation of theta radians about the unit vector {x,y,z},
  /// and {q.x, q.y, q.z, q.w} satisfies the following:
  /// q.x = x * sin(theta / 2)
  /// q.y = y * sin(theta / 2)
  /// q.z = z * sin(theta / 2)
  /// q.w = cos(theta / 2)
  final Quaternion quaternion;

  /// X component of the quaternion.
  /// A unit quaternion represents a rotation of theta radians about the unit vector {x,y,z},
  /// and {q.x, q.y, q.z, q.w} satisfies the following:
  /// q.x = x * sin(theta / 2)
  /// q.y = y * sin(theta / 2)
  /// q.z = z * sin(theta / 2)
  /// q.w = cos(theta / 2)
  double get x => quaternion.x;

  /// Y component of the quaternion.
  /// A unit quaternion represents a rotation of theta radians about the unit vector {x,y,z},
  /// and {q.x, q.y, q.z, q.w} satisfies the following:
  /// q.x = x * sin(theta / 2)
  /// q.y = y * sin(theta / 2)
  /// q.z = z * sin(theta / 2)
  /// q.w = cos(theta / 2)
  double get y => quaternion.y;

  /// Z component of the quaternion.
  /// A unit quaternion represents a rotation of theta radians about the unit vector {x,y,z},
  /// and {q.x, q.y, q.z, q.w} satisfies the following:
  /// q.x = x * sin(theta / 2)
  /// q.y = y * sin(theta / 2)
  /// q.z = z * sin(theta / 2)
  /// q.w = cos(theta / 2)
  double get z => quaternion.z;

  /// W component of the quaternion.
  /// A unit quaternion represents a rotation of theta radians about the unit vector {x,y,z},
  /// and {q.x, q.y, q.z, q.w} satisfies the following:
  /// q.x = x * sin(theta / 2)
  /// q.y = y * sin(theta / 2)
  /// q.z = z * sin(theta / 2)
  /// q.w = cos(theta / 2)
  double get w => quaternion.w;

  /// Timestamp when this event occurred.
  final DateTime timestamp;

  /// The accuracy of this reading.
  final Accuracy accuracy;

  @override
  String toString() =>
      '[AbsoluteOrientationQuaternionEvent (x: $x, y: $y, z: $z, w: $w, timestamp: $timestamp, accuracy: ${accuracy.name})]';
}
