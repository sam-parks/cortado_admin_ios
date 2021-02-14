import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/discount.dart';

class Menu {
  final List<Category> addIns;
  final List<Category> drinkTemplates;
  final List<Category> foodTemplates;
  final List<Discount> discounts;

  const Menu({
    this.addIns = const [],
    this.drinkTemplates= const [],
    this.foodTemplates= const [],
    this.discounts= const [],
  });

  Menu copyWith({
    final List<Category> addIns,
    final List<Category> drinkTemplates,
    final List<Category> foodTemplates,
    final List<Discount> discounts,
  }) {
    return Menu(
        addIns: addIns ?? this.addIns,
        drinkTemplates: drinkTemplates ?? this.drinkTemplates,
        foodTemplates: foodTemplates ?? this.foodTemplates,
        discounts: discounts ?? this.discounts);
  }

  Menu copy(Menu menu) {
    return Menu(
        addIns: menu.addIns ?? this.addIns,
        drinkTemplates: menu.drinkTemplates ?? this.drinkTemplates,
        foodTemplates: menu.foodTemplates ?? this.foodTemplates,
        discounts: menu.discounts ?? this.discounts);
  }

  static const empty = const Menu();
}
