// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Flutter

var _eventChannels: [String: FlutterEventChannel] = [:]
var _streamHandlers: [String: MotionStreamHandler] = [:]
var _isCleanUp = false

public class FPPSensorsPlusPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let accelerometerStreamHandler = FPPAccelerometerStreamHandlerPlus()
        let accelerometerStreamHandlerName = "dev.fluttercommunity.plus/sensors/accelerometer"
        let accelerometerChannel = FlutterEventChannel(
                name: accelerometerStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        accelerometerChannel.setStreamHandler(accelerometerStreamHandler)
        _eventChannels[accelerometerStreamHandlerName] = accelerometerChannel
        _streamHandlers[accelerometerStreamHandlerName] = accelerometerStreamHandler

        let userAccelerometerStreamHandler = FPPUserAccelStreamHandlerPlus()
        let userAccelerometerStreamHandlerName = "dev.fluttercommunity.plus/sensors/user_accel"
        let userAccelerometerChannel = FlutterEventChannel(
                name: userAccelerometerStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        userAccelerometerChannel.setStreamHandler(userAccelerometerStreamHandler)
        _eventChannels[userAccelerometerStreamHandlerName] = userAccelerometerChannel
        _streamHandlers[userAccelerometerStreamHandlerName] = userAccelerometerStreamHandler

        let gravityStreamHandler = FPPGravityStreamHandlerPlus()
        let gravityStreamHandlerName = "dev.fluttercommunity.plus/sensors/gravity"
        let gravityChannel = FlutterEventChannel(
                name: gravityStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        gravityChannel.setStreamHandler(gravityStreamHandler)
        _eventChannels[gravityStreamHandlerName] = gravityChannel
        _streamHandlers[gravityStreamHandlerName] = gravityStreamHandler

        let gyroscopeStreamHandler = FPPGyroscopeStreamHandlerPlus()
        let gyroscopeStreamHandlerName = "dev.fluttercommunity.plus/sensors/gyroscope"
        let gyroscopeChannel = FlutterEventChannel(
                name: gyroscopeStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        gyroscopeChannel.setStreamHandler(gyroscopeStreamHandler)
        _eventChannels[gyroscopeStreamHandlerName] = gyroscopeChannel
        _streamHandlers[gyroscopeStreamHandlerName] = gyroscopeStreamHandler

        let magnetometerStreamHandler = FPPMagnetometerStreamHandlerPlus()
        let magnetometerStreamHandlerName = "dev.fluttercommunity.plus/sensors/magnetometer"
        let magnetometerChannel = FlutterEventChannel(
                name: magnetometerStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        magnetometerChannel.setStreamHandler(magnetometerStreamHandler)
        _eventChannels[magnetometerStreamHandlerName] = magnetometerChannel
        _streamHandlers[magnetometerStreamHandlerName] = magnetometerStreamHandler

        let orientationStreamHandler = FPPOrientationStreamHandlerPlus(CMAttitudeReferenceFrame.xArbitraryZVertical)
        let orientationStreamHandlerName = "dev.fluttercommunity.plus/sensors/orientation"
        let orientationChannel = FlutterEventChannel(
                name: orientationStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        orientationChannel.setStreamHandler(orientationStreamHandler)
        _eventChannels[orientationStreamHandlerName] = orientationChannel
        _streamHandlers[orientationStreamHandlerName] = orientationStreamHandler

        let absoluteOrientationStreamHandler = FPPOrientationStreamHandlerPlus(CMAttitudeReferenceFrame.xMagneticNorthZVertical)
        let absoluteOrientationStreamHandlerName = "dev.fluttercommunity.plus/sensors/absolute_orientation"
        let absoluteOrientationChannel = FlutterEventChannel(
                name: absoluteOrientationStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        absoluteOrientationChannel.setStreamHandler(absoluteOrientationStreamHandler)
        _eventChannels[absoluteOrientationStreamHandlerName] = absoluteOrientationChannel
        _streamHandlers[absoluteOrientationStreamHandlerName] = absoluteOrientationStreamHandler

        let rotationQuaternionStreamHandler = FPPRotationQuaternionStreamHandlerPlus(CMAttitudeReferenceFrame.xArbitraryZVertical)
        let rotationQuaternionStreamHandlerName = "dev.fluttercommunity.plus/sensors/rotation_quaternion"
        let rotationQuaternionChannel = FlutterEventChannel(
                name: rotationQuaternionStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        rotationQuaternionChannel.setStreamHandler(rotationQuaternionStreamHandler)
        _eventChannels[rotationQuaternionStreamHandlerName] = rotationQuaternionChannel
        _streamHandlers[rotationQuaternionStreamHandlerName] = rotationQuaternionStreamHandler

        let absoluteRotationQuaternionStreamHandler = FPPRotationQuaternionStreamHandlerPlus(CMAttitudeReferenceFrame.xMagneticNorthZVertical)
        let absoluteRotationQuaternionStreamHandlerName = "dev.fluttercommunity.plus/sensors/absolute_rotation_quaternion"
        let absoluteRotationQuaternionChannel = FlutterEventChannel(
                name: absoluteRotationQuaternionStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        absoluteRotationQuaternionChannel.setStreamHandler(absoluteRotationQuaternionStreamHandler)
        _eventChannels[absoluteRotationQuaternionStreamHandlerName] = absoluteRotationQuaternionChannel
        _streamHandlers[absoluteRotationQuaternionStreamHandlerName] = absoluteRotationQuaternionStreamHandler

        let rotationMatrixStreamHandler = FPPRotationMatrixStreamHandlerPlus(CMAttitudeReferenceFrame.xArbitraryZVertical)
        let rotationMatrixStreamHandlerName = "dev.fluttercommunity.plus/sensors/rotation_matrix"
        let rotationMatrixChannel = FlutterEventChannel(
                name: rotationMatrixStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        rotationMatrixChannel.setStreamHandler(rotationMatrixStreamHandler)
        _eventChannels[rotationMatrixStreamHandlerName] = rotationMatrixChannel
        _streamHandlers[rotationMatrixStreamHandlerName] = rotationMatrixStreamHandler

        let absoluteRotationMatrixStreamHandler = FPPRotationMatrixStreamHandlerPlus(CMAttitudeReferenceFrame.xMagneticNorthZVertical)
        let absoluteRotationMatrixStreamHandlerName = "dev.fluttercommunity.plus/sensors/absolute_rotation_matrix"
        let absoluteRotationMatrixChannel = FlutterEventChannel(
                name: absoluteRotationMatrixStreamHandlerName,
                binaryMessenger: registrar.messenger()
        )
        absoluteRotationMatrixChannel.setStreamHandler(absoluteRotationMatrixStreamHandler)
        _eventChannels[absoluteRotationMatrixStreamHandlerName] = absoluteRotationMatrixChannel
        _streamHandlers[absoluteRotationMatrixStreamHandlerName] = absoluteRotationMatrixStreamHandler

        let methodChannel = FlutterMethodChannel(
                name: "dev.fluttercommunity.plus/sensors/method",
                binaryMessenger: registrar.messenger()
        )
        methodChannel.setMethodCallHandler { call, result in
            switch (call.method[..<call.method.index(call.method.startIndex, offsetBy: 2)]) {
            case "is":
                let streamHandler: MotionStreamHandler!;
                switch (call.method) {
                case "isAccelerometerAvailable":
                    streamHandler = _streamHandlers[accelerometerStreamHandlerName]
                case "isUserAccelerometerAvailable":
                    streamHandler = _streamHandlers[userAccelerometerStreamHandlerName]
                case "isGravityAvailable":
                    streamHandler = _streamHandlers[gravityStreamHandlerName]
                case "isGyroscopeAvailable":
                    streamHandler = _streamHandlers[gyroscopeStreamHandlerName]
                case "isMagnetometerAvailable":
                    streamHandler = _streamHandlers[magnetometerStreamHandlerName]
                case "isOrientationAvailable":
                    streamHandler = _streamHandlers[orientationStreamHandlerName]
                case "isAbsoluteOrientationAvailable":
                    streamHandler = _streamHandlers[absoluteOrientationStreamHandlerName]
                case "isRotationQuaternionAvailable":
                    streamHandler = _streamHandlers[rotationQuaternionStreamHandlerName]
                case "isAbsoluteRotationQuaternionAvailable":
                    streamHandler = _streamHandlers[absoluteRotationQuaternionStreamHandlerName]
                case "isRotationMatrixAvailable":
                    streamHandler = _streamHandlers[rotationMatrixStreamHandlerName]
                case "isAbsoluteRotationMatrixAvailable":
                    streamHandler = _streamHandlers[absoluteRotationMatrixStreamHandlerName]
                default:
                    return result(FlutterMethodNotImplemented)
                }
                result(streamHandler.isAvailable())

            case "se":
                let streamHandler: MotionStreamHandler!;
                switch (call.method) {
                case "setAccelerometerSamplingPeriod":
                    streamHandler = _streamHandlers[accelerometerStreamHandlerName]
                case "setUserAccelerometerSamplingPeriod":
                    streamHandler = _streamHandlers[userAccelerometerStreamHandlerName]
                case "setGravitySamplingPeriod":
                    streamHandler = _streamHandlers[gravityStreamHandlerName]
                case "setGyroscopeSamplingPeriod":
                    streamHandler = _streamHandlers[gyroscopeStreamHandlerName]
                case "setMagnetometerSamplingPeriod":
                    streamHandler = _streamHandlers[magnetometerStreamHandlerName]
                case "setOrientationSamplingPeriod":
                    streamHandler = _streamHandlers[orientationStreamHandlerName]
                case "setAbsoluteOrientationSamplingPeriod":
                    streamHandler = _streamHandlers[absoluteOrientationStreamHandlerName]
                case "setRotationQuaternionSamplingPeriod":
                    streamHandler = _streamHandlers[rotationQuaternionStreamHandlerName]
                case "setAbsoluteRotationQuaternionSamplingPeriod":
                    streamHandler = _streamHandlers[absoluteRotationQuaternionStreamHandlerName]
                case "setRotationMatrixSamplingPeriod":
                    streamHandler = _streamHandlers[rotationMatrixStreamHandlerName]
                case "setAbsoluteRotationMatrixSamplingPeriod":
                    streamHandler = _streamHandlers[absoluteRotationMatrixStreamHandlerName]
                default:
                    return result(FlutterMethodNotImplemented)
                }
                streamHandler.samplingPeriod = call.arguments as! Int
                result(nil)

            default:
                return result(FlutterMethodNotImplemented)
            }
        }

        _isCleanUp = false
    }

    func detachFromEngineForRegistrar(registrar: NSObject!) {
        FPPSensorsPlusPlugin._cleanUp()
    }

    static func _cleanUp() {
        _isCleanUp = true
        for channel in _eventChannels.values {
            channel.setStreamHandler(nil)
        }
        _eventChannels.removeAll()
        for handler in _streamHandlers.values {
            handler.onCancel(withArguments: nil)
        }
        _streamHandlers.removeAll()
    }
}
