import 'package:flutter_test/flutter_test.dart';
import 'package:ondeestacionei/utils/date_format.dart';

void main() {
  final now = DateTime(2026, 9, 23, 15, 0);

  test('absolute format', () {
    expect(formatDateTime(DateTime(2026, 1, 5, 8, 7)), '05/01/2026 às 08:07');
  });

  group('relative format', () {
    String format(DateTime t) => formatRelativeDateTime(t, now: now);

    test('today', () {
      expect(format(DateTime(2026, 9, 23, 0, 5)), 'Hoje às 00:05');
    });

    test('yesterday, even if less than 24h ago', () {
      expect(format(DateTime(2026, 9, 22, 23, 59)), 'Ontem às 23:59');
    });

    test('earlier this year omits the year', () {
      expect(format(DateTime(2026, 9, 21, 18, 5)), '21/09 às 18:05');
    });

    test('previous years include the year', () {
      expect(format(DateTime(2025, 12, 31, 9, 30)), '31/12/2025 às 09:30');
    });
  });
}
