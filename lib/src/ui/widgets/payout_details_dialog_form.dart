import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/payment/bloc.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_input_field.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:cortado_admin_ios/src/ui/widgets/loading_state_button.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PayoutDetailsDialogForm extends StatefulWidget {
  PayoutDetailsDialogForm({
    Key key,
  }) : super(key: key);

  @override
  _PayoutDetailsDialogFormState createState() =>
      _PayoutDetailsDialogFormState();
}

class _PayoutDetailsDialogFormState extends State<PayoutDetailsDialogForm> {
  FocusNode _emaiFocus = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _businessEmail;
  String _accountHolderName;
  String _accountHolderType;
  String _accountNumber;
  String _routingNumber;
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    PaymentBloc _paymentBloc = Provider.of<PaymentBloc>(context);
    CoffeeShopState _coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;
    return BlocListener(
      cubit: _paymentBloc,
      listener: (BuildContext context, state) {
        if (state is CustomAccountCreated) {
          Navigator.of(context).pop();
        }
      },
      child: DashboardCard(
        height: SizeConfig.screenHeight * .7,
        title: "Create Your Account",
        content: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CortadoInputField(
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: _emaiFocus,
                    isPassword: false,
                    autofocus: true,
                    enabled: true,
                    label: "Business Email",
                    validator: (value) {
                      return Validate.validateEmail(value);
                    },
                    onChanged: (value) {
                      _businessEmail = value.trim();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CortadoInputField(
                    textCapitalization: TextCapitalization.sentences,
                    isPassword: false,
                    autofocus: true,
                    enabled: true,
                    label: "Account Holder Name",
                    validator: (value) {
                      return Validate.requiredField(
                          value, "Field cannot be empty.");
                    },
                    onChanged: (value) {
                      _accountHolderName = value.trim();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CortadoInputField(
                    textCapitalization: TextCapitalization.sentences,
                    isPassword: false,
                    autofocus: true,
                    enabled: true,
                    label: "Account Number",
                    validator: (value) {
                      return Validate.requiredField(
                          value, "Field cannot be empty.");
                    },
                    onChanged: (value) {
                      _accountNumber = value.trim();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CortadoInputField(
                    textCapitalization: TextCapitalization.sentences,
                    isPassword: false,
                    autofocus: true,
                    enabled: true,
                    label: "Routing Number",
                    validator: (value) {
                      return Validate.validateAbaRoutingNumber(value);
                    },
                    onChanged: (value) {
                      _routingNumber = value.trim();
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 54, vertical: 14),
                      child: Text(
                        "Account Holder Type",
                        style: TextStyles.kHintTextStyle,
                      ),
                    )),
                Container(
                  width: SizeConfig.screenWidth * .3,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Text("Company",
                                  style: TextStyles.kDefaultCaramelTextStyle),
                              Checkbox(
                                checkColor: AppColors.dark,
                                activeColor: AppColors.cream,
                                value: _accountHolderType == "Company",
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      setState(() {
                                        _accountHolderType = "Company";
                                      });
                                    } else {
                                      setState(() {
                                        _accountHolderType = null;
                                      });
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Text("Individual",
                                  style: TextStyles.kDefaultCaramelTextStyle),
                              Checkbox(
                                checkColor: AppColors.dark,
                                activeColor: AppColors.cream,
                                value: _accountHolderType == "Individual",
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      setState(() {
                                        _accountHolderType = "Individual";
                                      });
                                    } else {
                                      setState(() {
                                        _accountHolderType = null;
                                      });
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                LoadingStateButton<PaymentLoadingState>(
                  bloc: _paymentBloc,
                  button: CortadoButton(
                    text: "Submit",
                    color: AppColors.caramel,
                    fontSize: 30,
                    lineWidth: 120,
                    onTap: () {
                      if (_formKey.currentState.validate() &&
                          _accountHolderType != null) {
                        _paymentBloc.add(CreateCustomAccount(
                            _businessEmail,
                            _accountHolderName,
                            _accountHolderType,
                            _routingNumber,
                            _accountNumber,
                            _coffeeShopState.coffeeShop));
                      }
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}
