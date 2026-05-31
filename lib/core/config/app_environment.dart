import 'backend_mode.dart';

class AppEnvironment {
  final String appName;
  final BackendMode backendMode;
  final bool isBackendEnabled;
  final bool isAiEnabled;
  final bool isPaymentEnabled;
  final bool isSocialEnabled;

  const AppEnvironment({
    required this.appName,
    required this.backendMode,
    required this.isBackendEnabled,
    required this.isAiEnabled,
    required this.isPaymentEnabled,
    required this.isSocialEnabled,
  });

  const AppEnvironment.mockLocal()
    : appName = 'FluentOS',
      backendMode = BackendMode.mockLocal,
      isBackendEnabled = false,
      isAiEnabled = false,
      isPaymentEnabled = false,
      isSocialEnabled = false;

  bool get isMockLocal => backendMode == BackendMode.mockLocal;
}

const appEnvironment = AppEnvironment.mockLocal();
