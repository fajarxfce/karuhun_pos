import 'package:flutter/material.dart';
import 'package:karuhun_pos/core/designsystem/theme.dart';
import 'package:karuhun_pos/core/designsystem/util.dart';
import 'core/di/injection.dart';
import 'router/app_router.dart';
import 'core/services/auth_session_service.dart';
import 'core/services/session_manager.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AuthSessionService.instance.onSessionExpired.listen(
      (_) => _handleSessionExpired(),
    );
  }

  Future<void> _handleSessionExpired() async {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;
    await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Session Expired'),
        content: const Text(
          'Sesi login Anda telah berakhir. Silakan login kembali.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await SessionManager.instance.clearSession();
              Navigator.of(
                ctx,
                rootNavigator: true,
              ).popUntil((route) => route.isFirst);
              AppRouter.router.go('/login');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Outfit");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      title: 'Karuhun POS',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
