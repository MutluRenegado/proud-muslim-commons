import 'package:flutter/material.dart';

import '../models/tasbih_model.dart';

class ZakatProvider extends ChangeNotifier {
  ZakatCalculation _calc = ZakatCalculation();

  ZakatCalculation get calc => _calc;

  void updateValues({
    double? cash,
    double? goldGrams,
    double? goldPricePerGram,
    double? silverGrams,
    double? silverPricePerGram,
    double? stocksAndInvestments,
    double? businessGoods,
    double? moneyOwedToYou,
    double? immediateDebts,
    double? expenses,
    String? currency,
  }) {
    _calc = ZakatCalculation(
      cash: cash ?? _calc.cash,
      goldGrams: goldGrams ?? _calc.goldGrams,
      goldPricePerGram: goldPricePerGram ?? _calc.goldPricePerGram,
      silverGrams: silverGrams ?? _calc.silverGrams,
      silverPricePerGram: silverPricePerGram ?? _calc.silverPricePerGram,
      stocksAndInvestments: stocksAndInvestments ?? _calc.stocksAndInvestments,
      businessGoods: businessGoods ?? _calc.businessGoods,
      moneyOwedToYou: moneyOwedToYou ?? _calc.moneyOwedToYou,
      immediateDebts: immediateDebts ?? _calc.immediateDebts,
      expenses: expenses ?? _calc.expenses,
      currency: currency ?? _calc.currency,
    );
    notifyListeners();
  }

  void reset() {
    _calc = ZakatCalculation();
    notifyListeners();
  }
}
