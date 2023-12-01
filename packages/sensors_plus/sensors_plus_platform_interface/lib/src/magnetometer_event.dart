// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';

import 'accuracy.dart';

/// A sensor sample from a magnetometer.
///
/// Magnetometers measure the ambient magnetic field surrounding the sensor,
/// returning values in microteslas ***μT*** for each three-dimensional axis.
///
/// Consider that these samples may bear effects of Earth's magnetic field as
/// well as local factors such as the metal of the device itself or nearby
/// magnets, though most devices compensate for these factors.
///
/// A compass is an example of a general utility for magnetometer data.
class MagnetometerEvent {
  /// Constructs a new instance with the given [x], [y], and [z] values.
  ///
  /// See [MagnetometerEvent] for more information.
  MagnetometerEvent(double x, double y, double z, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3(x, y, z),
        timestamp = timestamp ?? DateTime.now();

  /// Vector describing the ambient magnetic field in ***μT***.
  /// 
  /// This uses a right-handed coordinate system. So when the device is held
  /// upright and facing the user axis are:
  /// 
  /// x - positive along the right side of the device when it is facing the user
  /// y - positive along the top of the device when it is facing the user
  /// z - positive coming out of the screen when it is facing the user
  final Vector3 vector;

  /// The ambient magnetic field in this axis surrounding the sensor in
  /// microteslas ***μT***.
  /// 
  /// When the device is held upright facing the user, positive values mean the
  /// device is moving to the right and negative mean it is moving to the left.
  double get x => vector.x;

  /// The ambient magnetic field in this axis surrounding the sensor in
  /// microteslas ***μT***.
  /// 
  /// When the device is held upright facing the user, positive values mean the
  /// device is moving towards the sky and negative mean it is moving towards
  /// the ground.
  double get y => vector.y;

  /// The ambient magnetic field in this axis surrounding the sensor in
  /// microteslas ***μT***.
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
  String toString() => '[MagnetometerEvent (x: $x, y: $y, z: $z, timestamp: $timestamp, accuracy: ${accuracy.name})]';
}
