import 'package:cortado_admin_ios/src/data/models/auth_state.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _username = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _passwordFocus = FocusNode();

  bool _justEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              'images/blue-path1.png',
              width: 400,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'images/blue-path2.png',
              height: 600,
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            child: Image.asset(
              'images/corner-plants-left.png',
              width: 100,
            ),
          ),
          Positioned(
            top: 25,
            right: 0,
            child: Image.asset(
              'images/corner-plants-right.png',
              width: 200,
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            child: Image.asset(
              'images/coffee-beans-left.png',
              width: 100,
            ),
          ),
          Positioned(
            bottom: 250,
            right: 0,
            child: Image.asset(
              'images/coffee-beans-right.png',
              width: 100,
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildImage(),
                    _buildForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      child: Consumer<AuthState>(
        builder: (context, auth, child) => Form(
          key: _formKey,
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: _username,
                  style: TextStyles.kDefaultCaramelTextStyle,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyles.kDefaultDarkTextStyle),
                  autocorrect: false,
                  autofocus: false,
                  onFieldSubmitted: (val) {
                    _passwordFocus.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val.isNotEmpty ? null : 'Email Required',
                  onSaved: (val) => _username = val,
                ),
                TextFormField(
                  focusNode: _passwordFocus,
                  initialValue: _password,
                  style: TextStyles.kDefaultCaramelTextStyle,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyles.kDefaultDarkTextStyle),
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (val) {
                    _signIn(auth);
                  },
                  validator: (val) =>
                      _justEmail || val.isNotEmpty ? null : 'Password Required',
                  onSaved: (val) => _password = val,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: CortadoButton(
                    fontSize: 30,
                    color: AppColors.caramel,
                    text: 'Log In',
                    onTap: () {
                      _signIn(auth);
                    },
                  ),
                ),
                //GoogleSignInButton(),
                if (auth.isLoading) ...[
                  CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.caramel))
                ],
                if (auth.error.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: RaisedButton(
                      child: Text('Forgot Password?'),
                      onPressed: () async {
                        _justEmail = true;
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          await auth.sendForgotPassword(_username);
                          _showMessage('Reset link sent to your email!');
                        }
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signIn(AuthState authState) async {
    _justEmail = false;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await authState.loginWithEmail(_username, _password);
      if (authState.error.isNotEmpty) {
        _showMessage(authState.error);
      }
    }
  }

  Widget _buildImage() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Image.asset('images/coffee_shop.png', width: 100),
      ),
      Image(
        width: 150.0,
        height: 50,
        image: AssetImage("images/cortado-logo.png"),
      ),
      Text("Admin Portal", style: TextStyles.kDefaultDarkTextStyle),
    ]);
  }

  void _showMessage(String value) {
    Flushbar(
      icon: Icon(
        Icons.error_outline,
        color: AppColors.light,
      ),
      message: value,
      duration: Duration(seconds: 3),
      isDismissible: true,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: AppColors.dark,
    )..show(context);
  }
}
