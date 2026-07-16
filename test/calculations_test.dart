import 'package:flutter_test/flutter_test.dart';
import 'package:foot_path/core/utils/calculations.dart';

void main() {
  group('Calculations', () {
    test('calculateDistanceMeters returns correct value', () {
      expect(Calculations.calculateDistanceMeters(1000), 762.0);
    });

    test('calculateDistanceKm returns correct value', () {
      expect(Calculations.calculateDistanceKm(1000), 0.762);
    });

    test('calculateDistanceMiles returns correct value', () {
      final miles = Calculations.calculateDistanceMiles(1000);
      // 762 / 1609.34 = 0.473486
      expect(miles, closeTo(0.473, 0.001));
    });

    test('calculateCalories returns correct value', () {
      expect(Calculations.calculateCalories(1000), 40.0);
    });
  });
}
