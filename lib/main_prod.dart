import 'dart:async';

import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/payment/payment_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/bloc.dart';
import 'package:cortado_admin_ios/src/data/models/auth_state.dart';
import 'package:cortado_admin_ios/src/data/models/coffee_shop_state.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:cortado_admin_ios/src/services/firebase_messaging_service.dart';
import 'package:cortado_admin_ios/src/services/local_storage_service.dart';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:cortado_admin_ios/src/services/order_service.dart';
import 'package:cortado_admin_ios/src/services/stripe_service.dart';
import 'package:cortado_admin_ios/src/ui/router.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flavor/flavor.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:cortado_admin_ios/src/utils/navigation/navigator.dart';
import 'package:sentry/sentry.dart';

void main() {
  Flavor.create(
    Environment.production,
  );
  setupApp();
}

void setupApp() async {
  final SentryClient sentry = new SentryClient(
      dsn:
          'https://43fa764612904e009d575309e9fc74e3@o347591.ingest.sentry.io/5368007');
  FBMessagingAndNotificationService _messageService =
      FBMessagingAndNotificationService.instance;
  LocalStorageService _storageService = LocalStorageService.instance;
  StripeService _stripeService = StripeService(true);
  CoffeeShopService _coffeeShopService = CoffeeShopService.instance;
  OrderService _orderService = OrderService.instance;

  WidgetsFlutterBinding.ensureInitialized();

  runZoned(
      () => runApp(
            ChangeNotifierProvider(
              create: (BuildContext context) => CoffeeShopState(),
              child: MultiProvider(
                  providers: [
                    ListenableProvider.value(value: AuthState()..init()),
                    ListenableProvider<FBMessagingAndNotificationService>.value(
                        value: _messageService),
                    ListenableProvider<LocalStorageService>.value(
                      value: _storageService,
                    ),
                    Provider<StripeService>.value(value: _stripeService),
                    Provider<CoffeeShopService>.value(
                        value: _coffeeShopService),
                    Provider<OrderService>.value(value: _orderService)
                  ],
                  child: MultiBlocProvider(providers: [
                    BlocProvider<UserManagementBloc>(
                      create: (context) => UserManagementBloc(),
                    ),
                    BlocProvider<MenuBloc>(
                      create: (context) => MenuBloc(
                          Provider.of<CoffeeShopService>(context,
                              listen: false)),
                    ),
                    BlocProvider<PaymentBloc>(
                      create: (context) => PaymentBloc(
                          Provider.of<StripeService>(context, listen: false),
                          Provider.of<CoffeeShopService>(context,
                              listen: false)),
                    ),
                    BlocProvider<OrdersBloc>(
                        create: (context) => OrdersBloc(
                              Provider.of<OrderService>(context, listen: false),
                            ))
                  ], child: MyApp())),
            ),
          ), onError: (Object error, StackTrace stackTrace) {
    try {
      sentry.captureException(exception: error, stackTrace: stackTrace);
      print('Error sent to sentry.io: $error');
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
      print('Original error: $error');
    }
  });
}

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
