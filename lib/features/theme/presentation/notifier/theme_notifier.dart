import 'package:pulse_chat/features/theme/domain/entity/custom_color_model.dart';
import 'package:flutter/material.dart';
import 'package:pulse_chat/features/theme/domain/usecase/get_brightness_mode.dart';
import 'package:pulse_chat/features/theme/domain/usecase/get_color_palletes.dart';
import 'package:pulse_chat/features/theme/domain/usecase/get_saved_color_pallete.dart';
import 'package:pulse_chat/features/theme/domain/usecase/save_brightness_mode.dart';
import 'package:pulse_chat/features/theme/domain/usecase/save_color_pallete.dart';

class ThemeNotifier extends ChangeNotifier {
  // properties for app color theme
  late Color _primaryColor = Colors.green;
  Color get primaryColor => _primaryColor;

  late Color _primaryDarkColor = Colors.greenAccent;
  Color get primaryDarkColor => _primaryDarkColor;

  List<CustomColorsModel> _colorModels = [];
  List<CustomColorsModel> get colorModels => _colorModels;
  int selectedIndex = 2;

  // properties for app bright mode
  int _currentBrightModeIndex = -1;
  Brightness? _currentBrightMode;
  Brightness? get currentBrightMode => _currentBrightMode;
  // usecases
  final GetSavedColorPallete _getSavedColorPallete;
  final SaveColorPallete _saveColorPallete;
  final GetColorPalletes _getColorPalletes;
  final GetBrightnessMode _getBrightnessMode;
  final SaveBrightnessMode _saveBrightnessMode;

  ThemeNotifier(
    this._getSavedColorPallete,
    this._saveColorPallete,
    this._getColorPalletes,
    this._getBrightnessMode,
    this._saveBrightnessMode,
  ) {
    _colorModels = _getColorPalletes();
    _loadColorPallete();
    _loadBrightMode();
  }

  void _loadColorPallete() async {
    selectedIndex = await _getSavedColorPallete();
    _primaryColor = _colorModels[selectedIndex].primary;
    _primaryDarkColor = _colorModels[selectedIndex].primaryDark;
    notifyListeners();
  }

  void _loadBrightMode() async {
    _currentBrightModeIndex = await _getBrightnessMode();
    if (_currentBrightModeIndex == -1) {
      _currentBrightMode = null;
    } else {
      _currentBrightMode = Brightness.values[_currentBrightModeIndex];
    }
    notifyListeners();
  }

  void changeColorPallete(int selectedIndex) {
    _primaryColor = _colorModels[selectedIndex].primary;
    _primaryDarkColor = _colorModels[selectedIndex].primaryDark;
    this.selectedIndex = selectedIndex;
    _saveColorPallete(selectedIndex);
    notifyListeners();
  }

  void changeBrightMode(Brightness? brightness) {
    _currentBrightMode = brightness;
    _saveBrightnessMode(brightness);
    notifyListeners();
  }
}
