import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/ui/pages/coffee_shops_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/manage_user_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/orders_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/profile_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/dashboard_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/revenue_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatefulWidget {
  SideMenu(
    this.user, {
    Key key,
    this.coffeeShop,
    this.screen,
    this.reauth,
    this.dashboardController,
  }) : super(key: key);
  final PageController dashboardController;
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
  bool _hovering = false;
  bool _titleVisible = false;
  bool _openDrawerWithIcon = false;
  final initalScreenWidth = SizeConfig.screenWidth;
  List<Widget> _pages;
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = widget.dashboardController;
    _userType = BlocProvider.of<AuthBloc>(context).state.user.userType;
    switch (_userType) {
      case UserType.barista:
        _pages = [
          DashboardPage(coffeeShop: widget.coffeeShop),
          OrdersPage(),
          MenuPage(coffeeShop: widget.coffeeShop),
        ];
        break;
      case UserType.owner:
        _pages = [
          DashboardPage(coffeeShop: widget.coffeeShop),
          OrdersPage(),
          RevenuePage(),
          MenuPage(coffeeShop: widget.coffeeShop),
          ManageUserPage(coffeeShop: widget.coffeeShop),
          ProfilePage(widget.reauth ?? false),
        ];
        break;
      case UserType.superUser:
        _pages = [
          CoffeeShopsPage(),
          ManageUserPage(),
          ProfilePage(widget.reauth ?? false)
        ];
        break;
    }
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
                controller: _pageController,
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
              width: initalScreenWidth * _navRatio < 60
                  ? 60
                  : initalScreenWidth * _navRatio,
              onEnd: () {
                if (_hovering == false && _openDrawerWithIcon == false) {
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
              child: MouseRegion(
                child: DynamicDrawer(
                    closeNav: _closeNav,
                    pageController: _pageController,
                    titlesVisible: _titleVisible,
                    currentScreen: widget.screen),
                onEnter: (e) => _mouseEnter(true),
                onExit: (e) => _mouseEnter(false),
              ),
            ),
          ],
        ),
      ),
      /* floatingActionButton: _userType == UserType.superUser
          ? Container()
          : FancyFab(widget.user.id, "scKHm6EgXqTDgaaoMv0lvxWrpBx2"), */
    );
  }

  void _mouseEnter(bool hover) {
    if (MediaQuery.of(context).size.width < 300) {
      return;
    }
    setState(() {
      _titleVisible = false;
    });

    if (hover) {
      setState(() {
        _navRatio = .17;
        _hovering = true;
      });
    } else {
      setState(() {
        _hovering = false;
        _titleVisible = false;
        _navRatio = .03;
      });
    }
  }
}

class DynamicDrawer extends StatefulWidget {
  DynamicDrawer({
    Key key,
    this.titlesVisible,
    this.pageController,
    this.currentScreen,
    this.closeNav,
  }) : super(key: key);
  final PageController pageController;
  final bool titlesVisible;
  final CortadoAdminScreen currentScreen;
  final Function closeNav;
  @override
  _DynamicDrawerState createState() => _DynamicDrawerState();
}

class _DynamicDrawerState extends State<DynamicDrawer> {
  MenuItem _selectedMenuItem;
  List<MenuItem> _menuItems;
  List<Widget> _menuOptionWidgets = [];
  AuthState _authState;

  @override
  initState() {
    super.initState();
    _authState = BlocProvider.of<AuthBloc>(context).state;
    _menuItems = createMenuItems(_authState.user.userType);
    _selectedMenuItem = _menuItems[widget.currentScreen.index];
  }

  @override
  Widget build(BuildContext context) {
    _menuOptionWidgets = [];

    for (var menuItem in _menuItems) {
      _menuOptionWidgets.add(GestureDetector(
        onTap: () {
          widget.pageController.jumpToPage(menuItem.index);
          widget.closeNav();
          setState(() {
            _selectedMenuItem = menuItem;
          });
        },
        child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: menuItem == _selectedMenuItem
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
                          style: menuItem == _selectedMenuItem
                              ? TextStyles.kCoffeeNavSelectedTextStyle
                              : TextStyles.kCoffeeNavTextStyle),
                    ),
                  ),
                ),
                Spacer(),
                _selectedMenuItem == menuItem
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

  List<MenuItem> createMenuItems(UserType userType) {
    var menuItems;
    switch (userType) {
      case UserType.barista:
        menuItems = [
          MenuItem("Dashboard", Icon(Icons.dashboard, color: AppColors.cream),
              AppColors.light, 0),
          MenuItem("Orders", Icon(Icons.list, color: AppColors.cream),
              AppColors.light, 1),
          MenuItem("Menu", Icon(Icons.local_drink, color: AppColors.cream),
              AppColors.light, 2),
        ];
        break;
      case UserType.owner:
        menuItems = [
          MenuItem("Dashboard", Icon(Icons.dashboard, color: AppColors.cream),
              AppColors.light, 0),
          MenuItem("Orders", Icon(Icons.list, color: AppColors.cream),
              AppColors.light, 1),
          MenuItem("Revenue", Icon(Icons.attach_money, color: AppColors.cream),
              AppColors.light, 2),
          MenuItem("Menu", Icon(Icons.local_drink, color: AppColors.cream),
              AppColors.light, 3),
          MenuItem(
              "Customers",
              Icon(Icons.people_outline, color: AppColors.cream),
              AppColors.light,
              4),
          MenuItem("Profile", Icon(Icons.person, color: AppColors.cream),
              AppColors.light, 5)
        ];
        break;
      case UserType.superUser:
        menuItems = [
          MenuItem("Payments", Icon(Icons.payment, color: AppColors.cream),
              AppColors.light, 0),
          MenuItem("Coffee Shops", Icon(Icons.home, color: AppColors.cream),
              AppColors.light, 1),
          MenuItem(
              "Customers",
              Icon(Icons.people_outline, color: AppColors.cream),
              AppColors.light,
              2),
          MenuItem("Profile", Icon(Icons.person, color: AppColors.cream),
              AppColors.light, 3)
        ];
        break;
    }

    return menuItems;
  }
}

class MenuItem {
  String title;
  Widget icon;
  Color color;
  int index;

  MenuItem(this.title, this.icon, this.color, this.index);
}

enum CortadoAdminScreen { dashboard, revenue, menu, users, profile }

extension CortadoAdminScreensIndexing on CortadoAdminScreen {
  int get index {
    switch (this) {
      case CortadoAdminScreen.dashboard:
        return 0;
        break;
      case CortadoAdminScreen.revenue:
        return 1;
        break;
      case CortadoAdminScreen.menu:
        return 2;
        break;
      case CortadoAdminScreen.users:
        return 3;
        break;
      case CortadoAdminScreen.profile:
        return 4;
        break;
      default:
        return 1;
    }
  }
}
