// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Foundation
import Flutter
import UIKit
import CoreMotion

let GRAVITY = 9.81

public protocol MotionStreamHandler: FlutterStreamHandler {
    var samplingPeriod: Int { get set }
    func isAvailable() -> Bool
}

class FPPSensorsPlusStreamHandler: NSObject, MotionStreamHandlerFactory {
    private let motionManager = CMMotionManager()

    var samplingPeriod = 200000 {
        didSet {
            setUpdateInterval(Double(samplingPeriod) * 0.000001)
        }
    }

    init() {
        setUpdateInterval(Double(samplingPeriod) * 0.000001)
    }

    func dealloc() {
        FPPSensorsPlusPlugin._cleanUp()
    }

    private func setUpdateInterval(_ interval: Double) {
        motionManager.accelerometerUpdateInterval = interval
        motionManager.gyroUpdateInterval = interval
        motionManager.magnetometerUpdateInterval = interval
        motionManager.deviceMotionUpdateInterval = interval
    }

    private func sendData(data: Array<Float64>, sink: @escaping FlutterEventSink) {
        if _isCleanUp {
            return
        }
        // Even after [detachFromEngineForRegistrar] some events may still be received
        // and fired until fully detached.

        var duplicatedData = data
        // IOS doesn't have accuracy data, so we send -1 (unknown) instead.
        duplicatedData += [Float64(-1)]
        duplicatedData += [Float64((Date().timeIntervalSince1970 * 1000000).rounded())]

        DispatchQueue.main.async {
            duplicatedData.withUnsafeBufferPointer { buffer in
                sink(FlutterStandardTypedData.init(float64: Data(buffer: buffer)))
            }
        }
    }
}




class FPPAccelerometerStreamHandlerPlus: FPPSensorsPlusStreamHandler {

    override init() {
        super.init() 
    }

    override func setUpdateInterval(_ interval: Double) {
        motionManager.accelerometerUpdateInterval = interval
    }

    func isAvailable() -> Bool {
        return motionManager.isAccelerometerAvailable
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError.init(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            // Multiply by gravity, and adjust sign values to
            // align with Android.
            let acceleration = data!.acceleration
            sendData(
                    data:[
                        -acceleration.x * GRAVITY,
                        -acceleration.y * GRAVITY,
                        -acceleration.z * GRAVITY
                        ],
                    sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopAccelerometerUpdates()
        return nil
    }
}

class FPPUserAccelStreamHandlerPlus: FPPSensorsPlusStreamHandler {

    override init() {
        super.init() 
    }

    override func setUpdateInterval(_ interval: Double) {
        motionManager.deviceMotionUpdateInterval = interval
    }

    func isAvailable() -> Bool {
        return CMMotionManager().isDeviceMotionAvailable
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        motionManager.showsDeviceMovementDisplay = true
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError.init(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            // Multiply by gravity, and adjust sign values to
            // align with Android.
            let acceleration = data!.userAcceleration
            sendData(
                    data:[
                        -acceleration.x * GRAVITY,
                        -acceleration.y * GRAVITY,
                        -acceleration.z * GRAVITY
                        ],
                    sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
}

class FPPGravityStreamHandlerPlus: FPPSensorsPlusStreamHandler {

    override init() {
        super.init() 
    }

    override func setUpdateInterval(_ interval: Double) {
        motionManager.deviceMotionUpdateInterval = interval
    }

    func isAvailable() -> Bool {
        return CMMotionManager().isDeviceMotionAvailable
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        motionManager.showsDeviceMovementDisplay = true
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError.init(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            // Multiply by gravity, and adjust sign values to
            // align with Android.
            let acceleration = data!.gravity
            sendData(
                    data:[
                        -acceleration.x * GRAVITY,
                        -acceleration.y * GRAVITY,
                        -acceleration.z * GRAVITY
                        ],
                    sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
}

class FPPGyroscopeStreamHandlerPlus: FPPSensorsPlusStreamHandler {

    override init() {
        super.init() 
    }

    override func setUpdateInterval(_ interval: Double) {
        motionManager.gyroUpdateInterval = interval
    }

    func isAvailable() -> Bool {
        return CMMotionManager().isGyroAvailable
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        motionManager.startGyroUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            let rotationRate = data!.rotationRate
            sendData(data: [ rotationRate.x, rotationRate.y, rotationRate.z ], sink: sink)
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopGyroUpdates()
        return nil
    }
}

class FPPMagnetometerStreamHandlerPlus: FPPSensorsPlusStreamHandler {

    override init() {
        super.init() 
    }

    override func setUpdateInterval(_ interval: Double) {
        motionManager.magnetometerUpdateInterval = interval
    }

    func isAvailable() -> Bool {
        return CMMotionManager().isMagnetometerAvailable
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        motionManager.startMagnetometerUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            let magneticField = data!.magneticField
            sendData(data: [magneticField.x, magneticField.y, magneticField.z ], sink: sink)
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
}

class FPPOrientationStreamHandlerPlus: FPPSensorsPlusStreamHandler {
    private var attitudeReferenceFrame: CMAttitudeReferenceFrame

    override init(_ referenceFrame: CMAttitudeReferenceFrame) {
        super.init()
        attitudeReferenceFrame = referenceFrame
    }

    override func setUpdateInterval(_ interval: Double) {
        motionManager.deviceMotionUpdateInterval = interval
    }

    func isAvailable() -> Bool {
        let motionManager = CMMotionManager()
        return motionManager.isDeviceMotionAvailable //&& motionManager.availableAttitudeReferenceFrames() & attitudeReferenceFrame
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        motionManager.showsDeviceMovementDisplay = true
        motionManager.startDeviceMotionUpdates( using: attitudeReferenceFrame, to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            let attitude = data!.attitude
            let yaw = attitude.yaw
            if self.attitudeReferenceFrame == CMAttitudeReferenceFrame.xMagneticNorthZVertical {
                // Remap y-axis to magnetic north instead of the x-axis,
                // to align with Android.
                yaw = (data!.attitude.yaw + Double.pi + Double.pi / 2).truncatingRemainder(dividingBy: Double.pi * 2) - Double.pi
            }
            sendData(
                    data:[
                        attitude.roll,
                        attitude.pitch,
                        yaw
                        ],
                    sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
}

public class FPPRotationQuaternionStreamHandlerPlus: FPPSensorsPlusStreamHandler {
    private var attitudeReferenceFrame: CMAttitudeReferenceFrame

    override init(_ referenceFrame: CMAttitudeReferenceFrame) {
        super.init()
        attitudeReferenceFrame = referenceFrame
    }

    func isAvailable() -> Bool {
        let motionManager = CMMotionManager()
        return motionManager.isDeviceMotionAvailable //&& motionManager.availableAttitudeReferenceFrames() & attitudeReferenceFrame
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        motionManager.showsDeviceMovementDisplay = true
        motionManager.startDeviceMotionUpdates( using: attitudeReferenceFrame, to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            let quaternion = data!.attitude.quaternion
            sendData(
                    data:[
                        quaternion.x,
                        quaternion.y,
                        quaternion.z,
                        quaternion.w
                        ],
                    sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
}


public class FPPRotationMatrixStreamHandlerPlus: FPPSensorsPlusStreamHandler {
    private var attitudeReferenceFrame: CMAttitudeReferenceFrame

    override init(_ referenceFrame: CMAttitudeReferenceFrame) {
        super.init()
        attitudeReferenceFrame = referenceFrame
    }

    override func setUpdateInterval(_ interval: Double) {
        motionManager.deviceMotionUpdateInterval = interval
    }

    func isAvailable() -> Bool {
        let motionManager = CMMotionManager()
        return motionManager.isDeviceMotionAvailable //&& motionManager.availableAttitudeReferenceFrames() & attitudeReferenceFrame
    }

    func onListen(
            withArguments arguments: Any?,
            eventSink sink: @escaping FlutterEventSink
    ) -> FlutterError? {
        motionManager.showsDeviceMovementDisplay = true
        motionManager.startDeviceMotionUpdates( using: attitudeReferenceFrame, to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                sink(FlutterError(
                        code: "UNAVAILABLE",
                        message: error!.localizedDescription,
                        details: nil
                ))
                return
            }
            let rotationMatrix = data!.attitude.rotationMatrix
            sendData(
                    data:[
                        rotationMatrix.m11,
                        rotationMatrix.m12,
                        rotationMatrix.m13,
                        rotationMatrix.m21,
                        rotationMatrix.m22,
                        rotationMatrix.m23,
                        rotationMatrix.m31,
                        rotationMatrix.m32,
                        rotationMatrix.m33
                        ],
                    sink: sink
            )
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
}
