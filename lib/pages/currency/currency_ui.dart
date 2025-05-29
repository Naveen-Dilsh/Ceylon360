import 'package:flutter/material.dart';
import 'currency_models.dart';
import 'currency_services.dart';

/// Class containing reusable UI components for the currency converter
class CurrencyUI {
  /// Builds information about the current exchange rate
  static Widget buildRateInfo(Currency fromCurrency, Currency toCurrency) {
    final double rate = CurrencyService.getExchangeRate(fromCurrency, toCurrency);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '1 ${fromCurrency.code} = ${rate.toStringAsFixed(4)} ${toCurrency.code}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.info_outline, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  /// Builds a recent conversion item widget
  static Widget buildRecentConversion(String from, String to, double amount, double result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE6F0EE),
                radius: 20,
                child: Text(
                  from,
                  style: const TextStyle(
                    color: Color(0xFF08746C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward,
                color: Color(0xFF08746C),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: const Color(0xFFE6F0EE),
                radius: 20,
                child: Text(
                  to,
                  style: const TextStyle(
                    color: Color(0xFF08746C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amount $from',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${CurrencyService.formatNumber(result)} $to',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a currency chip widget showing flag and code
  static Widget buildCurrencyChip(String currency, String name, String flag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Make sure row doesn't expand unnecessarily
        children: [
          Text(
            flag,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 5),
          Text(
            currency,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a currency dropdown item for selection
  static DropdownMenuItem<String> buildCurrencyDropdownItem(Currency currency) {
    return DropdownMenuItem<String>(
      value: currency.code,
      child: Row(
        children: [
          Text(currency.flag),
          const SizedBox(width: 5),
          Text(currency.code),
        ],
      ),
    );
  }
}