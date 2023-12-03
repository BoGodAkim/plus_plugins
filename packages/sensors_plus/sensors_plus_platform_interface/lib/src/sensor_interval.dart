import 'package:meta/meta.dart';

/// Interval between sensor events.
/// It is not guaranteed that the events will be received with the given interval.
/// Usually the interval is equal or shorter than the given interval,
/// but it can be longer due if the sensor captures data with a slower frequency.
@sealed
class SensorInterval {
  static const normalInterval = Duration(milliseconds: 200);
  static const uiInterval = Duration(milliseconds: 66, microseconds: 667);
  static const gameInterval = Duration(milliseconds: 20);
  static const fastestInterval = Duration.zero;
}
