import 'package:flutter_test/flutter_test.dart';
import 'package:ondeestacionei/models/car_location.dart';
import 'package:ondeestacionei/controllers/parking_controller.dart';

import '../helpers/fakes.dart';

const Coordinates car = (latitude: -23.550000, longitude: -46.633300);
const Coordinates nearCar = (latitude: -23.549820, longitude: -46.633300);
const Coordinates farAway = (latitude: -23.545500, longitude: -46.633300);

void main() {
  late FakeRepository repository;
  late FakeLocationService location;
  late FakePhotoService photos;
  late FakeNotificationService notifications;
  late ParkingController controller;

  setUp(() async {
    repository = FakeRepository();
    location = FakeLocationService();
    photos = FakePhotoService();
    notifications = FakeNotificationService();
    controller = ParkingController(
      repository: repository,
      location: location,
      photos: photos,
      notifications: notifications,
    );
    await controller.load();
  });

  tearDown(() => controller.dispose());

  test(
    'save persists the spot and requires confirmation to overwrite',
    () async {
      expect(controller.needsOverwriteConfirmation, isFalse);

      await controller.save(coordinates: car, photoFileName: 'a.jpg');

      expect(repository.stored?.latitude, car.latitude);
      expect(repository.stored?.photoFileName, 'a.jpg');
      expect(controller.needsOverwriteConfirmation, isTrue);

      await controller.markVisited();
      expect(repository.stored?.visited, isTrue);
      expect(controller.needsOverwriteConfirmation, isFalse);
    },
  );

  group('history', () {
    test(
      'keeps previous spots, most recent first, and persists them',
      () async {
        await controller.save(note: '1');
        await controller.save(note: '2');
        await controller.save(note: '3');

        expect(controller.current?.note, '3');
        expect(controller.history.map((l) => l.note), ['2', '1']);
        expect(repository.storedHistory.map((l) => l.note), ['2', '1']);
      },
    );

    test('is limited to the last three spots', () async {
      for (var i = 1; i <= 6; i++) {
        await controller.save(note: '$i');
      }

      expect(controller.history, hasLength(ParkingController.historyLimit));
      expect(controller.history.map((l) => l.note), ['5', '4', '3']);
    });

    test(
      'photos are deleted only when their spot leaves the history',
      () async {
        for (var i = 1; i <= 4; i++) {
          await controller.save(note: '$i', photoFileName: '$i.jpg');
        }
        expect(photos.deleted, isEmpty);

        await controller.save(note: '5', photoFileName: '5.jpg');

        expect(photos.deleted, ['1.jpg']);
      },
    );

    test('is restored on load', () async {
      await controller.save(note: '1');
      await controller.save(note: '2');

      final reloaded = ParkingController(
        repository: repository,
        location: location,
        photos: photos,
        notifications: notifications,
      );
      await reloaded.load();

      expect(reloaded.history.map((l) => l.note), ['1']);
      reloaded.dispose();
    });
  });

  test('can save without GPS', () async {
    await controller.save(note: 'Piso 2');

    expect(controller.current?.hasCoordinates, isFalse);
    expect(controller.current?.note, 'Piso 2');
  });

  group('geofence', () {
    setUp(() => controller.save(coordinates: car));

    test('does not trigger while still next to the car after saving', () async {
      await controller.handlePosition(nearCar);

      expect(controller.current?.visited, isFalse);
      expect(notifications.arrivals, 0);
    });

    test(
      'marks visited and notifies when returning after walking away',
      () async {
        await controller.handlePosition(farAway);
        expect(controller.current?.visited, isFalse);

        await controller.handlePosition(nearCar);

        expect(controller.current?.visited, isTrue);
        expect(repository.stored?.visited, isTrue);
        expect(notifications.arrivals, 1);
      },
    );

    test('reacts to the live position stream', () async {
      location.positions
        ..add(farAway)
        ..add(nearCar);
      await pumpEventQueue();

      expect(controller.current?.visited, isTrue);
    });
  });
}
