import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/features/user/data/repositories/user_repository_impl.dart';
import 'package:pulse_chat/features/user/data/source/network/user_service.dart';
import 'package:pulse_chat/features/user/domain/repositories/user_repository.dart';
import 'package:pulse_chat/features/user/domain/usecase/get_user.dart';
import 'package:pulse_chat/features/user/domain/usecase/search_users.dart';

List<SingleChildWidget> userProviders = [
  // SOURCEs AND SERVICES --------------------------------------------------------------------------
  Provider<UserService>(create: (context) => context.read<ApiClient>().userApi),

  // REPOSITORIES ----------------------------------------------------------------------------------
  Provider<UserRepository>(
    create: (context) => UserRepositoryImpl(userService: context.read()),
  ),

  // USECASE ---------------------------------------------------------------------------------------
  Provider<SearchUsers>(
    create: (context) => SearchUsers(context.read<UserRepository>()),
  ),

  Provider<GetUser>(
    create:
        (context) => GetUser(userRepository: context.read<UserRepository>()),
  ),
];
