import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/statistics/statistics_bloc.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_sales_bar_chart.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:cortado_admin_ios/src/ui/widgets/latte_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    children: [_DailySalesWidget()],
                  ),
                ),
                // _monthlySalesWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DailySalesWidget extends StatelessWidget {
  const _DailySalesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
      if (state.status == StatisticsStatus.loading)
        return Center(child: LatteLoader());

      return Expanded(
          child: DashboardCard(
        width: SizeConfig.screenWidth,
        innerHorizontalPadding: 10,
        title: "Weekly Sales",
        content: Container(
          alignment: Alignment.bottomCenter,
          child: DailySalesChart(state.weeklySales),
        ),
      ));
    });
  }
}
