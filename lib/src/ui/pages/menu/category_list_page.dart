import 'package:cortado_admin_ios/src/bloc/menu/category/category_bloc.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
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
  CategoryBloc _categoryBloc;
  // ignore: close_sinks
  MenuBloc _menuBloc;

  @override
  void initState() {
    super.initState();
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
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
    switch (widget.categoryType) {
      case CategoryType.drink:
        return Center(child: _drinkList(_menuBloc.state.coffeeShop.drinks));
        break;
      case CategoryType.food:
        return Center(child: _foodList(_menuBloc.state.coffeeShop.food));
        break;
      case CategoryType.addIn:
        return Center(child: _addInList(_menuBloc.state.coffeeShop.addIns));
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
            widget.categoryType
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

    return Container(
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * .7),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: drinks.length,
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
                                drinks[index].title,
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
                                          drinks[index],
                                          CategoryType.drink,
                                        ]);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColors.light,
                                  ),
                                  onPressed: () {
                                    _categoryBloc.add(RemoveCategory(
                                        CategoryType.drink,
                                        drinks[index],
                                        _menuBloc.state.coffeeShop));
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
                itemCount: food.length,
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
                              food[index].title,
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
                                    food[index],
                                    CategoryType.food
                                  ]);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppColors.caramel,
                                ),
                                onPressed: () {
                                  _categoryBloc.add(
                                    RemoveCategory(
                                        CategoryType.food,
                                        food[index],
                                        _menuBloc.state.coffeeShop),
                                  );
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
                    CategoryType.addIn
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
                itemCount: addIns.length,
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
                              addIns[index].title,
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
                                    addIns[index],
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
                                  _categoryBloc.add(RemoveCategory(
                                      CategoryType.addIn,
                                      addIns[index],
                                      _menuBloc.state.coffeeShop));
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
