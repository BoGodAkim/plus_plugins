// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:vector_math/vector_math_64.dart';

import 'accuracy.dart';
import 'absolute_rotation_matrix_event.dart';

/// This is composite sensor which uses the accelerometer and gyroscope
/// to compute the device's rotation matrix.
/// [RotationMatrixEvent] more energy efficient than [AbsoluteRotationMatrixEvent], but
/// less accurate.
/// Rotation Matrix transforming a vector from the device coordinate system
/// to the world's coordinate system which is defined as a direct orthonormal basis,
/// where:
/// - X is defined as the vector product Y.Z (It is tangential to the ground at
/// the device's current location and roughly points East).
/// - Y is tangential to the ground at the device's current location and points
/// towards some unknown point.
/// - Z points towards the sky and is perpendicular to the ground.
class RotationMatrixEvent {
  /// Constructs an instance with the given [r11], [r12], [r13], [r21], [r22],
  /// [r23], [r31], [r32], and [r33] values.
  RotationMatrixEvent(
      double r11, double r12, double r13, double r21, double r22, double r23, double r31, double r32, double r33,
      [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : matrix = Matrix3(r11, r12, r13, r21, r22, r23, r31, r32, r33),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a list of 9 doubles [matrixList].
  RotationMatrixEvent.fromList(List<double> matrixList, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : matrix = Matrix3.fromList(matrixList),
        timestamp = timestamp ?? DateTime.now();

  /// Constructs an instance from a [matrix].
  /// The matrix is copied.
  RotationMatrixEvent.fromMatrix3(Matrix3 matrix, [DateTime? timestamp, this.accuracy = Accuracy.unknown])
      : matrix = Matrix3.copy(matrix),
        timestamp = timestamp ?? DateTime.now();

  /// Rotation Matrix transforming a vector from the device coordinate system
  /// to the world's coordinate system which is defined as a direct orthonormal basis,
  /// where:
  /// - X is defined as the vector product Y.Z (It is tangential to the ground at
  /// the device's current location and roughly points East).
  /// - Y is tangential to the ground at the device's current location and points
  /// towards some unknown point.
  /// - Z points towards the sky and is perpendicular to the ground
  final Matrix3 matrix;

  /// Timestamp when this event occurred.
  final DateTime timestamp;

  /// The accuracy of this reading.
  final Accuracy accuracy;

  @override
  String toString() => '[RotationMatrixEvent (matrix: $matrix, timestamp: $timestamp, accuracy: ${accuracy.name})]';
}
