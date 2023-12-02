// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';

import 'accuracy.dart';

/// TODO: Add documentation
class AbsoluteRotationQuaternionEvent {
  /// Constructs an instance with the given [x], [y], [z], and [w] values.
  AbsoluteRotationQuaternionEvent(double x, double y, double z, double w,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : quaternion = Quaternion(x, y, z, w),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a list of 4 doubles [quaternionList].
  AbsoluteRotationQuaternionEvent.fromList(List<double> quaternionList, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : quaternion = Quaternion(quaternionList[0], quaternionList[1], quaternionList[2], quaternionList[3]),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a [quaternion].
  /// The quaternion is copied.
  AbsoluteRotationQuaternionEvent.fromQuaternion(Quaternion quaternion, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : quaternion = Quaternion.copy(quaternion),
        timestamp = timestamp ?? DateTime.now();

  final Quaternion quaternion;

  double get x => quaternion.x;

  double get y => quaternion.y;

  double get z => quaternion.z;

  double get w => quaternion.w;

  /// Timestamp when this event occurred.
  final DateTime timestamp;

  /// The accuracy of this reading.
  final Accuracy accuracy;

  @override
  String toString() => '[AbsoluteRotationQuaternionEvent (x: $x, y: $y, z: $z, w: $w, timestamp: $timestamp, accuracy: ${accuracy.name})]';
}
