import 'package:flutter/material.dart';
import 'package:pulse_chat/features/theme/domain/entity/custom_color_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalStorage {
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
}
