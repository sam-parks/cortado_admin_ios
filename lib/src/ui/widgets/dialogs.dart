import 'dart:async';

import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/finance/links/finance_links_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/navigation/navigation_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/orders_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/orders_event.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/auth_service.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:cortado_admin_ios/src/ui/widgets/loading_state_button.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


AuthService get _authService => locator.get();

newOrderDialog(String title, BuildContext ctx, Timer notificationTimer) {
  showDialog(
    context: ctx,
    builder: (context) {
      CoffeeShopState _coffeeShopState =
          BlocProvider.of<CoffeeShopBloc>(context).state;
      BlocProvider.of<OrdersBloc>(context)
          .add(GetOrders(_coffeeShopState.coffeeShop.reference));
      // ignore: close_sinks
      NavigationBloc navigationBloc = BlocProvider.of<NavigationBloc>(context);
      return AlertDialog(
        backgroundColor: AppColors.dark,
        title: Text(
          title,
          style: TextStyles.kDefaultLightTextStyle,
        ),
        actions: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text(
                    "Dismiss",
                    style: TextStyles.kDefaultCreamTextStyle,
                  ),
                  onPressed: () {
                    notificationTimer.cancel();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text(
                    "Go To Order",
                    style: TextStyles.kDefaultCreamTextStyle,
                  ),
                  onPressed: () {
                    notificationTimer.cancel();
                    Navigator.of(context).pop();

                    navigationBloc.add(
                      ChangeDashboardPage(
                          CortadoAdminScreen.orders,
                          navigationBloc.state.menuItems.firstWhere(
                              (menuItem) => menuItem.title == "Orders")),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

forgotPasswordDialog(BuildContext context, Function callback) {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: AlertDialog(
          backgroundColor: AppColors.dark,
          title: Text(
            'Provide an email so we can send you a link to reset your password.',
            style: TextStyles.kDefaultLightTextStyle,
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              validator: (value) {
                return Validate.validateEmail(value);
              },
              style: TextStyle(
                  fontFamily: kFontFamilyNormal, color: AppColors.cream),
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontFamily: kFontFamilyNormal, color: AppColors.light)),
              onChanged: (value) {
                email = value;
              },
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: AppColors.tan,
              child: Text(
                'Send Link',
                style: TextStyle(
                    fontFamily: kFontFamilyNormal, color: AppColors.dark),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _authService.sendPasswordResetEmail(email);
                  Navigator.of(context).pop();
                  callback();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

newSizeInputDialog(BuildContext ctx) {
  TextEditingController controller = TextEditingController();
  return showDialog(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.dark,
        title: TextField(
            controller: controller, style: TextStyles.kDefaultCreamTextStyle),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                child: Text(
                  "Dismiss",
                  style: TextStyles.kDefaultCreamTextStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Add",
                  style: TextStyles.kDefaultCreamTextStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> reauthDialog(
    BuildContext context, CoffeeShopState coffeeShopState) async {
  // ignore: close_sinks
  FinanceLinksBloc financeLinksBloc =
      BlocProvider.of<FinanceLinksBloc>(context);
  return await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: DashboardCard(
          content: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "In order to ensure the security of your information, when refreshing the verification page you will be redirected back to Cortado. Please continue the verification process by clicking the button below.",
                  style: TextStyles.kDefaultCaramelTextStyle,
                ),
              ),
              LoadingStateButton<FinanceLinksLoading>(
                bloc: financeLinksBloc,
                button: CortadoFatButton(
                    width: SizeConfig.screenWidth * .1,
                    height: 70,
                    backgroundColor: AppColors.dark,
                    text: "Get Verified",
                    onTap: () => financeLinksBloc.add(CreateCustomAccountLink(
                        coffeeShopState.coffeeShop.customStripeAccountId))),
              ),
            ],
          ),
        ),
      );
    },
  );
}


