import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/category/category_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/ui/router.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  CoffeeShopBloc _coffeeShopBloc;

  @override
  void initState() {
    super.initState();
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
    _coffeeShopBloc = BlocProvider.of<CoffeeShopBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _coffeeShopBloc,
      builder: (BuildContext context, CoffeeShopState state) {
        return Scaffold(
          backgroundColor: AppColors.light,
          appBar: AppBar(
            backgroundColor: AppColors.caramel,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.cream,
                size: 40,
              ),
            ),
            title: Text(
              _categoryTitleText(),
              style: TextStyle(
                  color: AppColors.light,
                  fontFamily: kFontFamilyNormal,
                  fontSize: 40),
            ),
            actions: [_createCategory()],
          ),
          body: _categoryListBody(state.coffeeShop),
        );
      },
    );
  }

  Widget _categoryListBody(CoffeeShop coffeeShop) {
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
          Navigator.of(context).pushNamed(kCategoryRoute, arguments: [
            false,
            true,
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
    drinks.sort((a, b) => a.id.compareTo(b.id));

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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius:
                                BorderRadiusDirectional.circular(8.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(kCategoryRoute, arguments: [
                              false,
                              false,
                              drinks[index],
                              CategoryType.drink,
                            ]);
                          },
                          child: ListTile(
                            trailing: Container(
                              width: 130,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColors.cream,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            kCategoryRoute,
                                            arguments: [
                                              true,
                                              false,
                                              drinks[index],
                                              CategoryType.drink,
                                            ]);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColors.cream,
                                      ),
                                      onPressed: () {
                                        _categoryBloc.add(RemoveCategory(
                                            CategoryType.drink,
                                            drinks[index],
                                            _coffeeShopBloc.state.coffeeShop));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SvgPicture.asset(
                                'images/coffee_bean.svg',
                                color: AppColors.cream,
                                height: 25,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  drinks[index].description,
                                  style: TextStyles.kDefaultSmallLightTextStyle,
                                ),
                              ],
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  drinks[index].title,
                                  style: TextStyles.kDefaultLightTextStyle,
                                ),
                              ],
                            ),
                          ),
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
    food.sort((a, b) => a.id.compareTo(b.id));

    return Container(
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * .7),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: food.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius:
                                BorderRadiusDirectional.circular(8.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(kCategoryRoute, arguments: [
                              false,
                              false,
                              food[index],
                              CategoryType.food,
                            ]);
                          },
                          child: ListTile(
                            trailing: Container(
                              width: 130,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColors.cream,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            kCategoryRoute,
                                            arguments: [
                                              true,
                                              false,
                                              food[index],
                                              CategoryType.food,
                                            ]);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColors.cream,
                                      ),
                                      onPressed: () {
                                        _categoryBloc.add(RemoveCategory(
                                            CategoryType.food,
                                            food[index],
                                            _coffeeShopBloc.state.coffeeShop));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SvgPicture.asset(
                                'images/coffee_bean.svg',
                                color: AppColors.cream,
                                height: 25,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  food[index].description,
                                  style: TextStyles.kDefaultSmallLightTextStyle,
                                ),
                              ],
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  food[index].title,
                                  style: TextStyles.kDefaultLightTextStyle,
                                ),
                              ],
                            ),
                          ),
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

  Widget _addInList(List<Category> addIns) {
    ScrollController scrollController = ScrollController();
    addIns.sort((a, b) => a.id.compareTo(b.id));

    return Container(
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * .7),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: addIns.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius:
                                BorderRadiusDirectional.circular(8.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(kCategoryRoute, arguments: [
                              false,
                              false,
                              addIns[index],
                              CategoryType.addIn,
                            ]);
                          },
                          child: ListTile(
                            trailing: Container(
                              width: 130,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColors.cream,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            kCategoryRoute,
                                            arguments: [
                                              true,
                                              false,
                                              addIns[index],
                                              CategoryType.addIn,
                                            ]);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColors.cream,
                                      ),
                                      onPressed: () {
                                        _categoryBloc.add(RemoveCategory(
                                            CategoryType.addIn,
                                            addIns[index],
                                            _coffeeShopBloc.state.coffeeShop));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SvgPicture.asset(
                                'images/coffee_bean.svg',
                                color: AppColors.cream,
                                height: 25,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  addIns[index].description,
                                  style: TextStyles.kDefaultSmallLightTextStyle,
                                ),
                              ],
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  addIns[index].title,
                                  style: TextStyles.kDefaultLightTextStyle,
                                ),
                              ],
                            ),
                          ),
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
}
