import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/data/models/auth_state.dart';
import 'package:cortado_admin_ios/src/data/models/coffee_shop_state.dart';
import 'package:cortado_admin_ios/src/services/firebase_messaging_service.dart';
import 'package:cortado_admin_ios/src/services/local_storage_service.dart';
import 'package:cortado_admin_ios/src/ui/pages/auth_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/side_menu.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final CortadoAdminScreen screen;
  final bool reauth;

  const HomePage({Key key, this.screen, this.reauth}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    CortadoUser currentUser =
        Provider.of<LocalStorageService>(context).getUser("currentUser");

    PageController dashboardController =
        PageController(initialPage: widget.screen.index ?? 0);
    return StreamBuilder<auth.User>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && (!snapshot.data.isAnonymous)) {
            return Consumer<AuthState>(builder: (context, auth, child) {
              if (currentUser != null && auth.fbUser != null) {
                {
                  if (auth.fbUser.email == currentUser.email) {
                    print(currentUser.email);
                    auth.setCurrentUser(currentUser);
                  }
                }
              }

              if (auth.isLoading) {
                return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.caramel)));
              }
              if (auth.isLoggedIn) {
                print("${auth.user.email} is logged in");
                if (Provider.of<FBMessagingAndNotificationService>(context)
                        .token ==
                    null) {
                  Provider.of<FBMessagingAndNotificationService>(context)
                      .init(auth.user.id, dashboardController);
                }

                Provider.of<LocalStorageService>(context)
                    .saveUserToLocal(auth.user);

                if (auth.userType == UserType.superUser) {
                  return SideMenu(auth.user);
                }
                return Consumer<CoffeeShopState>(
                  builder: (context, coffeeShopState, _) {
                    if (!coffeeShopState.initialized) {
                      coffeeShopState.init(auth.user.coffeeShopId);
                    }
                    if (coffeeShopState.coffeeShop != null)
                      return SideMenu(
                        auth.user,
                        reauth: widget.reauth,
                        coffeeShop: coffeeShopState.coffeeShop,
                        screen: widget.screen ?? CortadoAdminScreen.dashboard,
                        dashboardController: dashboardController,
                      );

                    return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.caramel)),
                    );
                  },
                );
              } else {
                return AuthPage();
              }
            });
          } else {
            return AuthPage();
          }
        });
  }
}
