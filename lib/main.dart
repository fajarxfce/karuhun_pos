import 'package:flutter/material.dart';
import 'package:karuhun_pos/core/designsystem/theme.dart';
import 'package:karuhun_pos/core/designsystem/util.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
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
