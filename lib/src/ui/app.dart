import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/utils/navigation/navigator.dart';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:cortado_admin_ios/src/ui/router.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart' as fluro;

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final router = fluro.Router();
  @override
  void initState() {
    Routes.configureRoutes(router);
    super.initState();
    registerLocatorItems(Flavor.instance.environment == Environment.production);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cortado',
      theme: kCortadoTheme,
      initialRoute: NavUtils.initialURL,
      onGenerateRoute: router.generator,
      navigatorKey: NavigationService.navigatorKey,
    );
  }
}
