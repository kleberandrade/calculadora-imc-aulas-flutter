import 'package:calculadora_imc/domain/bmi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('metric formula and both height units agree', () {
    final cm = BodyMeasurements.parse('70', '175', HeightUnit.centimeters);
    final meters = BodyMeasurements.parse('70', '1,75', HeightUnit.meters);
    expect(cm.bmi, closeTo(22.857142857, 0.000000001));
    expect(meters.bmi, cm.bmi);
    expect(cm.category, BmiCategory.healthyWeight);
  });

  test('decimal comma, dot and surrounding whitespace are accepted', () {
    expect(
      BodyMeasurements.parse(' 70,5 ', '1.75', HeightUnit.meters).weightKg,
      70.5,
    );
  });

  test('invalid numbers are rejected at the boundary', () {
    for (final value in [
      '',
      ' ',
      'abc',
      'NaN',
      'Infinity',
      '-Infinity',
      '0',
      '-1',
      '1e2',
      '1,2.3',
      '1 000',
      '.5',
      '70kg',
    ]) {
      expect(
        () => BodyMeasurements.parse(value, '175', HeightUnit.centimeters),
        throwsFormatException,
        reason: 'weight: $value',
      );
      expect(
        () => BodyMeasurements.parse('70', value, HeightUnit.centimeters),
        throwsFormatException,
        reason: 'height: $value',
      );
    }
  });

  test('operational limits include endpoints and reject values outside', () {
    for (final kg in ['20', '500']) {
      for (final cm in ['100', '250']) {
        expect(
          BodyMeasurements.parse(kg, cm, HeightUnit.centimeters).bmi.isFinite,
          isTrue,
        );
      }
    }
    for (final kg in ['19.99', '500.01']) {
      expect(
        () => BodyMeasurements.parse(kg, '175', HeightUnit.centimeters),
        throwsFormatException,
      );
    }
    for (final cm in ['99.99', '250.01']) {
      expect(
        () => BodyMeasurements.parse('70', cm, HeightUnit.centimeters),
        throwsFormatException,
      );
    }
    expect(
      BodyMeasurements.parse('70', '1', HeightUnit.meters).heightMeters,
      1,
    );
    expect(
      BodyMeasurements.parse('70', '2,5', HeightUnit.meters).heightMeters,
      2.5,
    );
    expect(
      () => BodyMeasurements.parse('70', '0.999', HeightUnit.meters),
      throwsFormatException,
    );
    expect(
      () => BodyMeasurements.parse('70', '2.501', HeightUnit.meters),
      throwsFormatException,
    );
    expect(
      () => BodyMeasurements.parse('70', '175', HeightUnit.meters),
      throwsFormatException,
    );
    expect(
      () => BodyMeasurements.parse('70', '1.75', HeightUnit.centimeters),
      throwsFormatException,
    );
  });

  test('every adult threshold uses the unrounded BMI', () {
    const boundaries = [18.5, 25.0, 30.0, 35.0, 40.0];
    for (var i = 0; i < boundaries.length; i++) {
      final boundary = boundaries[i];
      // At one metre, weight and BMI are equal; 18.5 is below the input
      // weight limit, so classification is tested independently of parsing.
      expect(BmiCategory.fromBmi(boundary - 0.000001), BmiCategory.values[i]);
      expect(BmiCategory.fromBmi(boundary), BmiCategory.values[i + 1]);
      expect(
        BmiCategory.fromBmi(boundary + 0.000001),
        BmiCategory.values[i + 1],
      );
    }
    expect(BmiCategory.fromBmi(24.99999), BmiCategory.healthyWeight);
    for (final bmi in [0.0, -1.0, double.nan, double.infinity]) {
      expect(() => BmiCategory.fromBmi(bmi), throwsArgumentError);
    }
  });
}
