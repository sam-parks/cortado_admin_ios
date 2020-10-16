import 'package:cortado_admin_ios/src/bloc/navigation/navigation_bloc.dart';
import 'package:cortado_admin_ios/src/ui/pages/home_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/category_list_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/item_list_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_item_page.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';

class Routes {
  static void configureRoutes(fluro.Router router) {
    router.notFoundHandler = fluro.Handler(handlerFunc: (context, parameters) {
      debugPrint("Route was not found.");
      return Container();
    });
    router.define('/',
        handler: fluro.Handler(
          handlerFunc: (context, parameters) => HomePage(
            reauth: false,
            screen: CortadoAdminScreen.dashboard,
          ),
        ));

    router.define('/home',
        handler: fluro.Handler(
          handlerFunc: (context, parameters) => HomePage(
            reauth: false,
            screen: CortadoAdminScreen.dashboard,
          ),
        ));
    router.define('/payment',
        handler: fluro.Handler(
          handlerFunc: (context, parameters) => HomePage(
            reauth: false,
            screen: CortadoAdminScreen.profile,
          ),
        ));
    router.define('/payment/reauth',
        handler: fluro.Handler(
          handlerFunc: (context, parameters) => HomePage(
            reauth: true,
            screen: CortadoAdminScreen.profile,
          ),
        ));
    router.define('/payment/return',
        handler: fluro.Handler(
          handlerFunc: (context, parameters) => HomePage(
            reauth: false,
            screen: CortadoAdminScreen.profile,
          ),
        ));
    router.define('/menu/category-list', handler: _menuCategoryListHandler);
    router.define('/menu/category-list/item-list',
        handler: _menuItemListHandler);
    router.define('/menu/category', handler: _menuCategoryHandler);
    router.define('/menu/category/item', handler: _menuItemHandler);
  }

  static fluro.Handler _menuCategoryHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    List args = ModalRoute.of(context).settings.arguments;

    return MenuCategoryPage(
      category: args[0],
      categoryType: args[1],
      newCategory: args[2],
    );
  });

  static fluro.Handler _menuCategoryListHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return CategoryListPage(
      categoryType: ModalRoute.of(context).settings.arguments,
    );
  });

  static fluro.Handler _menuItemListHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    List args = ModalRoute.of(context).settings.arguments;
    return ItemListPage(
      categoryType: args[0],
      category: args[1],
    );
  });

  static fluro.Handler _menuItemHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    List args = ModalRoute.of(context).settings.arguments;

    return MenuItemPage(
      categoryType: args[0],
      category: args[1],
      item: args[2],
      newCategory: args[3],
      editing: args[4],
    );
  });
}
