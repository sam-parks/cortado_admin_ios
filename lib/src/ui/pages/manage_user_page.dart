import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/statistics/statistics_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:cortado_admin_ios/src/ui/widgets/latte_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                _WeeklyUsersWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyUsersWidget extends StatelessWidget {
  const _WeeklyUsersWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
      if (state.status == StatisticsStatus.loading)
        return Center(child: LatteLoader());

      return DashboardCard(
          innerColor: Colors.transparent,
          width: SizeConfig.screenWidth,
          title: "Customers this week",
          content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.bottomCenter,
              child: GridView.count(
                  childAspectRatio: 3.0,
                  crossAxisCount: 3,
                  children: List.generate(
                      state.weeklyUserEmails.length,
                      (index) => Center(
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              shadowColor: AppColors.cream,
                              elevation: 3,
                              child: ListTile(
                                leading: Image.asset(
                                  'images/coffee_bean.png',
                                  width: 25.0,
                                  height: 25.0,
                                  color: AppColors.dark,
                                ),
                                title: AutoSizeText(
                                  state.weeklyUserEmails[index],
                                  maxLines: 1,
                                  style: TextStyles.kDefaultCaramelTextStyle,
                                ),
                              ),
                            ),
                          )))));
    });
  }
}
