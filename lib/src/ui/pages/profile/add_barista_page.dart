import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/bloc.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_input_field.dart';
import 'package:cortado_admin_ios/src/ui/widgets/loading_state_button.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBaristaPage extends StatefulWidget {
  AddBaristaPage({Key key}) : super(key: key);

  @override
  _AddBaristaPageState createState() => _AddBaristaPageState();
}

class _AddBaristaPageState extends State<AddBaristaPage> {
  FocusNode _lastNameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _firstName;
  String _lastName;
  String _password;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    BaristaManagementBloc _baristaManagementBloc =
        BlocProvider.of<BaristaManagementBloc>(context);
    CoffeeShopState _coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;
    return BlocListener(
      cubit: _baristaManagementBloc,
      listener: (context, state) {
        if (state is BaristasLoadSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add A Barista",
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
                        textCapitalization: TextCapitalization.sentences,
                        isPassword: false,
                        autofocus: true,
                        enabled: true,
                        label: "First Name",
                        validator: (value) {
                          return Validate.requiredField(
                              value, "Field cannot be empty.");
                        },
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_lastNameFocus);
                        },
                        onChanged: (value) {
                          _firstName = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CortadoInputField(
                        focusNode: _lastNameFocus,
                        textCapitalization: TextCapitalization.sentences,
                        isPassword: false,
                        autofocus: true,
                        enabled: true,
                        label: "Last Name",
                        validator: (value) {
                          return Validate.requiredField(
                              value, "Field cannot be empty.");
                        },
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                        onChanged: (value) {
                          _lastName = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CortadoInputField(
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: _emailFocus,
                        isPassword: false,
                        autofocus: true,
                        enabled: true,
                        label: "Email",
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        validator: (value) {
                          return Validate.validateEmail(value);
                        },
                        onChanged: (value) {
                          _email = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CortadoInputField(
                        focusNode: _passwordFocus,
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
                  ],
                )),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: LoadingStateButton<BaristasLoadInProgress>(
          bloc: _baristaManagementBloc,
          button: CortadoFatButton(
            text: "Submit",
            textStyle: TextStyles.kDefaultLightTextStyle,
            backgroundColor: AppColors.caramel,
            width: 300,
            onTap: () {
              if (_formKey.currentState.validate()) {
                _baristaManagementBloc.add(CreateBarista(_email, _firstName,
                    _lastName, _password, _coffeeShopState.coffeeShop.id));
              }
            },
          ),
        ),
      ),
    );
  }
}
