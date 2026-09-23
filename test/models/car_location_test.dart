import 'package:flutter_test/flutter_test.dart';
import 'package:ondeestacionei/models/car_location.dart';

void main() {
  test('JSON round trip keeps all fields', () {
    final original = CarLocation(
      id: '1',
      timestamp: DateTime(2026, 9, 23, 10, 30),
      latitude: -23.5505,
      longitude: -46.6333,
      photoFileName: 'car_1.jpg',
      note: 'Piso 2',
      visited: true,
    );

    final restored = CarLocation.fromJson(original.toJson());

    expect(restored.toJson(), original.toJson());
  });

  test('spot saved without GPS has no coordinates', () {
    final location = CarLocation.fromJson({
      'id': '2',
      'timestamp': DateTime(2026).toIso8601String(),
      'note': 'Vaga 34',
    });

    expect(location.hasCoordinates, isFalse);
    expect(location.coordinates, isNull);
    expect(location.visited, isFalse);
  });
}
