import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class Common {
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
      errorStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade600),
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
      double? fontSize,
      Size? size,
      double? circular}) {
    return ButtonStyle(
        foregroundColor: MaterialStateColor.resolveWith(
            (states) => (textColor == null) ? Colors.black : textColor),
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: (fontSize == null) ? 20 : fontSize)),
        backgroundColor: MaterialStateProperty.all(
            (backgroundColor == null) ? Colors.white : backgroundColor),
        fixedSize: MaterialStateProperty.all(size ?? const Size(300, 58)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(circular ?? 27),
                side: BorderSide(
                    color: (boderSideColor == null)
                        ? Colors.white
                        : boderSideColor))));
  }

  static Container circularProgress({Color? valueColor}) {
    return Container(
        color: const Color.fromARGB(127, 171, 194, 218).withOpacity(0.5),
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation(valueColor ?? Colors.blue.shade700),
          ),
        ));
  }

  static Container linearProgress({Color? valueColor}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 10),
      child: LinearProgressIndicator(
        minHeight: 3,
        borderRadius: BorderRadius.circular(50),
        valueColor: AlwaysStoppedAnimation(valueColor ?? Colors.blue.shade700),
      ),
    );
  }

  static Future<String> imageFileToBlob(File imageFile) async {
    try {
      // Read the file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();
      // Convert the bytes to a base64-encoded string
      String base64String = base64Encode(imageBytes);
      return base64String;
    } catch (e) {
      // Handle any errors
      print("Error converting image to BLOB: $e");
      return '';
    }
  }

  /// Converts a base64-encoded string (BLOB) back to an Image widget.
  static Future<MemoryImage> blobToImageWidget(String base64String) async {
    return MemoryImage(base64Decode(base64String));
  }

  static Future<File> compressImageIfLarge(File imageFile,
      {int maxSize = 2097000}) async {
    int fileSize = await imageFile.length();

    // Check if the image size exceeds the maxSize
    if (fileSize > maxSize) {
      // Calculate the compression ratio based on the current size
      double ratio = maxSize / fileSize;

      // Compress the image with the calculated ratio
      List<int> compressedBytes = (await FlutterImageCompress.compressWithFile(
        imageFile.path,
        quality: (100 * ratio).round(), // Adjust quality based on ratio
      )) as List<int>;

      // Write the compressed bytes to a new file
      File compressedFile =
          File(imageFile.path.replaceAll('.jpg', '_compressed.jpg'));
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    }

    // Return the original file if no compression is needed
    return imageFile;
  }

  static Future<File> compressImage(File imageFile) async {
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '${imageFile.parent.path}/compressed_${imageFile.uri.pathSegments.last}',
      quality: 50, // Compression quality (0-100)
    );

    return compressedImage ?? imageFile;
  }
}
