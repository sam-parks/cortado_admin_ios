import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/auth_service.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dialogs.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

const String _orderType = "order";

class NotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging();
  AuthService get _authService => locator.get();
  StreamSubscription _iosSubscription;

  dispose() {
    _iosSubscription?.cancel();
  }

  start() async {
    await _saveDeviceToken();

    if (Platform.isIOS) {
      sleep(Duration(milliseconds: 500));
      await _fcm.requestNotificationPermissions(IosNotificationSettings());
      _iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print('iOS settings registered');
      });
      _configure();
    } else {
      _configure();
    }
  }

  _configure() {
    _fcm.configure(
      onMessage: _onMessage,
      onBackgroundMessage: Platform.isAndroid ? _onBG : null,
      onLaunch: _onLaunch,
      onResume: _onLaunch,
    );
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> message) async {
    print('onLaunch $message');
    CortadoUser user = await _authService.getCurrentUser();
    if (user == null) return;
    if (message.containsKey('type')) {
      String type = message['type'];
      //var currentState = NavigationService.navigatorKey?.currentState;
      switch (type) {
        case _orderType:
          break;
      }
    }
  }

  handleNotification(String type, String title) {
    var currentState = NavigationService.navigatorKey?.currentState;
    if (type == "newOrder") {
      newOrderDialog(title, currentState.overlay.context);
    }
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message) async {
    print('onMessage $message');
    CortadoUser user = await _authService.getCurrentUser();
    if (user == null) return;
    if (message.containsKey('type')) {
      String type = message['type'];
      //var currentState = NavigationService.navigatorKey?.currentState;
      switch (type) {
        case _orderType:
          break;
      }
    }
  }

  void stop() async {
    await _deleteDeviceToken();
  }

  _saveDeviceToken() async {
    // get current user
    CortadoUser user = await _authService.getCurrentUser();
    if (user == null) return;
    // get token from device
    String fcmToken = await _fcm.getToken();

    //save token to database
    if (fcmToken != null) {
      var tokenRef = user.reference.collection("tokens").doc(fcmToken);
      await tokenRef.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  _deleteDeviceToken() async {
    CortadoUser user = await _authService.getCurrentUser();
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null && user != null) {
      var tokenRef = user.reference.collection("tokens").doc(fcmToken);
      try {
        await tokenRef.delete();
      } catch (e) {
        print('Failed to delete user\'s token');
      }
    }
  }
}

Future<dynamic> _onBG(Map<String, dynamic> message) async {
  print("_onBG: $message");
  return Future<void>.value();
}
