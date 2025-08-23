import 'package:flutter/material.dart';
import 'package:pulse_chat/features/theme/data/source/local/theme_local_storage.dart';
import 'package:pulse_chat/features/theme/domain/entity/custom_color_model.dart';
import 'package:pulse_chat/features/theme/domain/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalStorage _themeLocalStorage;

  ThemeRepositoryImpl(this._themeLocalStorage);

  @override
  Future<int> getSavedColorPalleteIndex() {
    return _themeLocalStorage.getSavedColorPalleteIndex();
  }

  @override
  Future<int> saveSelectedPalleteIndex(int selectedIndex) {
    return _themeLocalStorage.saveSelectedPalleteIndex(selectedIndex);
  }

  @override
  List<CustomColorsModel> getPalletes() {
    return _themeLocalStorage.getPalletes();
  }

  @override
  Future<int> getSavedBrightMode() {
    return _themeLocalStorage.getSavedBrightMode();
  }

  @override
  Future<int> saveBrightMode(Brightness? brightness) {
    return _themeLocalStorage.saveBrightMode(brightness);
  }
}
