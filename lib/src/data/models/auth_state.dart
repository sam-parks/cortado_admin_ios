import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  CortadoUser _user;
  String _error = '';
  bool _loading = false;

  UserType _userType;

  String get error => _error;

  bool get isLoggedIn => _user != null;

  CortadoUser get user => _user;

  User get fbUser => getCurrentFirebaseUser();

  bool get isLoading => _loading;

  UserType get userType => _userType;

  Future loginWithEmail(String email, String password) async {
    _error = '';
    _setLoading(true);

    try {
      _user = await registerUser(email, password);
      if (_user != null) {
        bool _cortadoFullAdmin = await checkCortadoFullAdmin(_user);
        if (_cortadoFullAdmin) {
          print('userType: super');
          _userType = UserType.superUser;
          _user.userType = UserType.superUser;
          _setLoading(false);
          return;
        }
        bool _coffeeShopAdmin = await checkCoffeeShopAdmin(_user);
        if (_coffeeShopAdmin) {
          print('userType: owner');
          _userType = UserType.owner;
          _user.userType = UserType.owner;
          _setLoading(false);
          return;
        }
        bool _barista = await checkBarista(_user);
        if (_barista) {
          print('userType: barista');
          _userType = UserType.barista;
          _user.userType = UserType.barista;
          _setLoading(false);
          return;
        }
        throw 'Invalid User';
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> logoutApp() async {
    _user = null;
    notifyListeners();
    await logout();
  }

  Future sendForgotPassword(String email) async {
    await forgotPassword(email);
    notifyListeners();
  }

  void init() async {
    _error = '';
    _setLoading(true);

    try {
      _user = await checkUser();
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
    _setLoading(false);
  }

  setCurrentUser(CortadoUser user) {
    _user = user;
    _userType = user.userType;
  }
}

enum UserType { barista, owner, superUser }

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.superUser:
        return "superUser";
        break;
      case UserType.barista:
        return "barista";
        break;
      case UserType.owner:
        return "owner";
        break;
      default:
        return "error";
    }
  }

  userTypeToString() {
    return this.value;
  }
}
