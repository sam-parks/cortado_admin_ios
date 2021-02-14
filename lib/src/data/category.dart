import 'package:cortado_admin_ios/src/data/item.dart';

class Category {
  String id;
  List<Item> items;
  String title;
  String description;

  Category(this.id, this.items, this.title, this.description);

  

  Category.fromData(Map<dynamic, dynamic> data, List<Item> items)
      : this.id = data['id'],
        this.items = items,
        this.title = data['title'],
        this.description = data['description'];

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'items': itemsToJson(items)
    };
  }
}

List<Map<dynamic, dynamic>> itemsToJson(List<Item> items) {
  List<Map<dynamic, dynamic>> itemMap = [];
  if (items is List<Drink>) {
    items.forEach((drink) {
      itemMap.add(drink.toJson());
    });
  } else if (items is List<Food>) {
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
