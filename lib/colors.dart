import 'package:flutter/material.dart';

const backgroundColor = Color.fromRGBO(36, 36, 36, 1);
const buttonColor = Color.fromRGBO(251, 148, 4, 0.995);
const footerColor = Color.fromRGBO(26, 26, 26, 1);
const secondaryBackgroundColor = Color.fromRGBO(46, 46, 46, 1);


class ecolor {
  ecolor._();
  //App basic colors

  static const Color primary = Color(0xFF4B68FF);
  static const Color secondary = Colors.yellow;
  static const Color tertiary = Color(0xFFb0c7ff);

  //Text basic colors

  static const Color textprimary = Color(0xFF333333);
  static const Color textsecondary = Color(0xFF6C7570);
  static const Color white = Colors.white;

// Background colors

  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFFF272727);
  static const Color primarybackground = Color(0xFFF3F5FF);

//Background container colors

  static const Color lightcontainer = Color(0xFFF6F6F6);
  static const Color darkcontainer = ecolor.white;

//Linear Gradient
  static const Gradient lineargradient = LinearGradient(
    begin:Alignment(0.0, 0.0),
    end: Alignment(0.707,-0.707),
    colors: [
    Color(0xffff9a9e),
    Color(0xffffad0c4),
    Color(0xffffad0c4),
  ]);
  
}
