/// Metric height units accepted at the input boundary.
enum HeightUnit {
  centimeters('cm', 100, 100, 250),
  meters('m', 1, 1, 2.5);

  const HeightUnit(this.symbol, this.divisor, this.minimum, this.maximum);
  final String symbol;
  final double divisor;
  final double minimum;
  final double maximum;
}

/// General CDC categories for adults 20+, not a diagnosis.
enum BmiCategory {
  underweight('Abaixo do peso', 'Menor que 18,5'),
  healthyWeight('Peso saudável', '18,5 a menos de 25'),
  overweight('Sobrepeso', '25 a menos de 30'),
  obesityOne('Obesidade · classe 1', '30 a menos de 35'),
  obesityTwo('Obesidade · classe 2', '35 a menos de 40'),
  obesityThree('Obesidade · classe 3', '40 ou mais');

  const BmiCategory(this.label, this.range);
  final String label;
  final String range;

  static BmiCategory fromBmi(double bmi) {
    if (!bmi.isFinite || bmi <= 0) {
      throw ArgumentError.value(bmi, 'bmi', 'Must be finite and positive');
    }
    const thresholds = [18.5, 25.0, 30.0, 35.0, 40.0];
    for (var i = 0; i < thresholds.length; i++) {
      if (bmi < thresholds[i]) return values[i];
    }
    return obesityThree;
  }
}

/// Validated, immutable values. UI input limits are operational, not medical.
final class BodyMeasurements {
  const BodyMeasurements._(this.weightKg, this.heightMeters);

  factory BodyMeasurements.parse(
    String weight,
    String height,
    HeightUnit unit,
  ) {
    return BodyMeasurements._(parseWeight(weight), parseHeight(height, unit));
  }

  final double weightKg;
  final double heightMeters;

  double get bmi => weightKg / (heightMeters * heightMeters);
  BmiCategory get category => BmiCategory.fromBmi(bmi);

  static double parseWeight(String text) => _parseNumber(text, 20, 500, 'kg');

  static double parseHeight(String text, HeightUnit unit) =>
      _parseNumber(text, unit.minimum, unit.maximum, unit.symbol) /
      unit.divisor;

  static double _parseNumber(String text, double min, double max, String unit) {
    final normalized = text.trim().replaceAll(',', '.');
    if (!RegExp(r'^\d+(?:\.\d+)?$').hasMatch(normalized)) {
      throw const FormatException(
        'Informe um número; use vírgula ou ponto decimal.',
      );
    }
    final value = double.tryParse(normalized);
    if (value == null || !value.isFinite || value < min || value > max) {
      final minimum = min
          .toStringAsFixed(min == min.roundToDouble() ? 0 : 1)
          .replaceAll('.', ',');
      final maximum = max
          .toStringAsFixed(max == max.roundToDouble() ? 0 : 1)
          .replaceAll('.', ',');
      throw FormatException('Use de $minimum a $maximum $unit.');
    }
    return value;
  }
}
