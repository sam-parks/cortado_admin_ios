import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/navigation/navigation_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/orders_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/orders_event.dart';
import 'package:cortado_admin_ios/src/bloc/payment/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/payment/payment_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/payment/payment_event.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/barista_details_dialog_form.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';

import 'package:cortado_admin_ios/src/ui/widgets/loading_state_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/payout_details_dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

newOrderDialog(String title, BuildContext ctx) {
  showDialog(
    context: ctx,
    builder: (context) {
      CoffeeShopState _coffeeShopState =
          BlocProvider.of<CoffeeShopBloc>(context).state;
      BlocProvider.of<OrdersBloc>(context)
          .add(GetOrders(_coffeeShopState.coffeeShop.name));
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

Future<void> reauthDialog(BuildContext context, PaymentBloc paymentBloc,
    CoffeeShopState coffeeShopState) async {
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
              LoadingStateButton<PaymentLoadingState>(
                bloc: paymentBloc,
                button: CortadoFatButton(
                    width: SizeConfig.screenWidth * .1,
                    height: 70,
                    backgroundColor: AppColors.dark,
                    text: "Get Verified",
                    onTap: () => paymentBloc.add(CreateCustomAccountLink(
                        coffeeShopState.coffeeShop.customStripeAccountId))),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<Map> updateHoursDialog(BuildContext context, Map hours) async {
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##:##', filter: {"#": RegExp(r'[0-9]')});
  Map<String, String> reformattedHours = reformatHours(hours);

  TextEditingController monFriBegin =
      TextEditingController(text: reformattedHours['monFriBegin']);
  TextEditingController monFriEnd =
      TextEditingController(text: reformattedHours['monFriEnd']);
  TextEditingController satBegin =
      TextEditingController(text: reformattedHours['satBegin']);
  TextEditingController satEnd =
      TextEditingController(text: reformattedHours['satEnd']);
  TextEditingController sunBegin =
      TextEditingController(text: reformattedHours['sunBegin']);
  TextEditingController sunEnd =
      TextEditingController(text: reformattedHours['sunEnd']);

  String monFriBeginSelection = "AM";
  String monFriEndSelection = "PM";
  String satBeginSelection = "AM";
  String satEndSelection = "PM";
  String sunBeginSelection = "AM";
  String sunEndSelection = "PM";

  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: AppColors.dark,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Mon - Fri:",
                          style: TextStyles.kDefaultLightTextStyle,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 60,
                        child: TextField(
                            inputFormatters: [maskFormatter],
                            controller: monFriBegin,
                            style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      DropdownButton(
                          value: monFriBeginSelection,
                          items: [
                            DropdownMenuItem(
                              value: "AM",
                              child: Text("AM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            ),
                            DropdownMenuItem(
                              value: "PM",
                              child: Text("PM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              monFriBeginSelection = value;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("-", style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 60,
                        child: TextField(
                            inputFormatters: [maskFormatter],
                            controller: monFriEnd,
                            style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      DropdownButton(
                          value: monFriEndSelection,
                          items: [
                            DropdownMenuItem(
                              value: "AM",
                              child: Text("AM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            ),
                            DropdownMenuItem(
                              value: "PM",
                              child: Text("PM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              monFriEndSelection = value;
                            });
                          }),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Sat:",
                            style: TextStyles.kDefaultLightTextStyle),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 60,
                        child: TextField(
                            inputFormatters: [maskFormatter],
                            controller: satBegin,
                            style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      DropdownButton(
                          value: satBeginSelection,
                          items: [
                            DropdownMenuItem(
                              value: "AM",
                              child: Text("AM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            ),
                            DropdownMenuItem(
                              value: "PM",
                              child: Text("PM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              satBeginSelection = value;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("-", style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 60,
                        child: TextField(
                            inputFormatters: [maskFormatter],
                            controller: satEnd,
                            style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      DropdownButton(
                          value: satEndSelection,
                          items: [
                            DropdownMenuItem(
                              value: "AM",
                              child: Text("AM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            ),
                            DropdownMenuItem(
                              value: "PM",
                              child: Text("PM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              satEndSelection = value;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Sun:",
                            style: TextStyles.kDefaultLightTextStyle),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 60,
                        child: TextField(
                            inputFormatters: [maskFormatter],
                            controller: sunBegin,
                            style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      DropdownButton(
                          value: sunBeginSelection,
                          items: [
                            DropdownMenuItem(
                              value: "AM",
                              child: Text("AM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            ),
                            DropdownMenuItem(
                              value: "PM",
                              child: Text("PM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              sunBeginSelection = value;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("-", style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 60,
                        child: TextField(
                            controller: sunEnd,
                            inputFormatters: [maskFormatter],
                            style: TextStyles.kDefaultCreamTextStyle),
                      ),
                      DropdownButton(
                          value: sunEndSelection,
                          items: [
                            DropdownMenuItem(
                              value: "AM",
                              child: Text("AM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            ),
                            DropdownMenuItem(
                              value: "PM",
                              child: Text("PM",
                                  style: TextStyles.kDefaultCreamTextStyle),
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              sunEndSelection = value;
                            });
                          }),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: CortadoButton(
                      text: "Update Hours",
                      color: AppColors.light,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

reformatHours(Map hours) {
  Map<String, String> reformattedHours = {
    'monFriBegin': null,
    'monFriEnd': null,
    'satBegin': null,
    'satEnd': null,
    'sunBegin': null,
    'sunEnd': null,
  };

  if (hours['Mon-Fri'] != "Closed") {
    String monFri =
        hours['Mon-Fri'].toString().replaceAll(RegExp(r'[amp]'), "");
    int dashIndex = monFri.indexOf('-');
    reformattedHours['monFriBegin'] = monFri.substring(0, dashIndex);
    reformattedHours['monFriEnd'] = monFri.substring(dashIndex + 1);
  }

  if (hours['Sat'] != "Closed") {
    String sat = hours['Sat'].toString().replaceAll(RegExp(r'[amp]'), "");
    int dashIndex = sat.indexOf('-');
    reformattedHours['satBegin'] = sat.substring(0, dashIndex);
    reformattedHours['satEnd'] = sat.substring(dashIndex + 1);
  }

  if (hours['Sun'] != "Closed") {
    String sun = hours['Sun'].toString().replaceAll(RegExp(r'[amp]'), "");
    int dashIndex = sun.indexOf('-');
    reformattedHours['sunBegin'] = sun.substring(0, dashIndex);
    reformattedHours['sunEnd'] = sun.substring(dashIndex + 1);
  }

  return reformattedHours;
}

createPayoutAccountDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          backgroundColor: AppColors.dark, child: PayoutDetailsDialogForm());
    },
  );
}

createBaristaDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          backgroundColor: AppColors.dark, child: BaristaDetailsDialogForm());
    },
  );
}
