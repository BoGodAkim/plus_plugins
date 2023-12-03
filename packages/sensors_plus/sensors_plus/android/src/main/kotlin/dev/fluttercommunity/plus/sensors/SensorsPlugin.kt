package dev.fluttercommunity.plus.sensors

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** SensorsPlugin  */
class SensorsPlugin : FlutterPlugin {
    private lateinit var methodChannel: MethodChannel

    private lateinit var accelerometerChannel: EventChannel
    private lateinit var userAccelChannel: EventChannel
    private lateinit var gravityChannel: EventChannel
    private lateinit var gyroscopeChannel: EventChannel
    private lateinit var magnetometerChannel: EventChannel
    private lateinit var orientationChannel: EventChannel
    private lateinit var absoluteOrientationChannel: EventChannel
    private lateinit var orientationQuaternionChannel: EventChannel
    private lateinit var absoluteOrientationQuaternionChannel: EventChannel
    private lateinit var rotationMatrixChannel: EventChannel
    private lateinit var absoluteRotationMatrixChannel: EventChannel

    private lateinit var accelerometerStreamHandler: StreamHandlerImpl
    private lateinit var userAccelStreamHandler: StreamHandlerImpl
    private lateinit var gravityStreamHandler: StreamHandlerImpl
    private lateinit var gyroscopeStreamHandler: StreamHandlerImpl
    private lateinit var magnetometerStreamHandler: StreamHandlerImpl
    private lateinit var orientationStreamHandler: OrientationStreamHandlerImpl
    private lateinit var absoluteOrientationStreamHandler: OrientationStreamHandlerImpl
    private lateinit var orientationQuaternionStreamHandler: OrientationQuaternionStreamHandlerImpl
    private lateinit var absoluteOrientationQuaternionStreamHandler: OrientationQuaternionStreamHandlerImpl
    private lateinit var rotationMatrixStreamHandler: RotationMatrixStreamHandlerImpl
    private lateinit var absoluteRotationMatrixStreamHandler: RotationMatrixStreamHandlerImpl

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        setupMethodChannel(binding.binaryMessenger)
        setupEventChannels(binding.applicationContext, binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        teardownMethodChannel()
        teardownEventChannels()
    }

    private fun setupMethodChannel(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler { call, result ->
            when(call.method.slice(0..1)) {
                "is" -> {
                    val streamHandler = when (call.method) {
                        "isAccelerometerAvailable" -> accelerometerStreamHandler
                        "isUserAccelerometerAvailable" -> userAccelStreamHandler
                        "isGravityAvailable" -> gravityStreamHandler
                        "isGyroscopeAvailable" -> gyroscopeStreamHandler
                        "isMagnetometerAvailable" -> magnetometerStreamHandler
                        "isOrientationAvailable" -> orientationStreamHandler
                        "isAbsoluteOrientationAvailable" -> absoluteOrientationStreamHandler
                        "isOrientationQuaternionAvailable" -> orientationQuaternionStreamHandler
                        "isAbsoluteOrientationQuaternionAvailable" -> absoluteOrientationQuaternionStreamHandler
                        "isRotationMatrixAvailable" -> rotationMatrixStreamHandler
                        "isAbsoluteRotationMatrixAvailable" -> absoluteRotationMatrixStreamHandler
                        else -> null
                    }
                    if (streamHandler != null) {
                        result.success(streamHandler.isSensorAvailable())
                    } else {
                        result.notImplemented()
                    }
                }
                "se" -> {
                    val streamHandler = when (call.method) {
                        "setAccelerometerSamplingPeriod" -> accelerometerStreamHandler
                        "setUserAccelerometerSamplingPeriod" -> userAccelStreamHandler
                        "setGravitySamplingPeriod" -> gravityStreamHandler
                        "setGyroscopeSamplingPeriod" -> gyroscopeStreamHandler
                        "setMagnetometerSamplingPeriod" -> magnetometerStreamHandler
                        "setOrientationSamplingPeriod" -> orientationStreamHandler
                        "setAbsoluteOrientationSamplingPeriod" -> absoluteOrientationStreamHandler
                        "setOrientationQuaternionSamplingPeriod" -> orientationQuaternionStreamHandler
                        "setAbsoluteOrientationQuaternionSamplingPeriod" -> absoluteOrientationQuaternionStreamHandler
                        "setRotationMatrixSamplingPeriod" -> rotationMatrixStreamHandler
                        "setAbsoluteRotationMatrixSamplingPeriod" -> absoluteRotationMatrixStreamHandler
                        else -> null
                    }
                    streamHandler?.samplingPeriod = call.arguments as Int
                    if (streamHandler != null) {
                        result.success(null)
                    } else {
                        result.notImplemented()
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun teardownMethodChannel() {
        methodChannel.setMethodCallHandler(null)
    }

    private fun setupEventChannels(context: Context, messenger: BinaryMessenger) {
        val sensorsManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        accelerometerChannel = EventChannel(messenger, ACCELEROMETER_CHANNEL_NAME)
        accelerometerStreamHandler = StreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_ACCELEROMETER
        )
        accelerometerChannel.setStreamHandler(accelerometerStreamHandler)

        userAccelChannel = EventChannel(messenger, USER_ACCELEROMETER_CHANNEL_NAME)
        userAccelStreamHandler = StreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_LINEAR_ACCELERATION
        )
        userAccelChannel.setStreamHandler(userAccelStreamHandler)

        gravityChannel = EventChannel(messenger, GRAVITY_CHANNEL_NAME)
        gravityStreamHandler = StreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_GRAVITY
        )
        gravityChannel.setStreamHandler(gravityStreamHandler)

        gyroscopeChannel = EventChannel(messenger, GYROSCOPE_CHANNEL_NAME)
        gyroscopeStreamHandler = StreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_GYROSCOPE
        )
        gyroscopeChannel.setStreamHandler(gyroscopeStreamHandler)

        magnetometerChannel = EventChannel(messenger, MAGNETOMETER_CHANNEL_NAME)
        magnetometerStreamHandler = StreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_MAGNETIC_FIELD
        )
        magnetometerChannel.setStreamHandler(magnetometerStreamHandler)

        orientationChannel = EventChannel(messenger, ORIENTATION_CHANNEL_NAME)
        orientationStreamHandler = OrientationStreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_GAME_ROTATION_VECTOR
        )
        orientationChannel.setStreamHandler(orientationStreamHandler)

        absoluteOrientationChannel = EventChannel(messenger, ABSOLUTE_ORIENTATION_CHANNEL_NAME)
        absoluteOrientationStreamHandler = OrientationStreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_ROTATION_VECTOR
        )
        absoluteOrientationChannel.setStreamHandler(absoluteOrientationStreamHandler)

        orientationQuaternionChannel = EventChannel(messenger, ROTATION_QUATERNION_CHANNEL_NAME)
        orientationQuaternionStreamHandler = OrientationQuaternionStreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_GAME_ROTATION_VECTOR
        )
        orientationQuaternionChannel.setStreamHandler(orientationQuaternionStreamHandler)

        absoluteOrientationQuaternionChannel = EventChannel(messenger, ABSOLUTE_ROTATION_QUATERNION_CHANNEL_NAME)
        absoluteOrientationQuaternionStreamHandler = OrientationQuaternionStreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_ROTATION_VECTOR
        )
        absoluteOrientationQuaternionChannel.setStreamHandler(absoluteOrientationQuaternionStreamHandler)

        rotationMatrixChannel = EventChannel(messenger, ROTATION_MATRIX_CHANNEL_NAME)
        rotationMatrixStreamHandler = RotationMatrixStreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_GAME_ROTATION_VECTOR
        )
        rotationMatrixChannel.setStreamHandler(rotationMatrixStreamHandler)

        absoluteRotationMatrixChannel = EventChannel(messenger, ABSOLUTE_ROTATION_MATRIX_CHANNEL_NAME)
        absoluteRotationMatrixStreamHandler = RotationMatrixStreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_ROTATION_VECTOR
        )
        absoluteRotationMatrixChannel.setStreamHandler(absoluteRotationMatrixStreamHandler)
    }

    private fun teardownEventChannels() {
        accelerometerChannel.setStreamHandler(null)
        userAccelChannel.setStreamHandler(null)
        gravityChannel.setStreamHandler(null)
        gyroscopeChannel.setStreamHandler(null)
        magnetometerChannel.setStreamHandler(null)
        orientationChannel.setStreamHandler(null)
        absoluteOrientationChannel.setStreamHandler(null)
        orientationQuaternionChannel.setStreamHandler(null)
        absoluteOrientationQuaternionChannel.setStreamHandler(null)
        rotationMatrixChannel.setStreamHandler(null)
        absoluteRotationMatrixChannel.setStreamHandler(null)

        accelerometerStreamHandler.onCancel(null)
        userAccelStreamHandler.onCancel(null)
        gravityStreamHandler.onCancel(null)
        gyroscopeStreamHandler.onCancel(null)
        magnetometerStreamHandler.onCancel(null)
        orientationStreamHandler.onCancel(null)
        absoluteOrientationStreamHandler.onCancel(null)
        orientationQuaternionStreamHandler.onCancel(null)
        absoluteOrientationQuaternionStreamHandler.onCancel(null)
        rotationMatrixStreamHandler.onCancel(null)
        absoluteRotationMatrixStreamHandler.onCancel(null)
    }

    companion object {
        private const val METHOD_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/method"
        private const val ACCELEROMETER_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/accelerometer"
        private const val USER_ACCELEROMETER_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/user_accel"
        private const val GRAVITY_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/gravity"
        private const val GYROSCOPE_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/gyroscope"
        private const val MAGNETOMETER_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/magnetometer"
        private const val ORIENTATION_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/orientation"
        private const val ABSOLUTE_ORIENTATION_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/absolute_orientation"
        private const val ROTATION_QUATERNION_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/orientation_quaternion"
        private const val ABSOLUTE_ROTATION_QUATERNION_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/absolute_orientation_quaternion"
        private const val ROTATION_MATRIX_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/rotation_matrix"
        private const val ABSOLUTE_ROTATION_MATRIX_CHANNEL_NAME =
            "dev.fluttercommunity.plus/sensors/absolute_rotation_matrix"
    }
}
