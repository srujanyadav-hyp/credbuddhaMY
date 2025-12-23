import 'package:flutter/services.dart';

class IndianMobileFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (newValue.text.length == 1) {
      if (RegExp(r'^[6-9]$').hasMatch(newValue.text)) {
        return newValue; // Allow it
      } else {
        return oldValue;
      }
    }

    // 3. For 2nd digit onwards, allow any number (handled by keyboard type)
    return newValue;
  }
}

// IndianPanCard formater

class PanCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.toUpperCase();

    if (newText.length > 10) return oldValue;

    for (int i = 0; i < newText.length; i++) {
      String char = newText[i];

      if (i < 5) {
        if (!RegExp(r'[A-Z]').hasMatch(char)) return oldValue;
      } else if (i >= 5 && i < 9) {
        if (!RegExp(r'[0-9]').hasMatch(char)) return oldValue;
      } else if (i == 9) {
        if (!RegExp(r'[A-Z]').hasMatch(char)) return oldValue;
      }
    }

    return newValue.copyWith(text: newText, selection: newValue.selection);
  }
}
