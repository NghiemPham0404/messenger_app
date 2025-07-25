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

  List<CustomColorsModel> getPalletes() {
    return [
      CustomColorsModel(primary: Colors.pink, primaryDark: Colors.redAccent),
      CustomColorsModel(
        primary: Colors.orange,
        primaryDark: Colors.orangeAccent,
      ),
      CustomColorsModel(primary: Colors.green, primaryDark: Colors.greenAccent),
      CustomColorsModel(primary: Colors.blue, primaryDark: Colors.cyan),
      CustomColorsModel(
        primary: Colors.purple,
        primaryDark: Colors.purpleAccent,
      ),
      CustomColorsModel(primary: Colors.purple, primaryDark: Colors.pink),
      CustomColorsModel(primary: Colors.cyanAccent, primaryDark: Colors.orange),
      CustomColorsModel(primary: Colors.pink, primaryDark: Colors.orange),
      CustomColorsModel(primary: Colors.purple, primaryDark: Colors.indigo),
      CustomColorsModel(
        primary: Colors.cyanAccent,
        primaryDark: Colors.greenAccent,
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
