import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/features/theme/data/repository/theme_repository_impl.dart';
import 'package:pulse_chat/features/theme/data/source/local/theme_local_storage.dart';
import 'package:pulse_chat/features/theme/domain/repository/theme_repository.dart';
import 'package:pulse_chat/features/theme/domain/usecase/get_brightness_mode.dart';
import 'package:pulse_chat/features/theme/domain/usecase/get_color_palletes.dart';
import 'package:pulse_chat/features/theme/domain/usecase/get_saved_color_pallete.dart';
import 'package:pulse_chat/features/theme/domain/usecase/save_brightness_mode.dart';
import 'package:pulse_chat/features/theme/domain/usecase/save_color_pallete.dart';
import 'package:pulse_chat/features/theme/presentation/notifier/theme_notifier.dart';

List<SingleChildWidget> themeProviders = [
  // SOURCE and SERVICE-----------------------------------------------------------------------
  Provider<ThemeLocalStorage>(create: (context) => ThemeLocalStorage()),

  // REPOSITORY -----------------------------------------------------------------------
  Provider<ThemeRepository>(
    create: (context) => ThemeRepositoryImpl(context.read<ThemeLocalStorage>()),
  ),

  // USECASE -----------------------------------------------------------------------
  Provider<GetBrightnessMode>(
    create: (context) => GetBrightnessMode(context.read<ThemeRepository>()),
  ),
  Provider<GetColorPalletes>(
    create: (context) => GetColorPalletes(context.read<ThemeRepository>()),
  ),
  Provider<GetSavedColorPallete>(
    create: (context) => GetSavedColorPallete(context.read<ThemeRepository>()),
  ),
  Provider<SaveBrightnessMode>(
    create: (context) => SaveBrightnessMode(context.read<ThemeRepository>()),
  ),
  Provider<SaveColorPallete>(
    create: (context) => SaveColorPallete(context.read<ThemeRepository>()),
  ),

  // CHANGE NOTIFIER -----------------------------------------------------------------------
  ChangeNotifierProvider<ThemeNotifier>(
    create:
        (context) => ThemeNotifier(
          context.read<GetSavedColorPallete>(),
          context.read<SaveColorPallete>(),
          context.read<GetColorPalletes>(),
          context.read<GetBrightnessMode>(),
          context.read<SaveBrightnessMode>(),
        ),
  ),
];
