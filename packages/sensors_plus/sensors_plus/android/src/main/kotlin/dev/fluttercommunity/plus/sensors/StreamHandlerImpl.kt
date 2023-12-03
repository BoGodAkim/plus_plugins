package dev.fluttercommunity.plus.sensors

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import java.time.Instant

open internal class StreamHandlerImpl(
    protected val sensorManager: SensorManager,
    protected val sensorType: Int
) : EventChannel.StreamHandler {
    protected var sensorEventListener: SensorEventListener? = null

    protected var sensor: Sensor? = null

    protected var accuracy: Int = -1

    var samplingPeriod = 200000
        set(value) {
            field = value
            updateRegistration()
        }
    
    fun isSensorAvailable(): Boolean {
        return sensorManager.getDefaultSensor(sensorType) != null
    }

    override fun onListen(arguments: Any?, events: EventSink) {
        sensor = sensorManager.getDefaultSensor(sensorType)
        if (sensor != null) {
            sensorEventListener = createSensorEventListener(events)
            sensorManager.registerListener(sensorEventListener, sensor, samplingPeriod)
        } else {
            events.error(
                "NO_SENSOR",
                "Sensor not found",
                "It seems that your device has no ${getSensorName(sensorType)} sensor"
            )
        }
    }

    override fun onCancel(arguments: Any?) {
        if (sensor != null) {
            sensorManager.unregisterListener(sensorEventListener)
            sensorEventListener = null
        }
    }

    protected fun updateRegistration() {
        if (sensorEventListener != null) {
            sensorManager.unregisterListener(sensorEventListener)
            sensorManager.registerListener(sensorEventListener, sensor, samplingPeriod)
        }
    }

    open protected fun getSensorName(sensorType: Int): String {
        return when (sensorType) {
            Sensor.TYPE_ACCELEROMETER -> "Accelerometer"
            Sensor.TYPE_LINEAR_ACCELERATION -> "User Accelerometer"
            Sensor.TYPE_GRAVITY -> "Gravity Sensor"
            Sensor.TYPE_GYROSCOPE -> "Gyroscope"
            Sensor.TYPE_MAGNETIC_FIELD -> "Magnetometer"
            else -> "Undefined"
        }
    }

    open protected fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, newAccuracy: Int) {
                accuracy = newAccuracy
            }

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(event.values.size + 2)
                event.values.forEachIndexed { index, value ->
                    sensorValues[index] = value.toDouble()
                }
                sensorValues[event.values.size] = accuracy.toDouble()
                val instant = Instant.now()
                sensorValues[event.values.size + 1] = (instant.getEpochSecond() * 1000_000 + instant.getNano() / 1000).toDouble();
                events.success(sensorValues)
            }
        }
    }
}

internal class OrientationStreamHandlerImpl(
    sensorManager: SensorManager,
    sensorType: Int
) : StreamHandlerImpl(sensorManager, sensorType) {

    override protected fun getSensorName(sensorType: Int): String {
        return when (sensorType) {
            Sensor.TYPE_ROTATION_VECTOR -> "Absolute Orientation"
            Sensor.TYPE_GAME_ROTATION_VECTOR -> "Orientation"
            else -> "Undefined"
        }
    }

    override protected fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, newAccuracy: Int) {
                accuracy = newAccuracy
            }

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(5)
                var matrix = FloatArray(9)
                SensorManager.getRotationMatrixFromVector(matrix, event!!.values)
                // TODO: check if this is necessary
                // if (matrix[7] > 1.0f) matrix[7] = 1.0f
                // if (matrix[7] < -1.0f) matrix[7] = -1.0f
                var orientation = FloatArray(3)
                SensorManager.getOrientation(matrix, orientation)
                // TODO: check if this is necessary
                sensorValues[0] = -orientation[1].toDouble()
                sensorValues[1] = orientation[2].toDouble()
                sensorValues[2] = -orientation[0].toDouble()
                sensorValues[3] = accuracy.toDouble()
                val instant = Instant.now()
                sensorValues[4] = (instant.getEpochSecond() * 1000_000 + instant.getNano() / 1000).toDouble();
                events.success(sensorValues)
            }
        }
    }
}

internal class OrientationQuaternionStreamHandlerImpl(
    sensorManager: SensorManager,
    sensorType: Int
) : StreamHandlerImpl(sensorManager, sensorType) {

    override protected fun getSensorName(sensorType: Int): String {
        return when (sensorType) {
            Sensor.TYPE_ROTATION_VECTOR -> "Absolute Rotation Quaternion"
            Sensor.TYPE_GAME_ROTATION_VECTOR -> "Rotation Quaternion"
            else -> "Undefined"
        }
    }

    override protected fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, newAccuracy: Int) {
                accuracy = newAccuracy
            }

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(6)
                val quaternion = FloatArray(4)
                SensorManager.getQuaternionFromVector(quaternion, event!!.values)
                // change order from (w, x, y, z) to (x, y, z, w)
                sensorValues[0] = quaternion[1].toDouble()
                sensorValues[1] = quaternion[2].toDouble()
                sensorValues[2] = quaternion[3].toDouble()
                sensorValues[3] = quaternion[0].toDouble()
                sensorValues[4] = accuracy.toDouble()
                val instant = Instant.now()
                sensorValues[5] = (instant.getEpochSecond() * 1000_000 + instant.getNano() / 1000).toDouble();
                events.success(sensorValues)
            }
        }
    }
}

internal class RotationMatrixStreamHandlerImpl(
    sensorManager: SensorManager,
    sensorType: Int
) : StreamHandlerImpl(sensorManager, sensorType) {

    override protected fun getSensorName(sensorType: Int): String {
        return when (sensorType) {
            Sensor.TYPE_ROTATION_VECTOR -> "Absolute Rotation Matrix"
            Sensor.TYPE_GAME_ROTATION_VECTOR -> "Rotation Matrix"
            else -> "Undefined"
        }
    }

    override protected fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, newAccuracy: Int) {
                accuracy = newAccuracy
            }

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(11)
                var matrix = FloatArray(9)
                SensorManager.getRotationMatrixFromVector(matrix, event!!.values)
                matrix.forEachIndexed { index, value ->
                    sensorValues[index] = value.toDouble()
                }
                sensorValues[9] = accuracy.toDouble()
                val instant = Instant.now()
                sensorValues[10] = (instant.getEpochSecond() * 1000_000 + instant.getNano() / 1000).toDouble();
                events.success(sensorValues)
            }
        }
    }
}
                
