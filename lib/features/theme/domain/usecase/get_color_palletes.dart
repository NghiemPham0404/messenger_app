import 'package:pulse_chat/features/theme/domain/entity/custom_color_model.dart';
import 'package:pulse_chat/features/theme/domain/repository/theme_repository.dart';

class GetColorPalletes {
  final ThemeRepository _themeRepository;

  GetColorPalletes(ThemeRepository themeRepository)
    : _themeRepository = themeRepository;

  List<CustomColorsModel> call() {
    return _themeRepository.getPalletes();
  }
}
