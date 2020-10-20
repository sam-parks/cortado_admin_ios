import 'dart:async';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/finance/account/finance_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/finance/links/finance_links_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/category/category_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/navigation/navigation_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/bloc.dart';
import 'package:cortado_admin_ios/src/ui/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry/sentry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          appId: '1:56935818141:ios:8f5b7ee5b120f4fa8d0574',
          apiKey: 'AIzaSyAhwy1kt_a56tsV54eWjVB0BEAb9nR_5Sk',
          messagingSenderId: '56935818141',
          projectId: 'cortado-f9ae2'));
  Flavor.create(
    Environment.dev,
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
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  lazy: false,
                  create: (_) => CategoryBloc(),
                ),
              ],
              child: BlocProvider(
                lazy: false,
                create: (context) => MenuBloc(
                    categoryBloc: BlocProvider.of<CategoryBloc>(context)),
                child: BlocProvider(
                  lazy: false,
                  create: (context) => CoffeeShopBloc(
                      menuBloc: BlocProvider.of<MenuBloc>(context)),
                  child: MultiBlocProvider(
                      providers: [
                        BlocProvider<FinanceBloc>(
                            lazy: false,
                            create: (context) => FinanceBloc(
                                coffeeShopBloc:
                                    BlocProvider.of<CoffeeShopBloc>(context))),
                        BlocProvider<FinanceLinksBloc>(
                            create: (context) => FinanceLinksBloc()),
                        BlocProvider<BaristaManagementBloc>(
                            create: (context) => BaristaManagementBloc()),
                        BlocProvider<AuthBloc>(
                            lazy: false,
                            create: (context) => AuthBloc(
                                BlocProvider.of<CoffeeShopBloc>(context))),
                        BlocProvider<OrdersBloc>(
                            create: (context) => OrdersBloc()),
                      ],
                      child: BlocProvider<NavigationBloc>(
                          create: (context) => NavigationBloc(
                              authBloc: BlocProvider.of<AuthBloc>(context)),
                          child: MyApp())),
                ),
              ),
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
