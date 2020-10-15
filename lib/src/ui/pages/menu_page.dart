import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_redemptions_bar_chart.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.coffeeShop}) : super(key: key);
  final CoffeeShop coffeeShop;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool drinkCategories = false;
  bool drinks = false;
  bool foodCategories = false;
  bool food = false;
  bool addInCategories = false;
  bool addIns = false;

  Category selectedCategory;

  MenuBloc _menuBloc;

  @override
  Widget build(BuildContext context) {
    _menuBloc = Provider.of<MenuBloc>(context);
    CoffeeShopState coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;

    ScrollController _scrollController = ScrollController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Scrollbar(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: ListView(
              controller: _scrollController,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "Online Menu",
                          maxLines: 1,
                          style: TextStyles.kWelcomeTitleTextStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Customize items available through Cortado!",
                            style: TextStyles.kDefaultCaramelTextStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _editMenuWidget(coffeeShopState),
                    _mostOrderedItemsWidget()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _editDiscountsWidget(coffeeShopState),
                    _currentDealsWidget(coffeeShopState)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _editMenuWidget(CoffeeShopState coffeeShopState) {
    ScrollController _scrollController = ScrollController();
    return Expanded(
      child: DashboardCard(
          innerColor: Colors.transparent,
          titleLeftPlacement: 40,
          topLeftWidget: _menuBackButton(),
          title: "Edit Menu and Redemptions",
          content: drinkCategories
              ? drinks
                  ? _drinkPanel(_scrollController, coffeeShopState)
                  : _drinkCategoryPanel(_scrollController, coffeeShopState)
              : foodCategories
                  ? food
                      ? _foodPanel(_scrollController, coffeeShopState)
                      : _foodCategoryPanel(_scrollController, coffeeShopState)
                  : addInCategories
                      ? addIns
                          ? _addInsPanel(_scrollController, coffeeShopState)
                          : _addInCategoryPanel(
                              _scrollController, coffeeShopState)
                      : _menuWidget()),
    );
  }

  _menuBackButton() {
    return drinkCategories
        ? IconButton(
            padding: const EdgeInsets.all(16),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.light,
            ),
            onPressed: drinks
                ? () {
                    setState(() {
                      drinks = false;
                    });
                  }
                : () {
                    setState(() {
                      drinkCategories = false;
                    });
                  },
          )
        : foodCategories
            ? IconButton(
                padding: const EdgeInsets.all(8),
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.light,
                ),
                onPressed: food
                    ? () {
                        setState(() {
                          food = false;
                        });
                      }
                    : () {
                        setState(() {
                          foodCategories = false;
                        });
                      },
              )
            : addInCategories
                ? IconButton(
                    padding: const EdgeInsets.all(8),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.light,
                    ),
                    onPressed: addIns
                        ? () {
                            setState(() {
                              addIns = false;
                            });
                          }
                        : () {
                            setState(() {
                              addInCategories = false;
                            });
                          },
                  )
                : Container();
  }

  _menuWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        drinkCategories = true;
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: AppColors.caramel,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset("images/coffee_cup.png",
                                height: 70, fit: BoxFit.cover),
                          ),
                          Text(
                            "Drinks",
                            style: TextStyles.kDefaultCreamTextStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        foodCategories = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.caramel,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset("images/egg.png",
                                height: 70, fit: BoxFit.cover),
                          ),
                          Text(
                            "Food",
                            style: TextStyles.kDefaultCreamTextStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                addInCategories = true;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  color: AppColors.tan,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      "images/add_ins.png",
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "Add Ins",
                    style: TextStyles.kDefaultCaramelTextStyle,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _drinkCategoryPanel(
      ScrollController scrollController, CoffeeShopState coffeeShopState) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Drink Categories",
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/menu/category', arguments: [
                    Category(Uuid().v4(), [], '', ''),
                    CategoryType.drink,
                    true
                  ]);
                },
                child: Row(
                  children: [
                    Text(
                      "Create Category",
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
                itemCount: coffeeShopState.coffeeShop.drinks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        drinks = true;
                        selectedCategory =
                            coffeeShopState.coffeeShop.drinks[index];
                      });
                    },
                    child: Container(
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
                              coffeeShopState.coffeeShop.drinks[index].title,
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
                                  Navigator.of(context)
                                      .pushNamed('/menu/category', arguments: [
                                    coffeeShopState.coffeeShop.drinks[index],
                                    CategoryType.drink,
                                    false
                                  ]);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppColors.caramel,
                                ),
                                onPressed: () {
                                  coffeeShopState.coffeeShop.drinks
                                      .removeAt(index);
                                  // coffeeShopState
                                  //   .update(coffeeShopState.coffeeShop);
                                  _menuBloc.add(RemoveCategory(
                                      coffeeShopState.coffeeShop));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  _drinkPanel(
      ScrollController scrollController, CoffeeShopState coffeeShopState) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedCategory.title,
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  var drink = await Navigator.of(context)
                      .pushNamed('/menu/category/item', arguments: [
                    CategoryType.drink,
                    selectedCategory,
                    Drink(
                        servedIced: false,
                        id: Uuid().v4(),
                        redeemableType: RedeemableType.none,
                        redeemableSize: SizeInOunces.none,
                        sizePriceMap: {"8 oz": '', '12 oz': '', '16 oz': ''}),
                    true,
                    false
                  ]);
                  if (drink != null) {
                    setState(() {
                      selectedCategory.items.add(drink);
                      _menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop));
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
                itemCount: selectedCategory.items.length,
                itemBuilder: (context, index) {
                  List<Drink> drinks = selectedCategory.items.cast<Drink>();
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
                                      selectedCategory,
                                      drinks[index],
                                      false,
                                      true
                                    ]);

                                if (drink != null) {
                                  setState(() {
                                    drinks.removeAt(index);
                                    drinks.insert(index, drink);
                                    selectedCategory.items = drinks;
                                    _menuBloc.add(
                                        UpdateMenu(coffeeShopState.coffeeShop));
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
                                selectedCategory.items.removeAt(index);

                                _menuBloc.add(
                                    UpdateMenu(coffeeShopState.coffeeShop));
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

  _foodPanel(
      ScrollController scrollController, CoffeeShopState coffeeShopState) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedCategory.title,
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  var foodItem = await Navigator.of(context)
                      .pushNamed('/menu/category/item', arguments: [
                    CategoryType.food,
                    selectedCategory,
                    Food(
                      id: Uuid().v4(),
                    ),
                    true,
                    false
                  ]);
                  if (foodItem != null) {
                    setState(() {
                      selectedCategory.items.add(foodItem);
                      _menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop));
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
                itemCount: selectedCategory.items.length,
                itemBuilder: (context, index) {
                  List<Food> food = selectedCategory.items.cast<Food>();
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
                                      selectedCategory,
                                      food[index],
                                      false,
                                      true
                                    ]);
                                if (foodItem != null) {
                                  setState(() {
                                    food.removeAt(index);
                                    food.insert(index, foodItem);
                                    selectedCategory.items = food;
                                    _menuBloc.add(
                                        UpdateMenu(coffeeShopState.coffeeShop));
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
                                selectedCategory.items.removeAt(index);

                                _menuBloc.add(
                                    UpdateMenu(coffeeShopState.coffeeShop));
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

  _addInsPanel(
      ScrollController scrollController, CoffeeShopState coffeeShopState) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedCategory.title,
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  var addIn = await Navigator.of(context)
                      .pushNamed('/menu/category/item', arguments: [
                    CategoryType.addIn,
                    selectedCategory,
                    AddIn(
                      id: Uuid().v4(),
                    ),
                    true,
                    false
                  ]);
                  if (addIn != null) {
                    setState(() {
                      selectedCategory.items.add(addIn);
                      _menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop));
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
                itemCount: selectedCategory.items.length,
                itemBuilder: (context, index) {
                  List<AddIn> addIns = selectedCategory.items.cast<AddIn>();
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
                                print("creating add in");
                                var addIn = await Navigator.of(context)
                                    .pushNamed('/menu/category/item',
                                        arguments: [
                                      CategoryType.addIn,
                                      selectedCategory,
                                      addIns[index],
                                      false,
                                      true
                                    ]);
                                if (addIn != null) {
                                  setState(() {
                                    addIns.removeAt(index);
                                    addIns.insert(index, addIn);
                                    selectedCategory.items = addIns;
                                    _menuBloc.add(
                                        UpdateMenu(coffeeShopState.coffeeShop));
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
                                selectedCategory.items.removeAt(index);

                                _menuBloc.add(
                                    UpdateMenu(coffeeShopState.coffeeShop));
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

  _foodCategoryPanel(
      ScrollController scrollController, CoffeeShopState coffeeShopState) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Food Categories",
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  Navigator.of(context).pushNamed('/menu/category', arguments: [
                    Category(Uuid().v4(), [], '', ''),
                    CategoryType.food,
                    true
                  ]);
                },
                child: Row(
                  children: [
                    Text(
                      "Create Category",
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
                itemCount: coffeeShopState.coffeeShop.food.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        food = true;
                        selectedCategory =
                            coffeeShopState.coffeeShop.food[index];
                      });
                    },
                    child: Container(
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
                              coffeeShopState.coffeeShop.food[index].title,
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
                                  Navigator.of(context)
                                      .pushNamed('/menu/category', arguments: [
                                    coffeeShopState.coffeeShop.food[index],
                                    CategoryType.food,
                                    false
                                  ]);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppColors.caramel,
                                ),
                                onPressed: () {
                                  coffeeShopState.coffeeShop.food
                                      .removeAt(index);

                                  _menuBloc.add(RemoveCategory(
                                      coffeeShopState.coffeeShop));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  _addInCategoryPanel(
      ScrollController scrollController, CoffeeShopState coffeeShopState) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Add In Categories",
              style: TextStyles.kDefaultCreamTextStyle,
            ),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  Navigator.of(context).pushNamed('/menu/category', arguments: [
                    Category(Uuid().v4(), [], '', ''),
                    CategoryType.addIn,
                    true
                  ]);
                },
                child: Row(
                  children: [
                    Text(
                      "Create Category",
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
                itemCount: coffeeShopState.coffeeShop.addIns.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        addIns = true;
                        selectedCategory =
                            coffeeShopState.coffeeShop.addIns[index];
                      });
                    },
                    child: Container(
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
                              coffeeShopState.coffeeShop.addIns[index].title,
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
                                  Navigator.of(context)
                                      .pushNamed('/menu/category', arguments: [
                                    coffeeShopState.coffeeShop.addIns[index],
                                    CategoryType.addIn,
                                    false
                                  ]);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppColors.caramel,
                                ),
                                onPressed: () {
                                  coffeeShopState.coffeeShop.addIns
                                      .removeAt(index);

                                  _menuBloc.add(RemoveCategory(
                                      coffeeShopState.coffeeShop));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  _mostOrderedItemsWidget() {
    return Expanded(
      child: DashboardCard(
        innerHorizontalPadding: 10,
        title: "Most Ordered Items",
        innerColor: AppColors.light,
        content: Container(
            alignment: Alignment.bottomCenter,
            height: 300,
            width: 300,
            child: PurchasedCoffeesVerticalBarLabelChart.withSampleData()),
      ),
    );
  }

  _editDiscountsWidget(CoffeeShopState coffeeShopState) {
    ScrollController _scrollController = ScrollController();
    return Expanded(
      child: DashboardCard(
        title: "Edit Discounts",
        content: ListView.builder(
            controller: _scrollController,
            itemCount: coffeeShopState.coffeeShop.discounts.length,
            itemBuilder: (context, index) {
              return _discountTile(coffeeShopState, index);
            }),
        innerColor: Colors.transparent,
      ),
    );
  }

  _currentDealsWidget(CoffeeShopState coffeeShopState) {
    ScrollController _scrollController = ScrollController();
    return Expanded(
      child: DashboardCard(
        title: "Edit Discounts",
        content: ListView.builder(
            controller: _scrollController,
            itemCount: coffeeShopState.coffeeShop.discounts.length,
            itemBuilder: (context, index) {
              if (!coffeeShopState.coffeeShop.discounts[index]['active']) {
                return Container();
              }
              return _discountTile(coffeeShopState, index);
            }),
        innerColor: Colors.transparent,
      ),
    );
  }

  _discountTile(CoffeeShopState coffeeShopState, int index) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadiusDirectional.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  coffeeShopState.coffeeShop.discounts[index]['title'],
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
                    onPressed: () async {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: AppColors.caramel,
                    ),
                    onPressed: () {
                      coffeeShopState.coffeeShop.discounts.removeAt(index);
                      //  coffeeShopState.update(coffeeShopState.coffeeShop);
                      _menuBloc.add(RemoveCategory(coffeeShopState.coffeeShop));
                    },
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              coffeeShopState.coffeeShop.discounts[index]['description'],
              style: TextStyles.kDefaultSmallDarkTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
