import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ItemListPage extends StatefulWidget {
  ItemListPage({Key key, this.categoryType, this.category}) : super(key: key);
  final CategoryType categoryType;
  final Category category;
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.caramel,
      ),
      body: _categoryListBody(),
    );
  }

  Widget _categoryListBody() {
    switch (widget.categoryType) {
      case CategoryType.drink:
        return _drinkItemList();
        break;
      case CategoryType.food:
        return _foodItemList();
        break;
      case CategoryType.addIn:
        return _addInItemList();
        break;
      default:
        return Container();
    }
  }

  _drinkItemList() {
    ScrollController scrollController = ScrollController();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '',
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  var drink = await Navigator.of(context)
                      .pushNamed('/menu/category/item', arguments: [
                    CategoryType.drink,
                    null,
                    Drink(
                        servedIced: false,
                        id: Uuid().v4(),
                        redeemableType: RedeemableType.none,
                        redeemableSize: SizeInOunces.none,
                        sizePriceMap: {"8 oz": '', '12 oz': '', '16 oz': ''}),
                  ]);
                  if (drink != null) {
                    setState(() {
                      widget.category.items.add(drink);
                      //  _menuBloc.add(UpdateMenu(coffeeShop));
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      "Create Drink",
                      style: TextStyles.kDefaultSmallTextCreamStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: AppColors.cream,
                        size: 20,
                      ),
                    ),
                  ],
                ))
          ],
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
                controller: scrollController,
                itemCount: widget.category.items.length,
                itemBuilder: (context, index) {
                  List<Drink> drinks = widget.category.items.cast<Drink>();
                  return Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadiusDirectional.circular(8.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            drinks[index].name,
                            style: TextStyles.kDefaultCaramelTextStyle,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: AppColors.caramel,
                              ),
                              onPressed: () async {
                                var drink = await Navigator.of(context)
                                    .pushNamed('/menu/category/item',
                                        arguments: [
                                      CategoryType.drink,
                                      widget.category,
                                      drinks[index]
                                    ]);

                                if (drink != null) {
                                  setState(() {
                                    drinks.removeAt(index);
                                    drinks.insert(index, drink);
                                    widget.category.items = drinks;
                                    // _menuBloc.add(UpdateMenu(coffeeShop));
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: AppColors.caramel,
                              ),
                              onPressed: () {
                                widget.category.items.removeAt(index);

                                // _menuBloc.add(UpdateMenu(coffeeShop));
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  _foodItemList() {
    ScrollController scrollController = ScrollController();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.category.title,
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  var foodItem = await Navigator.of(context)
                      .pushNamed('/menu/category/item', arguments: [
                    CategoryType.food,
                    widget.category,
                    Food(
                      id: Uuid().v4(),
                    ),
                  ]);
                  if (foodItem != null) {
                    setState(() {
                      widget.category.items.add(foodItem);
                      // _menuBloc.add(UpdateMenu(coffeeShop));
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      "Create Food",
                      style: TextStyles.kDefaultSmallTextCreamStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: AppColors.cream,
                        size: 20,
                      ),
                    ),
                  ],
                ))
          ],
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
                controller: scrollController,
                itemCount: widget.category.items.length,
                itemBuilder: (context, index) {
                  List<Food> food = widget.category.items.cast<Food>();
                  return Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadiusDirectional.circular(8.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            food[index].name,
                            style: TextStyles.kDefaultCaramelTextStyle,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: AppColors.caramel,
                              ),
                              onPressed: () async {
                                var foodItem = await Navigator.of(context)
                                    .pushNamed('/menu/category/item',
                                        arguments: [
                                      CategoryType.food,
                                      widget.category,
                                      food[index],
                                    ]);
                                if (foodItem != null) {
                                  setState(() {
                                    food.removeAt(index);
                                    food.insert(index, foodItem);
                                    widget.category.items = food;
                                    //   _menuBloc.add(UpdateMenu(coffeeShop));
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: AppColors.caramel,
                              ),
                              onPressed: () {
                                widget.category.items.removeAt(index);

                                // _menuBloc.add(UpdateMenu(coffeeShop));
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  _addInItemList() {
    ScrollController scrollController = ScrollController();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.category.title,
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  var addIn = await Navigator.of(context)
                      .pushNamed('/menu/category/item', arguments: [
                    CategoryType.addIn,
                    widget.category,
                    AddIn(
                      id: Uuid().v4(),
                    ),
                  ]);
                  if (addIn != null) {
                    setState(() {
                      widget.category.items.add(addIn);
                      //   _menuBloc.add(UpdateMenu(coffeeShop));
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      "Create Add In",
                      style: TextStyles.kDefaultSmallTextCreamStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: AppColors.cream,
                        size: 20,
                      ),
                    ),
                  ],
                ))
          ],
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
                controller: scrollController,
                itemCount: widget.category.items.length,
                itemBuilder: (context, index) {
                  List<AddIn> addIns = widget.category.items.cast<AddIn>();
                  return Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadiusDirectional.circular(8.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            addIns[index].name,
                            style: TextStyles.kDefaultCaramelTextStyle,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: AppColors.caramel,
                              ),
                              onPressed: () async {
                                /*    var addIn = await Navigator.of(context)
                                    .pushNamed('/menu/category/item',
                                        arguments: [
                                      CategoryType.addIn,
                                      widget.category,
                                      addIns[index],
                                    ]);
                                if (addIn != null) {
                                  setState(() {
                                    addIns.removeAt(index);
                                    addIns.insert(index, addIn);
                                    widget.category.items = addIns;
                                    _menuBloc.add(UpdateMenu(coffeeShop));
                                  });
                                } */
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: AppColors.caramel,
                              ),
                              onPressed: () {
                                widget.category.items.removeAt(index);

                                //     _menuBloc.add(UpdateMenu(coffeeShop));
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
