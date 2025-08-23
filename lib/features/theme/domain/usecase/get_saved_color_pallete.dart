import 'package:pulse_chat/features/theme/domain/repository/theme_repository.dart';

class GetSavedColorPallete {
  final ThemeRepository _themeRepository;

  GetSavedColorPallete(ThemeRepository themeRepository)
    : _themeRepository = themeRepository;

  Future<int> call() {
    return _themeRepository.getSavedColorPalleteIndex();
  }
}
