import 'dart:convert';
import 'package:http/http.dart' as http;
import 'currency_models.dart';

/// Class that handles currency conversion logic
class CurrencyService {
  /// Converts an amount from one currency to another
  /// Returns the converted amount
  static double convertCurrency(
      double amount,
      Currency fromCurrency,
      Currency toCurrency
      ) {
    // Convert to USD first, then to target currency
    return amount * (toCurrency.rate / fromCurrency.rate);
  }

  /// Helper method to format numbers with commas
  static String formatNumber(double number) {
    return number.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match match) => '${match[1]},');
  }

  /// Calculates the exchange rate between two currencies
  static double getExchangeRate(Currency fromCurrency, Currency toCurrency) {
    return toCurrency.rate / fromCurrency.rate;
  }

// Note: This class could be expanded to include actual API calls
// for real-time exchange rates in the future
}