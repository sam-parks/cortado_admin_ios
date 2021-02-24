import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cortado_admin_ios/src/constants.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.coffeeShop}) : super(key: key);

  final CoffeeShop coffeeShop;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _drinksAdded = false;
  bool _foodAdded = false;
  bool _payoutInfoComplete = false;
  bool _reviewedShopInfo = false;
  bool _customerContact = false;

  ScrollController _scrollController = ScrollController();

  _signUpChecklistWidget() {
    return Expanded(
      child: DashboardCard(
        width: SizeConfig.screenWidth,
        innerHorizontalPadding: 10,
        title: "Sign Up Checklist",
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: ListTile(
                leading: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    activeColor: AppColors.cream,
                    checkColor: AppColors.dark,
                    value: _drinksAdded,
                    onChanged: (value) => setState(() {
                          _drinksAdded = value;
                        })),
                title: AutoSizeText(
                  "Add Drinks",
                  maxLines: 1,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 20),
                ),
                subtitle: AutoSizeText(
                  "Add your drink menu to Cortado for users to easily navigate and order.",
                  style: TextStyle(
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 14),
                ),
              ),
            ),
            Flexible(
              child: ListTile(
                leading: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    activeColor: AppColors.cream,
                    checkColor: AppColors.dark,
                    value: _foodAdded,
                    onChanged: (value) => setState(() {
                          _foodAdded = value;
                        })),
                title: AutoSizeText(
                  "Add FoodTemplate",
                  maxLines: 1,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 20),
                ),
                subtitle: AutoSizeText(
                  "Add your food items to Cortado for users to easily navigate and order.",
                  style: TextStyle(
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 14),
                ),
              ),
            ),
            Flexible(
              child: ListTile(
                leading: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    activeColor: AppColors.cream,
                    checkColor: AppColors.dark,
                    value: _payoutInfoComplete,
                    onChanged: (value) => setState(() {
                          _payoutInfoComplete = value;
                        })),
                title: AutoSizeText(
                  "Complete Payout Information",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 20),
                ),
                subtitle: AutoSizeText(
                  "Fill out your payment information so Cortado can pay you for customer orders.",
                  style: TextStyle(
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 14),
                ),
              ),
            ),
            Flexible(
              child: ListTile(
                leading: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    activeColor: AppColors.cream,
                    checkColor: AppColors.dark,
                    value: _reviewedShopInfo,
                    onChanged: (value) => setState(() {
                          _reviewedShopInfo = value;
                        })),
                title: AutoSizeText(
                  "Review Shop Hours and Information",
                  maxLines: 1,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 20),
                ),
                subtitle: AutoSizeText(
                  "Ensure your shop information is correct so that users can easily find your location.",
                  style: TextStyle(
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 14),
                ),
              ),
            ),
            Flexible(
              child: ListTile(
                leading: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    activeColor: AppColors.cream,
                    checkColor: AppColors.dark,
                    value: _customerContact,
                    onChanged: (value) => setState(() {
                          _customerContact = value;
                        })),
                title: AutoSizeText(
                  "Tell your customers about Cortado!",
                  maxLines: 1,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 20),
                ),
                subtitle: AutoSizeText(
                  "Let your customers know that your location is now on Cortado for mobile ordering.",
                  maxLines: 1,
                  style: TextStyle(
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _welcomeWidget() {
    return DashboardCard(
        innerColor: Colors.transparent,
        width: SizeConfig.screenWidth,
        title: "Welcome to Cortado!",
        content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    welcomeText,
                    style: TextStyles.kDefaultLightTextStyle,
                  ),
                ),
                Expanded(
                  child: Image.asset('images/joe.png'),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    Menu menu = context.watch<MenuBloc>().state.menu;
    CoffeeShopState coffeeShopState = context.watch<CoffeeShopBloc>().state;
    AuthState authState = context.watch<AuthBloc>().state;
    UserType userType = authState.user.userType;

    _drinksAdded = menu.drinkTemplates.isNotEmpty;
    _foodAdded = menu.foodTemplates.isNotEmpty;
    _payoutInfoComplete =
        !coffeeShopState.coffeeShop.needsVerificationUpdate ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Scrollbar(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(left: 130.0, right: 20),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "Hello " + authState.user.displayName,
                              maxLines: 1,
                              style: TextStyles.kWelcomeTitleTextStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Welcome to your individualized dashboard.",
                                style: TextStyles.kDefaultCaramelTextStyle,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (userType == UserType.owner) _signUpChecklistWidget(),
                    ],
                  ),
                ),
                _welcomeWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  getMonthFromIndex(int i) {
    switch (i) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }
  }
}
