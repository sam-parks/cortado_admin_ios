import 'dart:async';

import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/payment/payment_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/bloc.dart';
import 'package:cortado_admin_ios/src/ui/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry/sentry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Flavor.create(
    Environment.production,
  );
  setupApp();
}

void setupApp() async {
  final SentryClient sentry = new SentryClient(
      dsn:
          'https://43fa764612904e009d575309e9fc74e3@o347591.ingest.sentry.io/5368007');

  WidgetsFlutterBinding.ensureInitialized();

  runZoned(
      () => runApp(
            BlocProvider(
              create: (BuildContext context) => CoffeeShopBloc(),
              child: MultiBlocProvider(providers: [
                BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
                BlocProvider<UserManagementBloc>(
                    create: (context) => UserManagementBloc()),
                BlocProvider<MenuBloc>(create: (context) => MenuBloc()),
                BlocProvider<PaymentBloc>(
                    create: (context) =>
                        PaymentBloc(BlocProvider.of<CoffeeShopBloc>(context))),
                BlocProvider<OrdersBloc>(create: (context) => OrdersBloc())
              ], child: MyApp()),
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
