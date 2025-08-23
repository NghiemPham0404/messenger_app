import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/auth/domain/usecases/cached_login_user.dart';
import 'package:pulse_chat/features/auth/domain/usecases/logout_user.dart';
import 'package:pulse_chat/features/auth/domain/usecases/relogin_current_user.dart';
import 'package:pulse_chat/features/auth/domain/usecases/sign_up_by_email.dart';
import 'package:pulse_chat/features/auth/presentation/signup_page/change_notifier/signup_notifier.dart';
import 'package:pulse_chat/features/auth/presentation/splash_page/change_notifier/splash_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user.dart';
import '../domain/usecases/get_signin_google.dart';
import '../domain/usecases/login_by_email.dart';
import '../domain/usecases/login_by_google.dart';
import '../presentation/login_page/change_notifier/login_notifier.dart';

final List<SingleChildWidget> authProviders = [
  // Repository ----------------------------------------------------------------------
  Provider<AuthRepository>(
    create:
        (ctx) => AuthRepositoryImpl(
          ctx.read<ApiClient>().authApi,
          ctx.read<LocalAuthSource>(),
        ),
  ),

  // Usecases ----------------------------------------------------------------------
  Provider<LoginByEmail>(
    create: (ctx) => LoginByEmail(ctx.read<AuthRepository>()),
  ),
  Provider<LoginByGoogle>(
    create: (ctx) => LoginByGoogle(ctx.read<AuthRepository>()),
  ),
  Provider<GetCurrentUser>(
    create: (ctx) => GetCurrentUser(ctx.read<AuthRepository>()),
  ),
  Provider<CachedLoginUser>(
    create: (ctx) => CachedLoginUser(ctx.read<AuthRepository>()),
  ),
  Provider<GetSigninGoogle>(
    create: (ctx) => GetSigninGoogle(ctx.read<AuthRepository>()),
  ),
  Provider<SignUpByEmail>(
    create: (ctx) => SignUpByEmail(ctx.read<AuthRepository>()),
  ),
  Provider<ReloginCurrentUser>(
    create: (ctx) => ReloginCurrentUser(ctx.read<AuthRepository>()),
  ),
  Provider<LogoutUser>(create: (ctx) => LogoutUser(ctx.read<AuthRepository>())),
  // Notifier ----------------------------------------------------------------------
  ChangeNotifierProvider<LoginNotifier>(
    create:
        (context) => LoginNotifier(
          loginByEmail: context.read<LoginByEmail>(),
          loginByGoogle: context.read<LoginByGoogle>(),
          getCurrentUser: context.read<GetCurrentUser>(),
          cachedLoginUser: context.read<CachedLoginUser>(),
          getSigninGoogle: context.read<GetSigninGoogle>(),
        ),
  ),
  ChangeNotifierProvider<SignUpNotifier>(
    create:
        (context) => SignUpNotifier(
          signUpByEmail: context.read<SignUpByEmail>(),
          cachedLoginUser: context.read<CachedLoginUser>(),
        ),
  ),
  ChangeNotifierProvider<SplashNotifier>(
    create:
        (context) => SplashNotifier(
          reloginCurrentUser: context.read<ReloginCurrentUser>(),
          cachedLoginUser: context.read<CachedLoginUser>(),
        ),
  ),
];
