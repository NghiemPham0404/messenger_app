import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/fcm/data/repositories/fcm_token_repo_impl.dart';
import 'package:pulse_chat/features/fcm/data/sources/local/local_source.dart';
import 'package:pulse_chat/features/fcm/data/sources/network/api_source.dart';
import 'package:pulse_chat/features/fcm/domain/repositories/fcm_repository.dart';
import 'package:pulse_chat/features/fcm/domain/usecase/create_fcm_token.dart';
import 'package:pulse_chat/features/fcm/domain/usecase/delete_fcm_token.dart';
import 'package:pulse_chat/features/fcm/domain/usecase/get_fcm_token.dart';

List<SingleChildWidget> fcmTokenProviders = [
  // SOURCE and SERVICE-----------------------------------------------------------------------
  Provider<ApiFcmTokenSource>(
    create: (context) => context.read<ApiClient>().fcmToken,
  ),

  Provider<LocalFCMDatasource>(create: (constext) => LocalFCMDatasource()),

  // REPOSITORY -----------------------------------------------------------------------
  Provider<FcmTokenRepository>(
    create:
        (context) => FCMTokenRepoImpl(
          localAuthSource: context.read<LocalAuthSource>(),
          localFCMDatasource: context.read<LocalFCMDatasource>(),
          apiFcmTokenSource: context.read<ApiFcmTokenSource>(),
        ),
  ),
  // USECASE -----------------------------------------------------------------------
  Provider<CreateFcmToken>(
    create: (context) => CreateFcmToken(context.read<FcmTokenRepository>()),
  ),
  Provider<GetFcmToken>(
    create: (context) => GetFcmToken(context.read<FcmTokenRepository>()),
  ),
  Provider<DeleteFcmToken>(
    create: (context) => DeleteFcmToken(context.read<FcmTokenRepository>()),
  ),
];
