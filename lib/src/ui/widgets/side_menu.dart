import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/navigation/navigation_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/ui/pages/coffee_shops_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/manage_user_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/orders_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/profile_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/dashboard_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/revenue_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatefulWidget {
  SideMenu(
    this.user, {
    Key key,
    this.coffeeShop,
    this.screen,
    this.reauth,
  }) : super(key: key);

  final CoffeeShop coffeeShop;
  final CortadoUser user;
  final bool reauth;
  final CortadoAdminScreen screen;
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  UserType _userType;
  double _navRatio = .03;
  bool _titleVisible = false;
  bool _openDrawerWithIcon = false;
  List<Widget> _pages;

  NavigationService get _navigationService => locator.get();

  @override
  void initState() {
    super.initState();
    _userType = BlocProvider.of<AuthBloc>(context).state.user.userType;
    _pages = pagesForUserType(_userType);
  }

  _closeNav() {
    setState(() {
      _titleVisible = false;
      _navRatio = .03;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.light,
      body: GestureDetector(
        onTap: _closeNav,
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _navigationService.pageController,
                children: _pages,
              ),
            ),
            Positioned(
                left: 60,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      _titleVisible = true;
                      _navRatio = .17;
                      _openDrawerWithIcon = true;
                    });
                  },
                )),
            AnimatedContainer(
              height: MediaQuery.of(context).size.height,
              width: SizeConfig.screenWidth * _navRatio < 60
                  ? 60
                  : SizeConfig.screenWidth * _navRatio,
              onEnd: () {
                if (_openDrawerWithIcon == false) {
                  setState(() {
                    _titleVisible = false;
                  });
                } else {
                  setState(() {
                    _titleVisible = true;
                  });
                }
              },
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
              child: DynamicDrawer(
                  closeNav: _closeNav,
                  titlesVisible: _titleVisible,
                  currentScreen: widget.screen),
            ),
          ],
        ),
      ),
      /* floatingActionButton: _userType == UserType.superUser
          ? Container()
          : FancyFab(widget.user.id, "scKHm6EgXqTDgaaoMv0lvxWrpBx2"), */
    );
  }

  pagesForUserType(UserType type) {
    print(type);
    switch (_userType) {
      case UserType.barista:
        return [
          DashboardPage(coffeeShop: widget.coffeeShop),
          OrdersPage(),
          MenuPage(coffeeShop: widget.coffeeShop),
        ];
        break;
      case UserType.owner:
        return [
          DashboardPage(coffeeShop: widget.coffeeShop),
          OrdersPage(),
          RevenuePage(),
          MenuPage(coffeeShop: widget.coffeeShop),
          ManageUserPage(coffeeShop: widget.coffeeShop),
          ProfilePage(widget.reauth ?? false),
        ];
        break;
      case UserType.superUser:
        return [
          CoffeeShopsPage(),
          ManageUserPage(),
          ProfilePage(widget.reauth ?? false)
        ];
        break;
    }
  }
}

class DynamicDrawer extends StatefulWidget {
  DynamicDrawer({
    Key key,
    this.titlesVisible,
    this.currentScreen,
    this.closeNav,
  }) : super(key: key);

  final bool titlesVisible;
  final CortadoAdminScreen currentScreen;
  final Function closeNav;
  @override
  _DynamicDrawerState createState() => _DynamicDrawerState();
}

class _DynamicDrawerState extends State<DynamicDrawer> {
  List<Widget> _menuOptionWidgets = [];
  NavigationBloc _navigationBloc;

  @override
  initState() {
    super.initState();
    _navigationBloc = BlocProvider.of<NavigationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _menuOptionWidgets = [];

    for (var menuItem
        in BlocProvider.of<NavigationBloc>(context).state.menuItems) {
      _menuOptionWidgets.add(GestureDetector(
        onTap: () {
          print(menuItem.title);
          _navigationBloc.add(
              ChangeDashboardPage(screenFromString(menuItem.title), menuItem));
          widget.closeNav();
        },
        child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: menuItem == _navigationBloc.state.currentMenuItem
                    ? AppColors.caramel
                    : AppColors.dark),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: menuItem.icon,
                ),
                Expanded(
                  child: Visibility(
                    visible: widget.titlesVisible,
                    child: Container(
                      child: AutoSizeText(menuItem.title,
                          maxLines: 1,
                          style:
                              menuItem == _navigationBloc.state.currentMenuItem
                                  ? TextStyles.kCoffeeNavSelectedTextStyle
                                  : TextStyles.kCoffeeNavTextStyle),
                    ),
                  ),
                ),
                Spacer(),
                menuItem == _navigationBloc.state.currentMenuItem
                    ? Container(
                        width: 3,
                        color: AppColors.cream,
                      )
                    : Container()
              ],
            )),
      ));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: AppColors.dark),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 16.0, top: 8, bottom: 16.0),
              child: Image.asset(
                "images/coffee_bean.png",
                height: 30,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _menuOptionWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
