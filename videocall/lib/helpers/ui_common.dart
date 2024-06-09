import 'package:flutter/material.dart';

class UICommon {
  static InputDecoration customDecoration(
      {required String? labelText, IconData? prefixIcon}) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.black),
      prefixIcon: Icon(
        (prefixIcon == null) ? null : prefixIcon,
        color: Colors.black,
      ),
      focusedBorder: const UnderlineInputBorder(),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 0.6),
      ),
      errorStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  static void customScaffoldMessager(
      {required BuildContext context,
      required String message,
      Color? backgroundColor,
      Duration? duration}) {
    // Hide the current SnackBar if any
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(milliseconds: 2800),
      backgroundColor: backgroundColor ?? Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    ));
  }

  static ButtonStyle customButtonStyle(
      {Color? backgroundColor,
      Color? boderSideColor,
      Color? textColor,
      double? fontSize}) {
    return ButtonStyle(
        foregroundColor: MaterialStateColor.resolveWith(
            (states) => (textColor == null) ? Colors.black : textColor),
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: (fontSize == null) ? 20 : fontSize)),
        backgroundColor: MaterialStateProperty.all(
            (backgroundColor == null) ? Colors.white : backgroundColor),
        fixedSize: MaterialStateProperty.all(const Size(300, 58)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
                side: BorderSide(
                    color: (boderSideColor == null)
                        ? Colors.white
                        : boderSideColor))));
  }
}
