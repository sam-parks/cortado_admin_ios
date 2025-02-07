import 'package:cortado_admin_ios/src/data/item_template.dart';

class Category {
  String id;
  List<ItemTemplate> items;
  String title;
  String description;

  Category(this.id, this.items, this.title, this.description);

  Category.fromData(Map<dynamic, dynamic> data, List<ItemTemplate> items)
      : this.id = data['id'],
        this.items = items,
        this.title = data['title'],
        this.description = data['description'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

List<Map<dynamic, dynamic>> itemsToJson(List<ItemTemplate> items) {
  List<Map<dynamic, dynamic>> itemMap = [];
  if (items is List<DrinkTemplate>) {
    items.forEach((drink) {
      itemMap.add(drink.toJson());
    });
  } else if (items is List<FoodTemplate>) {
    items.forEach((food) {
      itemMap.add(food.toJson());
    });
  } else if (items is List<AddIn>) {
    items.forEach((addIn) {
      itemMap.add(addIn.toJson());
    });
  }

  return itemMap;
}
