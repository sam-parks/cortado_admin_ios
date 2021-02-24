import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/router.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
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
                  /*   var drink = await Navigator.of(context)
                      .pushNamed(kItemRoute, arguments: [
                    false,
                    CategoryType.drink,
                    widget.category,
                    DrinkTemplate(
                        servedIced: false,
                        id: Uuid().v4(),
                        redeemableType: RedeemableType.none,
                        redeemableSize: SizeInOunces.none,
                        sizePriceMap: {"8 oz": '', '12 oz': '', '16 oz': ''}),
                  ]); */
                },
                child: Row(
                  children: [
                    Text(
                      "Create DrinkTemplate",
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
                  List<DrinkTemplate> drinks =
                      widget.category.items.cast<DrinkTemplate>();
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
                                /* var drink = await Navigator.of(context)
                                    .pushNamed(kItemRoute, arguments: [
                                  true,
                                  CategoryType.drink,
                                  widget.category,
                                  drinks[index]
                                ]); */
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
                      .pushNamed(kItemRoute, arguments: [
                    false,
                    CategoryType.food,
                    widget.category,
                    FoodTemplate(
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
                      "Create FoodTemplate",
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
                  List<FoodTemplate> food =
                      widget.category.items.cast<FoodTemplate>();
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
                                /* var foodItem = await Navigator.of(context)
                                    .pushNamed(kItemRoute, arguments: [
                                  true,
                                  CategoryType.food,
                                  widget.category,
                                  food[index],
                                ]); */
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: AppColors.caramel,
                              ),
                              onPressed: () {},
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
            Row(
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
            )
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
                                /* var addIn = await Navigator.of(context)
                                    .pushNamed('/menu/category/item',
                                        arguments: [
                                      CategoryType.addIn,
                                      widget.category,
                                      addIns[index],
                                    ]); */
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: AppColors.caramel,
                              ),
                              onPressed: () {
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
