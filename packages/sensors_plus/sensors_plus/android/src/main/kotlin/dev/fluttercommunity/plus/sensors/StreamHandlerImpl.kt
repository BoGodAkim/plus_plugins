package dev.fluttercommunity.plus.sensors

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import java.time.Instant

internal class StreamHandlerImpl(
    private val sensorManager: SensorManager,
    private val sensorType: Int
) : EventChannel.StreamHandler {
    private var sensorEventListener: SensorEventListener? = null

    private var sensor: Sensor? = null

    private var accuracy: Int = -1

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

    private fun updateRegistration() {
        if (sensorEventListener != null) {
            sensorManager.unregisterListener(sensorEventListener)
            sensorManager.registerListener(sensorEventListener, sensor, samplingPeriod)
        }
    }

    private fun getSensorName(sensorType: Int): String {
        return when (sensorType) {
            Sensor.TYPE_ACCELEROMETER -> "Accelerometer"
            Sensor.TYPE_LINEAR_ACCELERATION -> "User Accelerometer"
            Sensor.TYPE_GYROSCOPE -> "Gyroscope"
            Sensor.TYPE_MAGNETIC_FIELD -> "Magnetometer"
            else -> "Undefined"
        }
    }

    private fun createSensorEventListener(events: EventSink): SensorEventListener {
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
