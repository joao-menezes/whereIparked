import 'dart:async';
import 'dart:io';

import 'package:ondeestacionei/data/car_location_repository.dart';
import 'package:ondeestacionei/models/car_location.dart';
import 'package:ondeestacionei/services/location_service.dart';
import 'package:ondeestacionei/services/navigation_launcher.dart';
import 'package:ondeestacionei/services/notification_service.dart';
import 'package:ondeestacionei/services/photo_service.dart';

class FakeRepository implements CarLocationRepository {
  CarLocation? stored;
  List<CarLocation> storedHistory = [];

  @override
  Future<CarLocation?> load() async => stored;

  @override
  Future<void> save(CarLocation location) async => stored = location;

  @override
  Future<List<CarLocation>> loadHistory() async => List.of(storedHistory);

  @override
  Future<void> saveHistory(List<CarLocation> history) async =>
      storedHistory = List.of(history);
}

class FakeLocationService implements LocationService {
  Coordinates? nextCoordinates;
  bool permission = true;
  final positions = StreamController<Coordinates>.broadcast();

  @override
  Future<bool> hasPermission() async => permission;

  @override
  Future<Coordinates?> currentCoordinates() async => nextCoordinates;

  @override
  Stream<Coordinates> watch() => positions.stream;
}

class FakePhotoService implements PhotoService {
  String? nextPhoto;
  final deleted = <String>[];

  @override
  Future<void> init() async {}

  @override
  File fileFor(String fileName) => File(fileName);

  @override
  Future<String?> takePhoto() async => nextPhoto;

  @override
  Future<void> delete(String fileName) async => deleted.add(fileName);
}

class FakeNotificationService implements NotificationService {
  int arrivals = 0;

  @override
  Future<void> init() async {}

  @override
  Future<void> requestPermission() async {}

  @override
  Future<void> showArrival() async => arrivals++;
}

class FakeNavigationLauncher implements NavigationLauncher {
  @override
  Future<bool> openGoogleMaps(Coordinates c) async => true;

  @override
  Future<bool> openWaze(Coordinates c) async => true;
}
