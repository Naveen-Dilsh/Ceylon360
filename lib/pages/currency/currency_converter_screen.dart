import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Added Currency class for better organization
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

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _result = 0;
  bool _isLoading = false;

  // Enhanced currencies list with names and flags
  final List<Currency> currencies = [
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

  // Using Currency objects instead of strings
  late Currency _fromCurrency;
  late Currency _toCurrency;

  @override
  void initState() {
    super.initState();
    _fromCurrency = currencies.firstWhere((c) => c.code == 'USD');
    _toCurrency = currencies.firstWhere((c) => c.code == 'LKR');
  }

  void _convertCurrency() {
    if (_amountController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      double amount = double.parse(_amountController.text);
      double fromRate = _fromCurrency.rate;
      double toRate = _toCurrency.rate;

      // Convert to USD first, then to target currency
      double result = amount * (toRate / fromRate);

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method to format numbers with commas
  String _formatNumber(double number) {
    return number.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match match) => '${match[1]},');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        backgroundColor: const Color(0xFF08746C),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF8F8F8),
        // Wrapped in SingleChildScrollView to fix overflow
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Currency card with cleaner UI
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF08746C), Color(0xFF2C6E49)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Currency',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_balance,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Real-time rates',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Convert Amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Improved From Currency Input with flags
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: DropdownButton<String>(
                              value: _fromCurrency.code,
                              dropdownColor: const Color(0xFF08746C),
                              underline: Container(),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _fromCurrency = currencies.firstWhere((c) => c.code == newValue);
                                  });
                                }
                              },
                              items: currencies.map<DropdownMenuItem<String>>((Currency currency) {
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
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                // Swap currencies
                                final temp = _fromCurrency;
                                _fromCurrency = _toCurrency;
                                _toCurrency = temp;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.swap_vert,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Converted Amount',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  DropdownButton<String>(
                                    value: _toCurrency.code,
                                    dropdownColor: const Color(0xFF08746C),
                                    underline: Container(),
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _toCurrency = currencies.firstWhere((c) => c.code == newValue);
                                        });
                                      }
                                    },
                                    items: currencies.map<DropdownMenuItem<String>>((Currency currency) {
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
                                    }).toList(),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _isLoading ? 'Calculating...' : _formatNumber(_result),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Added Exchange Rate Info Widget
                _buildRateInfo(),

                const SizedBox(height: 20),

                // Convert button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _convertCurrency,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF08746C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Convert'),
                  ),
                ),

                const SizedBox(height: 30),

                // Recent conversions
                const Text(
                  'Recent Conversions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Recent conversions list
                _buildRecentConversion('USD', 'LKR', 100, 32542),
                _buildRecentConversion('EUR', 'USD', 50, 54.52),

                const SizedBox(height: 30),

                // Popular currencies
                const Text(
                  'Popular Currencies',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Made row wrap in case it overflows horizontally
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    _buildCurrencyChip('USD', 'dollar', '🇺🇸'),
                    _buildCurrencyChip('EUR', 'euro', '🇪🇺'),
                    _buildCurrencyChip('GBP', 'pound', '🇬🇧'),
                    _buildCurrencyChip('JPY', 'yen', '🇯🇵'),
                  ],
                ),

                // Add padding at the bottom to ensure no overflow
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // New method to display current exchange rate
  Widget _buildRateInfo() {
    final double rate = _toCurrency.rate / _fromCurrency.rate;

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
            '1 ${_fromCurrency.code} = ${rate.toStringAsFixed(4)} ${_toCurrency.code}',
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

  Widget _buildRecentConversion(String from, String to, double amount, double result) {
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
                '${_formatNumber(result)} $to',
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

  // Enhanced currency chip with flag
  Widget _buildCurrencyChip(String currency, String name, String flag) {
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
}