import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/router.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_redemptions_bar_chart.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/ui/widgets/latte_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.coffeeShop}) : super(key: key);
  final CoffeeShop coffeeShop;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // ignore: close_sinks
  MenuBloc _menuBloc;

  @override
  void initState() {
    super.initState();
    _menuBloc = BlocProvider.of<MenuBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    CoffeeShopState coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;

    UserType userType = BlocProvider.of<AuthBloc>(context).state.user.userType;

    ScrollController _scrollController = ScrollController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Center(
        child: BlocBuilder(
          cubit: _menuBloc,
          builder: (BuildContext context, MenuState state) {
            if (state.status == MenuStatus.loading) {
              return LatteLoader();
            }
            return Scrollbar(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(left: 130.0, right: 20),
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "Online Menu",
                              maxLines: 1,
                              style: TextStyles.kWelcomeTitleTextStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Customize items available through Cortado!",
                                style: TextStyles.kDefaultCaramelTextStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _editMenuWidget(),
                      ],
                    ),
                    if (userType == UserType.owner)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _editDiscountsWidget(coffeeShopState),
                          _mostOrderedItemsWidget()
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _editMenuWidget() {
    return Expanded(
      child: DashboardCard(
          innerColor: Colors.transparent,
          title: "Edit Menu and Redemptions",
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * .6,
          content: _menuWidget()),
    );
  }

  _menuWidget() {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(kCategoryListRoute,
                        arguments: CategoryType.drink);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: AppColors.dark_lighter,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SvgPicture.asset("images/coffee_cup.svg",
                              height: 100, fit: BoxFit.cover),
                        ),
                        Text(
                          "Drinks",
                          style: TextStyles.kDefaultCreamTextStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(kCategoryListRoute,
                        arguments: CategoryType.food);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.caramel,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SvgPicture.asset("images/egg.svg",
                              height: 100, fit: BoxFit.cover),
                        ),
                        Text(
                          "Food",
                          style: TextStyles.kDefaultCreamTextStyle,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(kCategoryListRoute, arguments: CategoryType.addIn);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                color: AppColors.tan, borderRadius: BorderRadius.circular(8.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "images/sugar.svg",
                  width: 80,
                  fit: BoxFit.cover,
                ),
                Text(
                  "Add Ins",
                  style: TextStyles.kDefaultCaramelTextStyle,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _mostOrderedItemsWidget() {
    return Expanded(
      child: DashboardCard(
        innerHorizontalPadding: 10,
        title: "Most Ordered Items",
        innerColor: AppColors.light,
        content: Container(
            alignment: Alignment.bottomCenter,
            height: 300,
            width: 300,
            child: PurchasedCoffeesVerticalBarLabelChart.withSampleData()),
      ),
    );
  }

  _editDiscountsWidget(CoffeeShopState coffeeShopState) {
    ScrollController _scrollController = ScrollController();
    return Expanded(
      child: DashboardCard(
        title: "Edit Discounts",
        content: ListView.builder(
            controller: _scrollController,
            itemCount: coffeeShopState.coffeeShop.discounts.length,
            itemBuilder: (context, index) {
              return _discountTile(coffeeShopState, index);
            }),
        innerColor: Colors.transparent,
      ),
    );
  }

/*   _currentDealsWidget(CoffeeShopState coffeeShopState) {
    ScrollController _scrollController = ScrollController();
    return Expanded(
      child: DashboardCard(
        title: "Edit Discounts",
        content: ListView.builder(
            controller: _scrollController,
            itemCount: coffeeShopState.coffeeShop.discounts.length,
            itemBuilder: (context, index) {
              if (!coffeeShopState.coffeeShop.discounts[index]['active']) {
                return Container();
              }
              return _discountTile(coffeeShopState, index);
            }),
        innerColor: Colors.transparent,
      ),
    );
  } */

  _discountTile(CoffeeShopState coffeeShopState, int index) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadiusDirectional.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  coffeeShopState.coffeeShop.discounts[index]['title'] ?? '',
                  style: TextStyles.kDefaultCaramelTextStyle,
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.caramel,
                    ),
                    onPressed: () async {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: AppColors.caramel,
                    ),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              coffeeShopState.coffeeShop.discounts[index]['description'] ?? '',
              style: TextStyles.kDefaultSmallDarkTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
