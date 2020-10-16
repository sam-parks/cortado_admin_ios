import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class CategoryListPage extends StatefulWidget {
  CategoryListPage({Key key, this.categoryType}) : super(key: key);
  final CategoryType categoryType;

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  MenuBloc _menuBloc;

  @override
  void initState() {
    super.initState();
    _menuBloc = BlocProvider.of<MenuBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.caramel,
        title: Text(
          _categoryTitleText(),
          style: TextStyle(
              color: AppColors.light,
              fontFamily: kFontFamilyNormal,
              fontSize: 40),
        ),
        actions: [_createCategory()],
      ),
      body: _categoryListBody(),
    );
  }

  Widget _categoryListBody() {
    CoffeeShop coffeeShop =
        BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop;
    switch (widget.categoryType) {
      case CategoryType.drink:
        return Center(child: _drinkList(coffeeShop.drinks));
        break;
      case CategoryType.food:
        return Center(child: _foodList(coffeeShop.food));
        break;
      case CategoryType.addIn:
        return Center(child: _addInList(coffeeShop.addIns));
        break;
      default:
        return Container();
    }
  }

  _categoryTitleText() {
    switch (widget.categoryType) {
      case CategoryType.drink:
        return "Drink Categories";
        break;
      case CategoryType.addIn:
        return "Add In Categories";
        break;
      case CategoryType.food:
        return "Food Categories";
        break;
    }
  }

  _createCategory() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/menu/category', arguments: [
            Category(Uuid().v4(), [], '', ''),
            widget.categoryType,
            true
          ]);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add_circle_outline,
                color: AppColors.cream,
                size: 40,
              ),
            ),
          ],
        ));
  }

  Widget _drinkList(List<Category> drinks) {
    ScrollController scrollController = ScrollController();
    CoffeeShop coffeeShop =
        BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop;
    return Container(
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * .7),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: coffeeShop.drinks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius:
                                BorderRadiusDirectional.circular(8.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                coffeeShop.drinks[index].title,
                                style: TextStyles.kDefaultLightTextStyle,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.light,
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pushNamed(
                                        '/menu/category',
                                        arguments: [
                                          coffeeShop.drinks[index],
                                          CategoryType.drink,
                                          false
                                        ]);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColors.light,
                                  ),
                                  onPressed: () {
                                    coffeeShop.drinks.removeAt(index);
                                    // coffeeShopState
                                    //   .update(coffeeShopState.coffeeShop);
                                    _menuBloc.add(RemoveCategory(coffeeShop));
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
      ),
    );
  }

  Widget _foodList(List<Category> food) {
    ScrollController scrollController = ScrollController();
    CoffeeShop coffeeShop =
        BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Food Categories",
              style: TextStyles.kDefaultLargeDarkTextStyle,
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
                itemCount: coffeeShop.food.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {});
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
                              coffeeShop.food[index].title,
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
                                    coffeeShop.food[index],
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
                                  coffeeShop.food.removeAt(index);

                                  _menuBloc.add(RemoveCategory(coffeeShop));
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

  Widget _addInList(List<Category> addIns) {
    ScrollController scrollController = ScrollController();
    CoffeeShop coffeeShop =
        BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Add In Categories",
              style: TextStyles.kDefaultLargeDarkTextStyle,
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
                itemCount: coffeeShop.addIns.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {});
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
                              coffeeShop.addIns[index].title,
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
                                    coffeeShop.addIns[index],
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
                                  coffeeShop.addIns.removeAt(index);

                                  _menuBloc.add(RemoveCategory(coffeeShop));
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
}
