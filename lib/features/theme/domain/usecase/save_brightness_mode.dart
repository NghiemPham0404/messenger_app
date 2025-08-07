import 'package:flutter/material.dart';
import 'package:pulse_chat/features/theme/domain/repository/theme_repository.dart';

class SaveBrightnessMode {
  final ThemeRepository _themeRepository;

  SaveBrightnessMode(ThemeRepository themeRepository)
    : _themeRepository = themeRepository;

  Future<int> call(Brightness? brightness) {
    return _themeRepository.saveBrightMode(brightness);
  }
}
