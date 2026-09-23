import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../data/car_location_repository.dart';
import '../models/car_location.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/photo_service.dart';

class ParkingController extends ChangeNotifier {
  ParkingController({
    required this._repository,
    required this._location,
    required this._photos,
    required this._notifications,
  });

  static const arrivalRadiusMeters = 40.0;

  static const armDistanceMeters = 100.0;

  static const historyLimit = 3;

  final CarLocationRepository _repository;
  final LocationService _location;
  final PhotoService _photos;
  final NotificationService _notifications;
  final List<CarLocation> _history = [];

  CarLocation? _current;
  bool _loading = true;
  bool _geofenceArmed = false;
  StreamSubscription<Coordinates>? _positionSub;

  CarLocation? get current => _current;
  bool get loading => _loading;
  List<CarLocation> get history => List.unmodifiable(_history);

  bool get needsOverwriteConfirmation => _current != null && !_current!.visited;

  File photoFile(String fileName) => _photos.fileFor(fileName);

  Future<void> load() async {
    _current = await _repository.load();
    _history
      ..clear()
      ..addAll(await _repository.loadHistory());
    _loading = false;
    notifyListeners();
    await _startGeofence();
  }

  Future<Coordinates?> captureCoordinates() => _location.currentCoordinates();

  Future<String?> takePhoto() => _photos.takePhoto();

  Future<void> save({
    Coordinates? coordinates,
    String? photoFileName,
    String? note,
  }) async {
    final dropped = <CarLocation>[];
    if (_current case final previous?) {
      _history.insert(0, previous);
      while (_history.length > historyLimit) {
        dropped.add(_history.removeLast());
      }
    }

    final now = DateTime.now();
    _current = CarLocation(
      id: now.microsecondsSinceEpoch.toString(),
      timestamp: now,
      latitude: coordinates?.latitude,
      longitude: coordinates?.longitude,
      photoFileName: photoFileName,
      note: note,
    );
    await _repository.save(_current!);
    await _repository.saveHistory(_history);
    notifyListeners();

    for (final location in dropped) {
      if (location.photoFileName case final photo?) await _photos.delete(photo);
    }
    if (coordinates != null) await _notifications.requestPermission();
    await _startGeofence();
  }

  Future<void> markVisited() async {
    final current = _current;
    if (current == null || current.visited) return;
    _current = current.copyWith(visited: true);
    await _repository.save(_current!);
    await _stopGeofence();
    notifyListeners();
  }

  Future<void> _startGeofence() async {
    await _stopGeofence();
    final current = _current;
    if (current == null || current.visited || !current.hasCoordinates) return;
    if (!await _location.hasPermission()) return;
    _positionSub = _location.watch().listen(
      handlePosition,
      onError: (Object _) {},
    );
  }

  Future<void> _stopGeofence() async {
    await _positionSub?.cancel();
    _positionSub = null;
    _geofenceArmed = false;
  }

  @visibleForTesting
  Future<void> handlePosition(Coordinates position) async {
    final car = _current?.coordinates;
    if (car == null || _current!.visited) return;

    final meters = const Distance().as(
      LengthUnit.Meter,
      LatLng(car.latitude, car.longitude),
      LatLng(position.latitude, position.longitude),
    );
    if (!_geofenceArmed) {
      if (meters > armDistanceMeters) _geofenceArmed = true;
      return;
    }
    if (meters <= arrivalRadiusMeters) {
      await markVisited();
      await _notifications.showArrival();
    }
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }
}
