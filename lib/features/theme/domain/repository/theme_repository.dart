import 'package:flutter/foundation.dart';
import 'package:pulse_chat/features/theme/domain/entity/custom_color_model.dart';

abstract class ThemeRepository {
  Future<int> getSavedColorPalleteIndex();
  Future<int> saveSelectedPalleteIndex(int selectedIndex);
  List<CustomColorsModel> getPalletes();
  Future<int> getSavedBrightMode();
  Future<int> saveBrightMode(Brightness? brightness);
}
