import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/navigation/navigation_bloc.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/ui/pages/auth_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/verification_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/latte_loader.dart';
import 'package:cortado_admin_ios/src/ui/widgets/side_menu.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final CortadoAdminScreen screen;
  final bool reauth;

  const HomePage({Key key, this.screen, this.reauth}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // ignore: close_sinks
  AuthBloc _authBloc;
  // ignore: close_sinks
  CoffeeShopBloc _coffeeShopBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _coffeeShopBloc = BlocProvider.of<CoffeeShopBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocConsumer(
        cubit: _authBloc,
        listener: (context, AuthState state) {
          if (state.status == AuthStatus.error) {
            Flushbar(
              icon: Icon(
                Icons.error_outline,
                color: AppColors.light,
              ),
              message: state.error,
              duration: Duration(seconds: 3),
              isDismissible: true,
              flushbarStyle: FlushbarStyle.FLOATING,
              backgroundColor: AppColors.dark,
            )..show(context);
          }
        },
        builder: (context, AuthState authState) {
          return _body(authState);
        });
  }

  _body(AuthState authState) {
    // ignore: close_sinks
    NavigationBloc navigationBloc = BlocProvider.of<NavigationBloc>(context);

    switch (authState.status) {
      case AuthStatus.loading:
        return Scaffold(
          body: Container(alignment: Alignment.center, child: LatteLoader()),
        );
        break;
      case AuthStatus.authenticated:
        if (authState.user.userType == UserType.superUser) {
          return SideMenu(authState.user);
        } else {
          return BlocBuilder(
            cubit: navigationBloc,
            builder: (BuildContext context, navigationState) {
              if (navigationState.navigationStatus ==
                  NavigationStatus.initial) {
                return Scaffold(
                  body: Center(child: LatteLoader()),
                );
              }
              return BlocBuilder(
                cubit: _coffeeShopBloc,
                builder: (context, CoffeeShopState coffeeShopState) {
                  switch (coffeeShopState.status) {
                    case CoffeeShopStatus.loading:
                      return Scaffold(
                        body: Center(child: LatteLoader()),
                      );
                      break;
                    case CoffeeShopStatus.initialized:
                      if (coffeeShopState.coffeeShop.cortadoVerified)
                        return SideMenu(
                          authState.user,
                          reauth: widget.reauth,
                          coffeeShop: coffeeShopState.coffeeShop,
                          screen: widget.screen ?? CortadoAdminScreen.dashboard,
                        );

                      return VerificationPage();
                      break;
                    default:
                      return AuthPage();
                  }
                },
              );
            },
          );
        }
        break;
      case AuthStatus.unauthenticated:
        return AuthPage();
      case AuthStatus.unknown:
        return AuthPage();
      case AuthStatus.error:
        return AuthPage();
      default:
        return AuthPage();
    }
  }
}
