import 'package:pulse_chat/features/theme/domain/repository/theme_repository.dart';

class GetBrightnessMode {
  final ThemeRepository _themeRepository;

  GetBrightnessMode(ThemeRepository themeRepository)
    : _themeRepository = themeRepository;

  Future<int> call() {
    return _themeRepository.getSavedBrightMode();
  }
}
