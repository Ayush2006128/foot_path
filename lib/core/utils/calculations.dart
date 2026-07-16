class Calculations {
  /// Average stride length in meters
  static const double _strideLengthMeters = 0.762;
  
  /// Average calories burned per step
  static const double _caloriesPerStep = 0.04;

  static double calculateDistanceMeters(int steps) {
    return steps * _strideLengthMeters;
  }

  static double calculateDistanceKm(int steps) {
    return calculateDistanceMeters(steps) / 1000.0;
  }

  static double calculateDistanceMiles(int steps) {
    return calculateDistanceMeters(steps) / 1609.34;
  }

  static double calculateCalories(int steps) {
    return steps * _caloriesPerStep;
  }
}
