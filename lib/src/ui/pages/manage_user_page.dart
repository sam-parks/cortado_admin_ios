import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_redemptions_bar_chart.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';

class ManageUserPage extends StatefulWidget {
  ManageUserPage({Key key, this.coffeeShop}) : super(key: key);
  final CoffeeShop coffeeShop;
  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.only(left: 30, top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "Customers",
                          maxLines: 1,
                          style: TextStyles.kWelcomeTitleTextStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "View statistics and recent customers redeeming and purchasing!",
                            style: TextStyles.kDefaultCaramelTextStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _customersPerHourWidget(),
                      _customerTypeWidget()
                    ],
                  ),
                ),
                _customerProfilesWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _customersPerHourWidget() {
    return Expanded(
      child: DashboardCard(
        innerHorizontalPadding: 10,
        title: "Customers Per Hour",
        content: Container(
            alignment: Alignment.bottomCenter,
            height: 300,
            width: 300,
            child: PurchasedCoffeesVerticalBarLabelChart.withSampleData()),
      ),
    );
  }

  _customerTypeWidget() {
    return Expanded(
      child: DashboardCard(
        innerHorizontalPadding: 10,
        title: "Customer Types",
        content: Container(
            alignment: Alignment.bottomCenter,
            height: 300,
            width: 300,
            child: PurchasedCoffeesVerticalBarLabelChart.withSampleData()),
      ),
    );
  }

  _customerProfilesWidget() {
    return DashboardCard(
        innerColor: Colors.transparent,
        width: SizeConfig.screenWidth,
        title: "Customer Profiles (past month)",
        content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomCenter,
            child: Container()));
  }
}
