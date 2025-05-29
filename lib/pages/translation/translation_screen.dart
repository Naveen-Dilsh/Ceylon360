import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({Key? key}) : super(key: key);

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';
  String _fromLanguage = 'English';
  String _toLanguage = 'Sinhala';
  bool _isLoading = false;

  final Map<String, String> _languageFlags = {
    'English': '🇬🇧',
    'Sinhala': '🇱🇰',
    'Tamil': '🇮🇳',
    'Arabic': '🇸🇦',
    'Hindi': '🇮🇳',
    'Chinese': '🇨🇳',
    'French': '🇫🇷',
    'Spanish': '🇪🇸',
    'German': '🇩🇪',
    'Japanese': '🇯🇵',
  };

  final List<String> _languages = [
    'English',
    'Sinhala',
    'Tamil',
    'Arabic',
    'Hindi',
    'Chinese',
    'French',
    'Spanish',
    'German',
    'Japanese',
  ];

  void _swapLanguages() {
    setState(() {
      final temp = _fromLanguage;
      _fromLanguage = _toLanguage;
      _toLanguage = temp;
      _textController.clear();
      _translatedText = '';
    });
  }

  Future<void> _translateText() async {
    if (_textController.text.isEmpty) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    final String translatedResult =
        '${_textController.text} (translated to $_toLanguage)';

    setState(() {
      _translatedText = translatedResult;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget _buildDropdown(String label, String selectedValue,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down),
            items: _languages.map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Row(
                  children: [
                    Text(_languageFlags[lang] ?? ''),
                    const SizedBox(width: 8),
                    Text(lang),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Language Translator'),
        backgroundColor: const Color(0xFF08746C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Language Selection
            Row(
              children: [
                Expanded(
                  child: _buildDropdown('From', _fromLanguage, (value) {
                    if (value != null) setState(() => _fromLanguage = value);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    onPressed: _swapLanguages,
                    icon: const Icon(Icons.swap_horiz_rounded,
                        color: Color(0xFF08746C), size: 28),
                    tooltip: 'Swap Languages',
                  ),
                ),
                Expanded(
                  child: _buildDropdown('To', _toLanguage, (value) {
                    if (value != null) setState(() => _toLanguage = value);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Input Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_languageFlags[_fromLanguage] ?? ''} $_fromLanguage',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter text to translate...',
                      border: InputBorder.none,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Wrap(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.mic, color: Color(0xFF08746C)),
                          onPressed: () {
                            // Voice input
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _textController.clear();
                            setState(() {
                              _translatedText = '';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Translate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _translateText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF08746C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Translate',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 25),

            // Output Area
            if (_translatedText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_languageFlags[_toLanguage] ?? ''} $_toLanguage',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _translatedText,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Wrap(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up,
                                color: Color(0xFF08746C)),
                            onPressed: () {
                              // TTS
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy,
                                color: Color(0xFF08746C)),
                            onPressed: () {
                              // Clipboard copy
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Text copied to clipboard'),
                                  backgroundColor: Color(0xFF08746C),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
