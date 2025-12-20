import 'package:flutter/services.dart';

class IndianMobileFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. If the user is deleting text, allow it always.
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 2. If the user is typing the VERY FIRST character...
    if (newValue.text.length == 1) {
      // ...check if it is 6, 7, 8, or 9.
      if (RegExp(r'^[6-9]$').hasMatch(newValue.text)) {
        return newValue; // Allow it
      } else {
        // REJECT IT: Return the old value (effectively ignoring the key press)
        return oldValue;
      }
    }

    // 3. For 2nd digit onwards, allow any number (handled by keyboard type)
    return newValue;
  }
}
