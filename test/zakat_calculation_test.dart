import 'package:flutter_test/flutter_test.dart';
import 'package:deen_path/models/tasbih_model.dart';

void main() {
  group('Zakat Calculator Tests', () {
    test('Calculates 2.5% zakat correctly when Nisab is met', () {
      final calc = ZakatCalculation(
        cash: 10000,
        goldGrams: 0,
        goldPricePerGram: 75,
        stocksAndInvestments: 5000,
        immediateDebts: 1000,
      );

      // Total zakatable = 10000 + 5000 - 1000 = 14000
      // Gold nisab threshold = 87.48 * 75 = 6561
      expect(calc.isNisabReached, isTrue);
      expect(calc.netZakatableWealth, 14000);
      expect(calc.zakatPayable, 14000 * 0.025); // 350.0
    });

    test('Returns 0 zakat when wealth is below Nisab threshold', () {
      final calc = ZakatCalculation(
        cash: 1000,
        goldGrams: 0,
        goldPricePerGram: 75,
      );
      expect(calc.isNisabReached, isFalse);
      expect(calc.zakatPayable, 0.0);
    });
  });
}
