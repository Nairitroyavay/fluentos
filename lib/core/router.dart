import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/splash_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/main_shell/main_shell.dart';
import '../features/premium/premium_preview_screen.dart';
import '../providers/providers.dart';

const appRoutePaths = ['/', '/auth', '/onboarding', '/home', '/premium'];
const addLanguageFlowQueryValue = 'add-language';

String? appRedirectFor({
  required String path,
  required bool isSignedIn,
  required bool hasCompletedOnboarding,
  bool isAddLanguageFlow = false,
}) {
  final normalizedPath = path.isEmpty ? '/' : path;

  if (normalizedPath == '/') {
    return null;
  }

  if (!isSignedIn) {
    return normalizedPath == '/auth' ? null : '/auth';
  }

  if (!hasCompletedOnboarding) {
    if (normalizedPath == '/auth' || normalizedPath == '/home') {
      return '/onboarding';
    }
    return null;
  }

  if (normalizedPath == '/auth') {
    return '/home';
  }

  if (normalizedPath == '/onboarding' && !isAddLanguageFlow) {
    return '/home';
  }

  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      return appRedirectFor(
        path: state.uri.path,
        isSignedIn: ref.read(authProvider).isSignedIn,
        hasCompletedOnboarding: ref.read(userProvider).hasCompletedOnboarding,
        isAddLanguageFlow:
            state.uri.queryParameters['flow'] == addLanguageFlowQueryValue,
      );
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const MainShell()),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumPreviewScreen(),
      ),
    ],
  );
});
