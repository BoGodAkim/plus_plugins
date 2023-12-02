// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'snake.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  static const int _snakeRows = 20;
  static const int _snakeColumns = 20;
  static const double _snakeCellSize = 10.0;

  UserAccelerometerEvent? _userAccelerometerEvent;
  AccelerometerEvent? _accelerometerEvent;
  GravityEvent? _gravityEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;
  AbsoluteOrientationEvent? _absoluteOrientationEvent;
  OrientationEvent? _orientationEvent;
  AbsoluteRotationQuaternionEvent? _absoluteRotationQuaternionEvent;
  RotationQuaternionEvent? _rotationQuaternionEvent;
  AbsoluteRotationMatrixEvent? _absoluteRotationMatrixEvent;
  RotationMatrixEvent? _rotationMatrixEvent;

  bool _accelerometerAvailable = false;
  bool _gyroscopeAvailable = false;
  bool _gravityAvailable = false;
  bool _userAccelerometerAvailable = false;
  bool _magnetometerAvailable = false;
  bool _absoluteOrientationSensorAvailable = false;
  bool _orientationSensorAvailable = false;
  bool _absoluteRotationQuaternionSensorAvailable = false;
  bool _rotationQuaternionSensorAvailable = false;
  bool _absoluteRotationMatrixSensorAvailable = false;
  bool _rotationMatrixSensorAvailable = false;

  int? _userAccelerometerLastInterval;
  int? _accelerometerLastInterval;
  int? _gravityLastInterval;
  int? _gyroscopeLastInterval;
  int? _magnetometerLastInterval;
  int? _absoluteOrientationLastInterval;
  int? _orientationLastInterval;
  int? _absoluteRotationQuaternionLastInterval;
  int? _rotationQuaternionLastInterval;
  int? _absoluteRotationMatrixLastInterval;
  int? _rotationMatrixLastInterval;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;

  String accuracyToString(Accuracy? accuracy) {
    switch (accuracy) {
      case Accuracy.low:
        return '🟠';
      case Accuracy.medium:
        return '🟡';
      case Accuracy.high:
        return '🟢';
      case Accuracy.uncalibrated:
        return '🔴';
      case Accuracy.unknown:
      default:
        return '⚫';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors Plus Example'),
        elevation: 4,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: SizedBox(
                height: _snakeRows * _snakeCellSize,
                width: _snakeColumns * _snakeCellSize,
                child: Snake(
                  rows: _snakeRows,
                  columns: _snakeColumns,
                  cellSize: _snakeCellSize,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 300,
                child: ListView(children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(4),
                      5: FlexColumnWidth(2),
                    },
                    children: [
                      const TableRow(
                        children: [
                          SizedBox.shrink(),
                          SizedBox.shrink(),
                          SizedBox.shrink(),
                          Text('X'),
                          Text('Y'),
                          Text('Z'),
                          Text('Interval'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('UserAccelerometer'),
                          ),
                          Text(_userAccelerometerAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_userAccelerometerEvent?.accuracy)),
                          Text(_userAccelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
                          Text(_userAccelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
                          Text(_userAccelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
                          Text('${_userAccelerometerLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Accelerometer'),
                          ),
                          Text(_accelerometerAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_accelerometerEvent?.accuracy)),
                          Text(_accelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
                          Text(_accelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
                          Text(_accelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
                          Text('${_accelerometerLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Gravity'),
                          ),
                          Text(_gravityAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_gravityEvent?.accuracy)),
                          Text(_gravityEvent?.x.toStringAsFixed(1) ?? '?'),
                          Text(_gravityEvent?.y.toStringAsFixed(1) ?? '?'),
                          Text(_gravityEvent?.z.toStringAsFixed(1) ?? '?'),
                          Text('${_gravityLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Gyroscope'),
                          ),
                          Text(_gyroscopeAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_gyroscopeEvent?.accuracy)),
                          Text(_gyroscopeEvent?.x.toStringAsFixed(1) ?? '?'),
                          Text(_gyroscopeEvent?.y.toStringAsFixed(1) ?? '?'),
                          Text(_gyroscopeEvent?.z.toStringAsFixed(1) ?? '?'),
                          Text('${_gyroscopeLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Magnetometer'),
                          ),
                          Text(_magnetometerAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_magnetometerEvent?.accuracy)),
                          Text(_magnetometerEvent?.x.toStringAsFixed(1) ?? '?'),
                          Text(_magnetometerEvent?.y.toStringAsFixed(1) ?? '?'),
                          Text(_magnetometerEvent?.z.toStringAsFixed(1) ?? '?'),
                          Text('${_magnetometerLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('AbsoluteOrientation'),
                          ),
                          Text(_absoluteOrientationSensorAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_absoluteOrientationEvent?.accuracy)),
                          Text(_absoluteOrientationEvent?.pitch.toStringAsFixed(1) ?? '?'),
                          Text(_absoluteOrientationEvent?.roll.toStringAsFixed(1) ?? '?'),
                          Text(_absoluteOrientationEvent?.yaw.toStringAsFixed(1) ?? '?'),
                          Text('${_absoluteOrientationLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Orientation'),
                          ),
                          Text(_orientationSensorAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_orientationEvent?.accuracy)),
                          Text(_orientationEvent?.pitch.toStringAsFixed(1) ?? '?'),
                          Text(_orientationEvent?.roll.toStringAsFixed(1) ?? '?'),
                          Text(_orientationEvent?.yaw.toStringAsFixed(1) ?? '?'),
                          Text('${_orientationLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('AbsoluteRotationQuaternion'),
                          ),
                          Text(_absoluteRotationQuaternionSensorAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_absoluteRotationQuaternionEvent?.accuracy)),
                          const Text(" "),
                          const Text(" "),
                          const Text(" "),
                          Text('${_absoluteRotationQuaternionLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('RotationQuaternion'),
                          ),
                          Text(_rotationQuaternionSensorAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_rotationQuaternionEvent?.accuracy)),
                          const Text(" "),
                          const Text(" "),
                          const Text(" "),
                          Text('${_rotationQuaternionLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('AbsoluteRotationMatrix'),
                          ),
                          Text(_absoluteRotationMatrixSensorAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_absoluteRotationMatrixEvent?.accuracy)),
                          const Text(" "),
                          const Text(" "),
                          const Text(" "),
                          Text('${_absoluteRotationMatrixLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('RotationMatrix'),
                          ),
                          Text(_rotationMatrixSensorAvailable ? '✅' : '❌'),
                          Text(accuracyToString(_rotationMatrixEvent?.accuracy)),
                          const Text(" "),
                          const Text(" "),
                          const Text(" "),
                          Text('${_rotationMatrixLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Update Interval:'),
              SegmentedButton(
                segments: [
                  ButtonSegment(
                    value: SensorInterval.gameInterval,
                    label: Text('Game\n'
                        '(${SensorInterval.gameInterval.inMilliseconds}ms)'),
                  ),
                  ButtonSegment(
                    value: SensorInterval.uiInterval,
                    label: Text('UI\n'
                        '(${SensorInterval.uiInterval.inMilliseconds}ms)'),
                  ),
                  ButtonSegment(
                    value: SensorInterval.normalInterval,
                    label: Text('Normal\n'
                        '(${SensorInterval.normalInterval.inMilliseconds}ms)'),
                  ),
                  const ButtonSegment(
                    value: Duration(milliseconds: 500),
                    label: Text('500ms'),
                  ),
                  const ButtonSegment(
                    value: Duration(seconds: 1),
                    label: Text('1s'),
                  ),
                ],
                selected: {sensorInterval},
                showSelectedIcon: false,
                onSelectionChanged: (value) {
                  setState(() {
                    sensorInterval = value.first;
                    userAccelerometerEventStream(samplingPeriod: sensorInterval);
                    accelerometerEventStream(samplingPeriod: sensorInterval);
                    gravityEventStream(samplingPeriod: sensorInterval);
                    gyroscopeEventStream(samplingPeriod: sensorInterval);
                    magnetometerEventStream(samplingPeriod: sensorInterval);
                    absoluteOrientationEventStream(samplingPeriod: sensorInterval);
                    orientationEventStream(samplingPeriod: sensorInterval);
                    absoluteRotationQuaternionEventStream(samplingPeriod: sensorInterval);
                    rotationQuaternionEventStream(samplingPeriod: sensorInterval);
                    absoluteRotationMatrixEventStream(samplingPeriod: sensorInterval);
                    rotationMatrixEventStream(samplingPeriod: sensorInterval);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();

    isAccelerometerAvailable.then((value) => setState(() {
          _accelerometerAvailable = value;
        }));
    isGyroscopeAvailable.then((value) => setState(() {
          _gyroscopeAvailable = value;
        }));
    isUserAccelerometerAvailable.then((value) => setState(() {
          _userAccelerometerAvailable = value;
        }));
    isGravityAvailable.then((value) => setState(() {
          _gravityAvailable = value;
        }));
    isMagnetometerAvailable.then((value) => setState(() {
          _magnetometerAvailable = value;
        }));
    isAbsoluteOrientationSensorAvailable.then((value) => setState(() {
          _absoluteOrientationSensorAvailable = value;
        }));
    isOrientationSensorAvailable.then((value) => setState(() {
          _orientationSensorAvailable = value;
        }));
    isAbsoluteRotationQuaternionSensorAvailable.then((value) => setState(() {
          _absoluteRotationQuaternionSensorAvailable = value;
        }));
    isRotationQuaternionSensorAvailable.then((value) => setState(() {
          _rotationQuaternionSensorAvailable = value;
        }));
    isAbsoluteRotationMatrixSensorAvailable.then((value) => setState(() {
          _absoluteRotationMatrixSensorAvailable = value;
        }));
    isRotationMatrixSensorAvailable.then((value) => setState(() {
          _rotationMatrixSensorAvailable = value;
        }));

    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          setState(() {
            if (_userAccelerometerEvent != null) {
              final interval = event.timestamp.difference(_userAccelerometerEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
            _userAccelerometerEvent = event;
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text("It seems that your device doesn't support User Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          setState(() {
            if (_accelerometerEvent != null) {
              final interval = event.timestamp.difference(_accelerometerEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _accelerometerLastInterval = interval.inMilliseconds;
              }
            }
            _accelerometerEvent = event;
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text("It seems that your device doesn't support Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gravityEventStream(samplingPeriod: sensorInterval).listen(
        (GravityEvent event) {
          setState(() {
            if (_gravityEvent != null) {
              final interval = event.timestamp.difference(_gravityEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _gravityLastInterval = interval.inMilliseconds;
              }
            }
            _gravityEvent = event;
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text("It seems that your device doesn't support Gravity Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          setState(() {
            if (_gyroscopeEvent != null) {
              final interval = event.timestamp.difference(_gyroscopeEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _gyroscopeLastInterval = interval.inMilliseconds;
              }
            }
            _gyroscopeEvent = event;
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text("It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen(
        (MagnetometerEvent event) {
          setState(() {
            if (_magnetometerEvent != null) {
              final interval = event.timestamp.difference(_magnetometerEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _magnetometerLastInterval = interval.inMilliseconds;
              }
            }
            _magnetometerEvent = event;
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text("It seems that your device doesn't support Magnetometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      absoluteOrientationEventStream(samplingPeriod: sensorInterval).listen(
        (AbsoluteOrientationEvent event) {
          setState(() {
            if (_absoluteOrientationEvent != null) {
              final interval = event.timestamp.difference(_absoluteOrientationEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _absoluteOrientationLastInterval = interval.inMilliseconds;
              }
            }
            _absoluteOrientationEvent = event;
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text("It seems that your device doesn't support Absolute Orientation Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      orientationEventStream(samplingPeriod: sensorInterval).listen(
        (OrientationEvent event) {
          setState(() {
            if (_orientationEvent != null) {
              final interval = event.timestamp.difference(_orientationEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _orientationLastInterval = interval.inMilliseconds;
              }
            }
            _orientationEvent = event;
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text("It seems that your device doesn't support Orientation Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      absoluteRotationQuaternionEventStream(samplingPeriod: sensorInterval).listen(
        (AbsoluteRotationQuaternionEvent event) {
          setState(() {
            if (_absoluteRotationQuaternionEvent != null) {
              final interval = event.timestamp.difference(_absoluteRotationQuaternionEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _absoluteRotationQuaternionLastInterval = interval.inMilliseconds;
              }
            }
            _absoluteRotationQuaternionEvent = event;
          });
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text("It seems that your device doesn't support Absolute Rotation Quaternion Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      rotationQuaternionEventStream(samplingPeriod: sensorInterval).listen(
        (RotationQuaternionEvent event) {
          setState(() {
            if (_rotationQuaternionEvent != null) {
              final interval = event.timestamp.difference(_rotationQuaternionEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _rotationQuaternionLastInterval = interval.inMilliseconds;
              }
            }
            _rotationQuaternionEvent = event;
          });
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text("It seems that your device doesn't support Rotation Quaternion Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      absoluteRotationMatrixEventStream(samplingPeriod: sensorInterval).listen(
        (AbsoluteRotationMatrixEvent event) {
          setState(() {
            if (_absoluteRotationMatrixEvent != null) {
              final interval = event.timestamp.difference(_absoluteRotationMatrixEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _absoluteRotationMatrixLastInterval = interval.inMilliseconds;
              }
            }
            _absoluteRotationMatrixEvent = event;
          });
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text("It seems that your device doesn't support Absolute Rotation Matrix Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      rotationMatrixEventStream(samplingPeriod: sensorInterval).listen(
        (RotationMatrixEvent event) {
          setState(() {
            if (_rotationMatrixEvent != null) {
              final interval = event.timestamp.difference(_rotationMatrixEvent!.timestamp);
              if (interval > _ignoreDuration) {
                _rotationMatrixLastInterval = interval.inMilliseconds;
              }
            }
            _rotationMatrixEvent = event;
          });
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text("It seems that your device doesn't support Rotation Matrix Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
  }
}
