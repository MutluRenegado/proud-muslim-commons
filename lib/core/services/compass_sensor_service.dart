import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CompassSensorService {
  static StreamSubscription<AccelerometerEvent>? _accelSub;
  static StreamSubscription<MagnetometerEvent>? _magSub;
  static StreamSubscription<CompassEvent>? _compassSub;

  static double _lastAx = 0, _lastAy = 0, _lastAz = 9.8;
  static double _lastMx = 0, _lastMy = 0, _lastMz = 0;
  static bool _hasMagData = false;
  static bool _hasAccelData = false;

  static final StreamController<double> _headingController =
      StreamController<double>.broadcast();

  static Stream<double> get headingStream => _headingController.stream;

  /// Starts listening to device sensors and emitting smooth, tilt-compensated headings in degrees (0..360)
  static void startListening({void Function(double heading)? onHeading}) {
    stopListening();

    // 1. Primary: 3D Tilt-compensated Vector Sensor Fusion via sensors_plus
    try {
      _accelSub = accelerometerEventStream().listen((accel) {
        // Low pass filter for gravity vector
        _lastAx = _lastAx * 0.8 + accel.x * 0.2;
        _lastAy = _lastAy * 0.8 + accel.y * 0.2;
        _lastAz = _lastAz * 0.8 + accel.z * 0.2;
        _hasAccelData = true;
        _computeAndEmitHeading(onHeading);
      }, onError: (_) {});

      _magSub = magnetometerEventStream().listen((mag) {
        // Low pass filter for magnetic field vector
        _lastMx = _lastMx * 0.8 + mag.x * 0.2;
        _lastMy = _lastMy * 0.8 + mag.y * 0.2;
        _lastMz = _lastMz * 0.8 + mag.z * 0.2;
        _hasMagData = true;
        _computeAndEmitHeading(onHeading);
      }, onError: (_) {});
    } catch (_) {}

    // 2. Secondary / Fallback: flutter_compass
    try {
      final stream = FlutterCompass.events;
      if (stream != null) {
        _compassSub = stream.listen((event) {
          if (!_hasMagData && event.heading != null) {
            final raw = (event.heading! + 360.0) % 360.0;
            _headingController.add(raw);
            if (onHeading != null) onHeading(raw);
          }
        }, onError: (_) {});
      }
    } catch (_) {}
  }

  static void _computeAndEmitHeading(void Function(double heading)? onHeading) {
    if (!_hasAccelData || !_hasMagData) return;

    final heading = calculateTiltCompensatedHeading(
      ax: _lastAx,
      ay: _lastAy,
      az: _lastAz,
      mx: _lastMx,
      my: _lastMy,
      mz: _lastMz,
    );

    if (heading != null) {
      _headingController.add(heading);
      if (onHeading != null) onHeading(heading);
    }
  }

  /// Calculates the tilt-compensated compass azimuth from accelerometer and magnetometer vectors.
  static double? calculateTiltCompensatedHeading({
    required double ax,
    required double ay,
    required double az,
    required double mx,
    required double my,
    required double mz,
  }) {
    // 1. East vector = Magnetic x Gravity (Cross Product)
    final ex = my * az - mz * ay;
    final ey = mz * ax - mx * az;
    final ez = mx * ay - my * ax;

    final eNorm = math.sqrt(ex * ex + ey * ey + ez * ez);
    if (eNorm < 0.0001) return null;

    final enX = ex / eNorm;
    final enY = ey / eNorm;
    final enZ = ez / eNorm;

    // 2. North vector = Gravity x East_Norm (Cross Product)
    final nx = ay * enZ - az * enY;
    final ny = az * enX - ax * enZ;
    final nz = ax * enY - ay * enX;

    final nNorm = math.sqrt(nx * nx + ny * ny + nz * nz);
    if (nNorm < 0.0001) return null;

    final nnY = ny / nNorm;

    // 3. Azimuth heading of device Y-axis (top of device) projected on horizontal plane
    final headingRad = math.atan2(enY, nnY);
    double headingDeg = headingRad * (180.0 / math.pi);
    return (headingDeg + 360.0) % 360.0;
  }

  static void stopListening() {
    _accelSub?.cancel();
    _magSub?.cancel();
    _compassSub?.cancel();
    _accelSub = null;
    _magSub = null;
    _compassSub = null;
    _hasMagData = false;
    _hasAccelData = false;
  }
}
