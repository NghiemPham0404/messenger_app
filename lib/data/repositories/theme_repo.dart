import 'dart:async';

import 'package:chatting_app/data/models/custom_color_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepo {
  ThemeRepo.internal();

  static final ThemeRepo _instance = ThemeRepo.internal();

  factory ThemeRepo() => _instance;

  // static const _primaryColorKey = 'primaryColor';
  // static const _primaryDarkColorKey = 'primaryDarkColor';
  static const _seletedColorIndex = 'selectedColorPallete';
  static const _seletedBrightModeIndex = 'selectedBrightModePallete';

  Future<int> getSavedColorPalleteIndex() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_seletedColorIndex) ?? 2;
  }

  Future<int> saveSelectedPalleteIndex(int selectedIndex) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_seletedColorIndex, selectedIndex);
    return selectedIndex;
  }

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7)
      buffer.write('ff'); // default alpha
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  List<CustomColorsModel> getPalletes() {
    return [
      CustomColorsModel(primary: Colors.pink, primaryDark: Colors.redAccent),
      CustomColorsModel(primary: Colors.yellow, primaryDark: Colors.orange),
      CustomColorsModel(primary: Colors.greenAccent, primaryDark: Colors.green),
      CustomColorsModel(primary: Colors.cyan, primaryDark: Colors.blue),
      CustomColorsModel(
        primary: Colors.purpleAccent,
        primaryDark: Colors.purple,
      ),
      CustomColorsModel(
        primary: hexToColor("#FC466B"),
        primaryDark: hexToColor("#3F5EFB"),
      ),
      CustomColorsModel(
        primary: hexToColor("#00F260"),
        primaryDark: hexToColor("#0575E6"),
      ),
      CustomColorsModel(
        primary: hexToColor("#22c1c3"),
        primaryDark: hexToColor("#fdbb2d"),
      ),
    ];
  }

  Future<int> getSavedBrightMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_seletedBrightModeIndex) ?? -1;
  }

  Future<int> saveBrightMode(Brightness? brightness) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_seletedBrightModeIndex, brightness?.index ?? -1);
    return brightness?.index ?? -1;
  }

  // int _encodeColor(Color color) => color.value;

  // Color? _decodeColor(int? value) => value != null ? Color(value) : null;

  // Future<void> saveCustomColors(Color primary, Color primaryDark) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt(_primaryColorKey, _encodeColor(primary));
  //   await prefs.setInt(_primaryDarkColorKey, _encodeColor(primaryDark));
  // }

  // void getColorsPallete() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   final primaryValue = prefs.getInt(_primaryColorKey);
  //   final primaryDarkValue = prefs.getInt(_primaryDarkColorKey);

  //   final primaryColor = _decodeColor(primaryValue) ?? Colors.green;
  //   final primaryDarkColor =
  //       _decodeColor(primaryDarkValue) ?? Colors.green[800]!;
  //   final customColorPallete = CustomColorsModel(
  //     primary: primaryColor,
  //     primaryDark: primaryDarkColor,
  //   );
  //   _customColorPallete.add(customColorPallete);
  // }
}
