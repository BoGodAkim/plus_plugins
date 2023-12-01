// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

enum Accuracy {
  /// Lower accuracy
  /// 
  /// This sensor is reporting data with low accuracy, 
  /// calibration with the environment is needed
  low,

  /// Medium accuracy
  /// 
  /// This sensor is reporting data with an average level of 
  /// accuracy, calibration with the environment may improve 
  /// the readings
  medium,

  /// Highest accuracy
  /// 
  /// This sensor is reporting data with maximum accuracy.
  high,

  /// No accuracy
  /// 
  /// Accuracy is not supported on the current platform or is
  /// not available at this time.
  unknown,

  /// Uncalibrated accuracy
  /// 
  /// The values returned by this sensor cannot be trusted,
  /// calibration is needed or the environment doesn't allow readings.
  uncalibrated,
}
