import 'package:pulse_chat/features/theme/domain/repository/theme_repository.dart';

class SaveColorPallete {
  final ThemeRepository _themeRepository;

  SaveColorPallete(ThemeRepository themeRepository)
    : _themeRepository = themeRepository;

  Future<int> call(int selectedIndex) {
    return _themeRepository.saveSelectedPalleteIndex(selectedIndex);
  }
}
