import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_open_splash.dart';
import 'color_scheme.dart';
import 'custom_color.dart';
import 'error_splash.dart';
import 'home.dart';
import 'providers.dart';
import 'routes.dart';
import 'theme_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(

        builder: (context, ref,child) {
          var route = ref.watch(initialRouteProvider);

          return route.when(data: (data) {
            var initialRoute = data;
            return MaterialApp(
              scaffoldMessengerKey: scaffoldKey,
              navigatorKey: navigatorKey,
              theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: lightColorScheme,
                  extensions: [lightCustomColors],
                  cardTheme: cardTheme,
                  scaffoldBackgroundColor: lightColorScheme.onPrimary),
              initialRoute: initialRoute,
              routes: routes(context),
              home: const Home(),
            );
          }, error: (e, st) {
            return const MaterialApp(
              home: ErrorSplash(),
              debugShowCheckedModeBanner: false,
            );
          }, loading: () {
            return const MaterialApp(
              home: AppOpenSplash(),
              debugShowCheckedModeBanner: false,
            );
          });
        },
      ),
    );
  }
}

