import 'package:go_router/go_router.dart';
import '../../features/app_startup/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/app_startup/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/logic/auth_cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/check_email_screen.dart';
import '../../features/auth/presentation/screens/confirm_email_screen.dart';
import '../../features/auth/presentation/screens/enter_code_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/logic/profile_cubit/profile_cubit.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/worksspace/logic/permission_cubit/permission_cubit.dart';
import '../../features/worksspace/presentation/screens/member_screen.dart';
import '../../features/worksspace/presentation/screens/permission_screen.dart';
import '../../features/worksspace/presentation/screens/workspace_screen.dart';
import '../dependency_injection.dart';
import 'route_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    // GoRoute(
    //   path: RouteNames.welcome,
    //   name: 'welcome',
    //   builder: (context, state) => const WelcomeScreen(),
    // ),

    //  Login
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: LoginScreen(onSwitchToSignUp: () {    context.go(RouteNames.register);  },),
      ),
    ),

    //  Register
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child:  RegisterScreen(onSwitchToSignIn: () {    context.go(RouteNames.login);  },),
      ),
    ),



    //  Confirm Email
    GoRoute(
      path: RouteNames.confirmEmail,
      builder: (context, state) {
        final extra = state.extra as Map<String, String>?;
        return BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: ConfirmEmailScreen(
            userId: extra?['userId'],
            code: extra?['code'],
          ),
        );
      },
    ),

    //  Check Email
    GoRoute(
      path: RouteNames.checkEmail,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child:  CheckEmailScreen(),
      ),
    ),

    //  Enter Code
    GoRoute(
      path: RouteNames.enterCode,
      builder: (context, state) {
        final extra = state.extra as Map<String, String>?;
        return BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: EnterCodeScreen(email: extra?['email'], code: extra?['code']),
        );
      },
    ),
    GoRoute(
      path: RouteNames.home,
      name: 'home',
     // builder: (context, state) => const HomeScreen(),
      builder: (context, state) => const TemporarySelectionScreen(),

    ),

    //  Profile
    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<ProfileCubit>(),
        child: const ProfileScreen(),
      ),
    ),

    GoRoute(
      path: RouteNames.editProfile,
      builder: (context, state) => BlocProvider.value(
        // نفس الـ instance عشان نحتفظ بالداتا
        value: getIt<ProfileCubit>(),
        child: const EditProfileScreen(),
      ),
    ),

    GoRoute(
      path: RouteNames.changePassword,
      builder: (context, state) => BlocProvider.value(
        value: getIt<ProfileCubit>(),
        child: const ChangePasswordScreen(),
      ),
    ),

    //  Workspace route

    GoRoute(
      path: RouteNames.workspaces,
      builder: (context, state) => const WorkspacesScreen(),
    ),

    // Member route
    GoRoute(
      path: RouteNames.members,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return MembersScreen(
          workspaceId: extra['workspaceId'],
          workspaceName: extra['workspaceName'],
        );
      },
    ),

    // Permission route
    GoRoute(
      path: RouteNames.permissions,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return BlocProvider(
          create: (_) => getIt<PermissionsCubit>()
            ..init(extra['permissions']),
          child: PermissionsScreen(
            workspaceId: extra['workspaceId'],
            userId: extra['userId'],
          ),
        );
      },
    ),
  ],
);
/*
GoRoute(
  path: RouteNames.profile,
  builder: (context, state) => BlocProvider.value(
    value: getIt<ProfileCubit>()..load(),
    child: const ProfileScreen(),
  ),
),

GoRoute(
  path: RouteNames.editProfile,
  builder: (context, state) => BlocProvider.value(
    value: getIt<ProfileCubit>(),
    child: const EditProfileScreen(),
  ),
),

GoRoute(
  path: RouteNames.changePassword,
  builder: (context, state) => BlocProvider.value(
    value: getIt<ProfileCubit>(),
    child: const ChangePasswordScreen(),
  ),
),
 */