import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_sales_bar_chart.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RevenuePage extends StatefulWidget {
  RevenuePage({Key key}) : super(key: key);

  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
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
                          "Sales",
                          maxLines: 1,
                          style: TextStyles.kWelcomeTitleTextStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "View recent sales for your location.",
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
                    children: [_salesWidget()],
                  ),
                ),
                _monthlySalesWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _salesWidget() {
    return Expanded(
        child: DashboardCard(
      width: SizeConfig.screenWidth,
      innerHorizontalPadding: 10,
      title: "Weekly Sales",
      content: Container(
        alignment: Alignment.bottomCenter,
        child: DailySalesChart(_createDailySalesData()),
      ),
    ));
  }

  _createDailySalesData() {
    /// Create one series with sample hard coded data.

    final data = [
      DailySales('Monday', 5),
      DailySales('Tuesday', 25),
      DailySales('Wednesday', 100),
      DailySales('Thursday', 75),
      DailySales('Friday', 75),
      DailySales('Saturday', 75),
      DailySales('Sunday', 75),
    ];

    return [
      charts.Series<DailySales, String>(
          id: 'dailySales',
          domainFn: (DailySales sales, _) => sales.day,
          measureFn: (DailySales users, _) => users.amount,
          data: data,
          fillColorFn: (_, __) => charts.Color.fromHex(code: '#471D00'),
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (DailySales sales, _) => sales.amount.toString())
    ];
  }

  _createDailyRevenueData() {
    /// Create one series with sample hard coded data.

    final data = [
      DailySales('Monday', 5),
      DailySales('Tuesday', 25),
      DailySales('Wednesday', 100),
      DailySales('Thursday', 75),
      DailySales('Friday', 75),
      DailySales('Saturday', 75),
      DailySales('Sunday', 75),
    ];

    return [
      charts.Series<DailySales, String>(
          id: 'dailyRevenue',
          domainFn: (DailySales sales, _) => sales.day,
          measureFn: (DailySales users, _) => users.amount,
          data: data,
          fillColorFn: (_, __) => charts.Color.fromHex(code: '#471D00'),
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (DailySales sales, _) => sales.amount.toString())
    ];
  }

  _revenueWidget() {
    return Expanded(
      child: DashboardCard(
        innerHorizontalPadding: 10,
        title: "Revenue",
        content: Container(
          alignment: Alignment.bottomCenter,
          height: 300,
          width: 300,
          child: DailySalesChart(_createDailyRevenueData()),
        ),
      ),
    );
  }

  _monthlySalesWidget() {
    return DashboardCard(
        innerHorizontalPadding: 10,
        innerColor: AppColors.light,
        width: SizeConfig.screenWidth,
        title: "Monthly Sales",
        content: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.bottomCenter,
        ));
  }
}
