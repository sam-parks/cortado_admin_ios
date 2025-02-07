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
import 'package:cortado_admin_ios/src/ui/pages/profile/profile_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/dashboard_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/revenue_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                top: 15,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      _titleVisible = true;
                      _navRatio = .2;
                    });
                  },
                )),
            AnimatedContainer(
              height: MediaQuery.of(context).size.height,
              width: SizeConfig.screenWidth * _navRatio < 60
                  ? 60
                  : SizeConfig.screenWidth * _navRatio,
              onEnd: () {
                _navRatio == .2
                    ? setState(() {
                        _titleVisible = true;
                      })
                    : setState(() {
                        _titleVisible = false;
                      });
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
  AuthBloc _authBloc;

  @override
  initState() {
    super.initState();
    _navigationBloc = BlocProvider.of<NavigationBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _menuOptionWidgets = [];

    for (var menuItem
        in BlocProvider.of<NavigationBloc>(context).state.menuItems) {
      _menuOptionWidgets.add(GestureDetector(
        onTap: () {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 16.0, top: 8, bottom: 16.0),
              child: SvgPicture.asset(
                'images/coffee_bean.svg',
                height: 30,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._menuOptionWidgets,
                  Spacer(),
                  IconButton(
                      color: AppColors.cream,
                      tooltip: "Logout",
                      icon: Icon(FontAwesomeIcons.signOutAlt),
                      onPressed: () => _authBloc.add(SignOut())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
