// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';

import 'accuracy.dart';

/// TODO: Add documentation
class AbsoluteRotationMatrixEvent {
  /// Constructs an instance with the given [r11], [r12], [r13], [r21], [r22],
  /// [r23], [r31], [r32], and [r33] values.
  AbsoluteRotationMatrixEvent(
      double r11, double r12, double r13, double r21, double r22, double r23, double r31, double r32, double r33,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : rotationMatrix = Matrix3(r11, r12, r13, r21, r22, r23, r31, r32, r33),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a list of 9 doubles [rotationMatrixList].
  AbsoluteRotationMatrixEvent.fromList(List<double> rotationMatrixList, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : rotationMatrix = Matrix3.fromList(rotationMatrixList),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a [rotationMatrix].
  /// The matrix is copied.
  AbsoluteRotationMatrixEvent.fromMatrix3(Matrix3 rotationMatrix, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : rotationMatrix = Matrix3.copy(rotationMatrix),
        timestamp = timestamp ?? DateTime.now();

  final Matrix3 rotationMatrix;

  /// Timestamp when this event occurred.
  final DateTime timestamp;

  /// The accuracy of this reading.
  final Accuracy accuracy;

  @override
  String toString() =>
      '[AbsoluteRotationMatrixEvent (rotationMatrix: $rotationMatrix, timestamp: $timestamp, accuracy: ${accuracy.name})]';
}
