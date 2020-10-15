import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageService extends ChangeNotifier {
  final LocalStorage storage = LocalStorage('user.json');


  Future<void> saveUserToLocal(CortadoUser user) {
    return storage.setItem("currentUser", user.toJsonEncodable());
  }

  Future<void> clearStorage() async {
    await storage.deleteItem("currentUser");
    return storage.clear();
  }

  CortadoUser getUser(String id) {
    dynamic userJson = storage.getItem(id);
    if (userJson != null) {
      return CortadoUser.fromData(userJson);
    }
    return null;
  }
}
