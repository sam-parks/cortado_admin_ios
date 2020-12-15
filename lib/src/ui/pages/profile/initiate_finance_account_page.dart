import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/finance/account/finance_bloc.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_input_field.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitiateFinanceAccountPage extends StatefulWidget {
  InitiateFinanceAccountPage({Key key}) : super(key: key);

  @override
  _InitiateFinanceAccountPageState createState() =>
      _InitiateFinanceAccountPageState();
}

class _InitiateFinanceAccountPageState
    extends State<InitiateFinanceAccountPage> {
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
    FinanceBloc _financeBloc = BlocProvider.of<FinanceBloc>(context);
    CoffeeShopState _coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;
    return BlocListener(
      cubit: _financeBloc,
      listener: (BuildContext context, FinanceState state) {
        if (state.status == FinanceStatus.unverified ||
            state.status == FinanceStatus.verified) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Your Finance Account",
            style: TextStyle(
                color: AppColors.light,
                fontFamily: kFontFamilyNormal,
                fontSize: 40),
          ),
          backgroundColor: AppColors.caramel,
        ),
        backgroundColor: AppColors.light,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CortadoInputField(
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
                      padding: const EdgeInsets.all(16.0),
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
                      padding: const EdgeInsets.all(16.0),
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
                      padding: const EdgeInsets.all(16.0),
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
                              horizontal: 60, vertical: 20),
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
                                      style:
                                          TextStyles.kDefaultCaramelTextStyle),
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
                                      style:
                                          TextStyles.kDefaultCaramelTextStyle),
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
                  ],
                )),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CortadoFatButton(
          text: "Submit",
          textStyle: TextStyles.kDefaultLightTextStyle,
          backgroundColor: AppColors.caramel,
          width: 300,
          onTap: () {
            if (_formKey.currentState.validate() &&
                _accountHolderType != null) {
              _financeBloc.add(CreateCustomAccount(
                  _businessEmail,
                  _accountHolderName,
                  _accountHolderType,
                  _routingNumber,
                  _accountNumber,
                  _coffeeShopState.coffeeShop));
            }
          },
        ),
      ),
    );
  }
}
