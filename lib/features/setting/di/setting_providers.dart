import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/setting/presentation/change_notifier/setting_view_model.dart';

final List<SingleChildWidget> settingProviders = [
  ChangeNotifierProvider<SettingNotifier>(
    create:
        (context) =>
            SettingNotifier(localAuthSource: context.read<LocalAuthSource>()),
  ),
];
