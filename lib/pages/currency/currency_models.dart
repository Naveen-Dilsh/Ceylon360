import 'package:flutter/material.dart';

/// Model class representing a currency with its details
class Currency {
  final String code;
  final String name;
  final String flag;
  final double rate; // Exchange rate relative to USD

  Currency({
    required this.code,
    required this.name,
    required this.flag,
    required this.rate,
  });
}

/// List of supported currencies with their data
class CurrencyData {
  static List<Currency> getCurrencies() {
    return [
      Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸', rate: 1.0),
      Currency(code: 'LKR', name: 'Sri Lankan Rupee', flag: '🇱🇰', rate: 325.42),
      Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺', rate: 0.92),
      Currency(code: 'GBP', name: 'British Pound', flag: '🇬🇧', rate: 0.79),
      Currency(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵', rate: 150.24),
      Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺', rate: 1.52),
      Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦', rate: 1.36),
      Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳', rate: 82.93),
      Currency(code: 'SGD', name: 'Singapore Dollar', flag: '🇸🇬', rate: 1.35),
      Currency(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳', rate: 7.24),
    ];
  }
}