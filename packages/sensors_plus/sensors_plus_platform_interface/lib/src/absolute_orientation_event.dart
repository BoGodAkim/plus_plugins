// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';

import 'accuracy.dart';

/// TODO: Add documentation
class AbsoluteOrientationEvent {
  /// Constructs an instance with the given [pitch], [roll], and [yaw] values.
  AbsoluteOrientationEvent(double pitch, double roll, double yaw,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3(pitch, roll, yaw),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a list of 3 doubles [orientationList].
  AbsoluteOrientationEvent.fromList(List<double> orientationList, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3.array(orientationList),
        timestamp = timestamp ?? DateTime.now();
  
  /// Constructs an instance from a [vector].
  /// The vector is copied.
  AbsoluteOrientationEvent.fromVector3(Vector3 vector, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : vector = Vector3.copy(vector),
        timestamp = timestamp ?? DateTime.now();

  final Vector3 vector;

  double get pitch => vector.x;

  double get roll => vector.y;

  double get yaw => vector.z;

  /// Timestamp when this event occurred.
  final DateTime timestamp;

  /// The accuracy of this reading.
  final Accuracy accuracy;

  @override
  String toString() => '[AbsoluteOrientationEvent (pitch: $pitch, roll: $roll, yaw: $yaw, timestamp: $timestamp, accuracy: ${accuracy.name})]';
}
