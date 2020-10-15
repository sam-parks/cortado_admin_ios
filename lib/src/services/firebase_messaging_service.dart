import 'dart:async';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dialogs.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';

class FBMessagingAndNotificationService extends ChangeNotifier {
  FBMessagingAndNotificationService._();
  static FBMessagingAndNotificationService _instance =
      FBMessagingAndNotificationService._();
  static FBMessagingAndNotificationService get instance => _instance;
  firebase.Messaging _mc;
  String _token;

  String get token => _token;
  PageController _dashboardController;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void close() {
    _controller?.close();
  }

  Future<void> init(String userID, PageController dashboardController) async {
    _mc = firebase.messaging();
    if (_token == null) {
      _mc.usePublicVapidKey(
          'BCv7AOFgk5cnZm5TrNibKTue4gLDxK7zPK3Eo1VOyRuRSL0hu6_pE12DqHiozeuO6_9_aEHt0eJ6BzI6eTnnaQk');
    }
    _mc.onMessage.listen((event) {
      _controller.add(event?.data);
      handleNotification(event.data['type'], event.notification.title);
    });
    _mc.requestPermission().then((_) async {
      // get token from device
      _token = await _mc.getToken();
      if (_token != null) {
        var tokenRef = firestore()
            .collection('users')
            .doc(userID)
            .collection("tokens")
            .doc('web_token');
        await tokenRef.set({
          'token': _token,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': "web"
        });

        print('Token: $_token');
      }
    });

    _dashboardController = dashboardController;
  }

  handleNotification(String type, String title) {
    var currentState = NavigationService.navigatorKey?.currentState;
    if (type == "newOrder") {
      newOrderDialog(title, currentState.overlay.context, _dashboardController);
    }
  }

  clearToken() {
    _token = null;
  }

  Future requestPermission() {
    return _mc.requestPermission();
  }

  Future<String> getToken(String userId, [bool force = false]) async {
    if (force || _token == null) {
      await requestPermission();
      _token = await _mc.getToken();
      firestore()
          .collection('users')
          .doc(userId)
          .collection("tokens")
          .doc('web_token')
          .update(data: {
        'token': _token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': "web"
      });
    }
    return _token;
  }
}
