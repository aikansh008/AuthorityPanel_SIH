import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THelperFunctions {
  static Color? getColor(String value) {
    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      // Fallback if context is null
      print('Snackbar: $message');
    }
  }

  static void showAlert(String title, String message) {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Fallback if context is null
      print('Alert - $title: $message');
    }
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    if (Get.context != null) {
      return MediaQuery.of(Get.context!).size;
    } else {
      return const Size(0, 0); // Fallback size
    }
  }

  static double screenHeight() {

      return MediaQuery.of(Get.context!).size.height;
    
  }

  static double screenWidth() {
    if (Get.context != null) {
      return MediaQuery.of(Get.context!).size.width;
    } else {
      return 0; // Fallback width
    }
  }

 

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }
}
