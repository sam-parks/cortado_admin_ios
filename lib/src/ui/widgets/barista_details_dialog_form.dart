import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/bloc.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_input_field.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:cortado_admin_ios/src/ui/widgets/loading_state_button.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BaristaDetailsForm extends StatefulWidget {
  BaristaDetailsForm({
    Key key,
  }) : super(key: key);

  @override
  _BaristaDetailsFormState createState() => _BaristaDetailsFormState();
}

class _BaristaDetailsFormState extends State<BaristaDetailsForm> {
  FocusNode _emaiFocus = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _firstName;
  String _lastName;
  String _password;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    BaristaManagementBloc _baristaManagementBloc =
        Provider.of<BaristaManagementBloc>(context);
    CoffeeShopState _coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;
    return BlocListener(
      cubit: _baristaManagementBloc,
      listener: (BuildContext context, state) {
        if (state is BaristasLoadSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: DashboardCard(
        height: SizeConfig.screenHeight * .7,
        title: "Add a Barista to Your Account",
        content: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CortadoInputField(
                    textCapitalization: TextCapitalization.sentences,
                    isPassword: false,
                    autofocus: true,
                    enabled: true,
                    label: "First Name",
                    validator: (value) {
                      return Validate.requiredField(
                          value, "Field cannot be empty.");
                    },
                    onChanged: (value) {
                      _firstName = value.trim();
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
                    label: "Last Name",
                    validator: (value) {
                      return Validate.requiredField(
                          value, "Field cannot be empty.");
                    },
                    onChanged: (value) {
                      _lastName = value.trim();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CortadoInputField(
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: _emaiFocus,
                    isPassword: false,
                    autofocus: true,
                    enabled: true,
                    label: "Email",
                    validator: (value) {
                      return Validate.validateEmail(value);
                    },
                    onChanged: (value) {
                      _email = value.trim();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CortadoInputField(
                    textCapitalization: TextCapitalization.sentences,
                    isPassword: true,
                    autofocus: true,
                    enabled: true,
                    label: "Password For Login",
                    validator: (value) {
                      return Validate.requiredField(
                          value, "Field cannot be empty.");
                    },
                    onChanged: (value) {
                      _password = value.trim();
                    },
                  ),
                ),
                Spacer(),
                LoadingStateButton<BaristasLoadInProgress>(
                  bloc: _baristaManagementBloc,
                  button: CortadoButton(
                    text: "Submit",
                    color: AppColors.caramel,
                    fontSize: 30,
                    lineWidth: 120,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        _baristaManagementBloc.add(CreateBarista(
                            _email,
                            _firstName,
                            _lastName,
                            _password,
                            _coffeeShopState.coffeeShop.id));
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
