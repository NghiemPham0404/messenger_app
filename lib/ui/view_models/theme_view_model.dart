import 'package:chatting_app/data/models/custom_color_model.dart';
import 'package:chatting_app/data/repositories/theme_repo.dart';
import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {
  final _repo = ThemeRepo();

  bool _loaded = false;
  bool get isLoaded => _loaded;

  // properties for app color theme
  late Color _primaryColor;
  Color get primaryColor => _primaryColor;

  late Color _primaryDarkColor;
  Color get primaryDarkColor => _primaryDarkColor;

  List<CustomColorsModel> _colorModels = [];
  List<CustomColorsModel> get colorModels => _colorModels;
  int selectedIndex = 2;

  // properties for app bright mode
  int _currentBrightModeIndex = -1;
  Brightness? _currentBrightMode;
  Brightness? get currentBrightMode => _currentBrightMode;

  ThemeViewModel() {
    initialize();
  }

  void initialize() async {
    // get color palletes and seleted color pallete
    _colorModels = _repo.getPalletes();
    selectedIndex = await _repo.getSavedColorPalleteIndex();
    _primaryColor = _colorModels[selectedIndex].primary;
    _primaryDarkColor = _colorModels[selectedIndex].primaryDark;

    // get brightness mode
    _currentBrightModeIndex = await _repo.getSavedBrightMode();
    _currentBrightMode =
        (_currentBrightModeIndex == -1)
            ? null
            : Brightness.values[_currentBrightModeIndex];

    _loaded = true;
    notifyListeners();
  }

  void saveSelectedThemeIndex(int newIndex) async {
    if (newIndex != selectedIndex) {
      selectedIndex = await _repo.saveSelectedPalleteIndex(newIndex);
      _primaryColor = _colorModels[selectedIndex].primary;
      _primaryDarkColor = _colorModels[selectedIndex].primaryDark;
      notifyListeners();
    }
  }

  void saveSelectedBrightMode(Brightness? newBrightMode) async {
    if (newBrightMode != _currentBrightMode) {
      _currentBrightModeIndex = await _repo.saveBrightMode(newBrightMode);
      _currentBrightMode =
          (_currentBrightModeIndex == -1)
              ? null
              : Brightness.values[_currentBrightModeIndex];
      notifyListeners();
    }
  }
}
