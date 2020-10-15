import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/services/auth_service.dart';
import 'package:cortado_admin_ios/src/services/barista_service.dart';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:cortado_admin_ios/src/services/notification_service.dart';
import 'package:cortado_admin_ios/src/services/user_service.dart';
import 'package:cortado_admin_ios/src/services/stripe_service.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:cortado_admin_ios/src/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

registerLocatorItems(bool live) {
  var firestore = FirebaseFirestore.instance;
  var firebaseAuth = FirebaseAuth.instance;
  locator.registerSingleton(firestore);
  locator.registerLazySingleton(() => true);
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => OrderService(firestore));
  locator.registerLazySingleton(() => CoffeeShopService(firestore));
  locator.registerLazySingleton(() => UserService(firestore));
  locator.registerLazySingleton(() => AuthService(firebaseAuth));
  locator.registerLazySingleton(() => StripeService(live));
  locator.registerLazySingleton(() => BaristaService(firestore));
}
