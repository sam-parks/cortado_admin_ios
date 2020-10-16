import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_button.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class MenuCategoryPage extends StatefulWidget {
  MenuCategoryPage(
      {Key key, this.categoryType, this.category, this.newCategory})
      : super(key: key);
  final CategoryType categoryType;
  final Category category;
  final bool newCategory;

  @override
  _MenuCategoryPageState createState() => _MenuCategoryPageState();
}

class _MenuCategoryPageState extends State<MenuCategoryPage> {
  ScrollController _scrollController = ScrollController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MenuBloc menuBloc = BlocProvider.of<MenuBloc>(context);
    // ignore: close_sinks
    CoffeeShopBloc coffeeShopBloc = BlocProvider.of<CoffeeShopBloc>(context);
    CoffeeShopState coffeeShopState = coffeeShopBloc.state;
    switch (widget.categoryType) {
      case CategoryType.drink:
        return _drinkForm(coffeeShopState, menuBloc);
        break;
      case CategoryType.food:
        return _foodform(coffeeShopState, menuBloc);
        break;
      case CategoryType.addIn:
        return _addInForm(coffeeShopState, menuBloc);
        break;
      default:
        return Container();
    }
  }

  _addInForm(CoffeeShopState coffeeShopState, MenuBloc menuBloc) {
    List<AddIn> addIns = List.castFrom<Item, AddIn>(widget.category.items);
    TextEditingController titleController =
        TextEditingController(text: widget.category.title);
    TextEditingController descriptionController =
        TextEditingController(text: widget.category.description);
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.caramel,
          ),
          backgroundColor: AppColors.light,
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Category Info",
                    style: TextStyles.kDefaultLargeDarkTextStyle,
                  ),
                ),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      return Validate.requiredField(value, "Required field");
                    },
                    autofocus: true,
                    controller: titleController,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      labelText: "Title",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.caramel,
                        fontFamily: kFontFamilyNormal,
                        letterSpacing: .75,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  child: TextFormField(
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    controller: descriptionController,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      labelText: "Description",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.caramel,
                        fontFamily: kFontFamilyNormal,
                        letterSpacing: .75,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "Add Ins",
                              style: TextStyles.kDefaultLargeDarkTextStyle,
                            ),
                          ),
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
                                widget.newCategory,
                                false
                              ]);
                              if (addIn != null) {
                                setState(() {
                                  addIns.add(addIn);
                                });
                              }
                            },
                            child: Icon(
                              Icons.add_box,
                              color: AppColors.dark,
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.screenHeight * .4,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                        controller: _scrollController,
                        itemCount: addIns.length,
                        itemBuilder: (context, index) {
                          if (addIns[index].name == null) {
                            return Container();
                          }
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: AppColors.dark,
                            ),
                            height: 50,
                            width: 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: AppColors.light,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            addIns.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: AppColors.light,
                                        ),
                                        onPressed: () async {
                                          var addIn =
                                              await Navigator.of(context)
                                                  .pushNamed(
                                                      '/menu/category/item',
                                                      arguments: [
                                                CategoryType.addIn,
                                                widget.category,
                                                addIns[index],
                                                widget.newCategory,
                                                true
                                              ]);
                                          if (addIn != null) {
                                            setState(() {
                                              addIns.removeAt(index);
                                              addIns.insert(index, addIn);
                                            });
                                          }
                                          menuBloc.add(UpdateMenu(
                                              coffeeShopState.coffeeShop));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    addIns[index].name,
                                    style: TextStyles.kDefaultLightTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: !widget.newCategory
              ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoButton(
                    text: "Finish Editing",
                    textStyle: TextStyles.kLargeCaramelTextStyle,
                    color: AppColors.caramel,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        String id = widget.category.id;
                        Category category =
                            Category(id, addIns, title, description);

                        /* coffeeShopState.coffeeShop.addIns
                            .removeWhere((category) => category.id == id);
                        coffeeShopState.coffeeShop.addIns.add(category);

                        coffeeShopBloc.add(UpdateCoffeeShop(coffeeShop));
                        coffeeShopState.update(coffeeShopState.coffeeShop);
                        menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop)); */

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoButton(
                    text: "Create Category",
                    textStyle: TextStyles.kLargeCaramelTextStyle,
                    color: AppColors.caramel,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        Category category =
                            Category(Uuid().v4(), addIns, title, description);

                        coffeeShopState.coffeeShop.addIns.add(category);
                        //coffeeShopState.update(coffeeShopState.coffeeShop);
                        menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop));

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  _foodform(CoffeeShopState coffeeShopState, MenuBloc menuBloc) {
    List<Food> food = List.castFrom<Item, Food>(widget.category.items);
    TextEditingController titleController =
        TextEditingController(text: widget.category.title);
    TextEditingController descriptionController =
        TextEditingController(text: widget.category.description);
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.caramel,
          ),
          backgroundColor: AppColors.light,
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Category Info",
                    style: TextStyles.kDefaultLargeDarkTextStyle,
                  ),
                ),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      return Validate.requiredField(value, "Required field");
                    },
                    autofocus: true,
                    controller: titleController,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      labelText: "Title",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.caramel,
                        fontFamily: kFontFamilyNormal,
                        letterSpacing: .75,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  child: TextFormField(
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    controller: descriptionController,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      labelText: "Description",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.caramel,
                        fontFamily: kFontFamilyNormal,
                        letterSpacing: .75,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "Food Items",
                              style: TextStyles.kDefaultLargeDarkTextStyle,
                            ),
                          ),
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
                                widget.newCategory,
                                false
                              ]);

                              if (foodItem != null) {
                                setState(() {
                                  food.add(foodItem);
                                });
                              }
                            },
                            child: Icon(
                              Icons.add_box,
                              color: AppColors.dark,
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.screenHeight * .4,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5),
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      itemCount: food.length,
                      itemBuilder: (context, index) {
                        if (food[index].name == null) {
                          return Container();
                        }
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.dark,
                          ),
                          height: 50,
                          width: 170,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: AppColors.light,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          food.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColors.light,
                                      ),
                                      onPressed: () async {
                                        var foodItem =
                                            await Navigator.of(context)
                                                .pushNamed(
                                                    '/menu/category/item',
                                                    arguments: [
                                              CategoryType.food,
                                              widget.category,
                                              food[index],
                                              widget.newCategory,
                                              true
                                            ]);
                                        print(foodItem);
                                        if (foodItem != null) {
                                          setState(() {
                                            food.removeAt(index);
                                            food.insert(index, foodItem);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  food[index].name,
                                  style: TextStyles.kDefaultLightTextStyle,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: !widget.newCategory
              ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoButton(
                    text: "Finish Editing",
                    textStyle: TextStyles.kLargeCaramelTextStyle,
                    color: AppColors.caramel,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        String id = widget.category.id;
                        Category category =
                            Category(id, food, title, description);

                        coffeeShopState.coffeeShop.food
                            .removeWhere((category) => category.id == id);
                        coffeeShopState.coffeeShop.food.add(category);

                        //coffeeShopState.update(coffeeShopState.coffeeShop);
                        menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop));

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoButton(
                    text: "Create Category",
                    textStyle: TextStyles.kLargeCaramelTextStyle,
                    color: AppColors.caramel,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        Category category =
                            Category(Uuid().v4(), food, title, description);

                        coffeeShopState.coffeeShop.food.add(category);
                        //coffeeShopState.update(coffeeShopState.coffeeShop);
                        menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop));

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  _drinkForm(CoffeeShopState coffeeShopState, MenuBloc menuBloc) {
    List<Drink> drinks = List.castFrom<Item, Drink>(widget.category.items);
    TextEditingController titleController =
        TextEditingController(text: widget.category.title);
    TextEditingController descriptionController =
        TextEditingController(text: widget.category.description);
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.caramel,
          ),
          backgroundColor: AppColors.light,
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Category Info",
                    style: TextStyles.kDefaultLargeDarkTextStyle,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: TextFormField(
                    validator: (value) {
                      return Validate.requiredField(value, "Required field");
                    },
                    autofocus: true,
                    controller: titleController,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      labelText: "Title",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.caramel,
                        fontFamily: kFontFamilyNormal,
                        letterSpacing: .75,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: TextFormField(
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    controller: descriptionController,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.dark, width: 2.0),
                      ),
                      labelText: "Description",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.caramel,
                        fontFamily: kFontFamilyNormal,
                        letterSpacing: .75,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Drinks",
                            style: TextStyles.kDefaultLargeDarkTextStyle,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () async {
                              var drink = await Navigator.of(context)
                                  .pushNamed('/menu/category/item', arguments: [
                                CategoryType.drink,
                                widget.category,
                                Drink(
                                    id: Uuid().v4(),
                                    redeemableType: RedeemableType.none,
                                    redeemableSize: SizeInOunces.none,
                                    servedIced: false,
                                    sizePriceMap: {
                                      "8 oz": '',
                                      '12 oz': '',
                                      '16 oz': ''
                                    }),
                                widget.newCategory,
                                false
                              ]);
                              if (drink != null) {
                                setState(() {
                                  drinks.add(drink);
                                });
                              }
                            },
                            child: Icon(
                              Icons.add_box,
                              color: AppColors.dark,
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Scrollbar(
                      controller: _scrollController,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5),
                          scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          itemCount: drinks.length,
                          itemBuilder: (context, index) {
                            if (drinks[index].name == null) {
                              return Container();
                            }
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColors.dark,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: AppColors.light,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              drinks.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: AppColors.light,
                                          ),
                                          onPressed: () async {
                                            var drink =
                                                await Navigator.of(context)
                                                    .pushNamed(
                                                        '/menu/category/item',
                                                        arguments: [
                                                  CategoryType.drink,
                                                  widget.category,
                                                  drinks[index],
                                                  widget.newCategory,
                                                  true
                                                ]);
                                            if (drink != null) {
                                              setState(() {
                                                drinks.removeAt(index);
                                                drinks.insert(index, drink);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      drinks[index].name,
                                      style: TextStyles.kDefaultLightTextStyle,
                                    ),
                                  ),
                                  Spacer(),
                                  if (drinks[index].redeemableType !=
                                      RedeemableType.none)
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'images/coffee_bean.png',
                                          color: AppColors.cream,
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: !widget.newCategory
              ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoButton(
                    text: "Finish Editing",
                    textStyle: TextStyles.kLargeCaramelTextStyle,
                    color: AppColors.caramel,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        String id = widget.category.id;
                        Category category =
                            Category(id, drinks, title, description);

                        coffeeShopState.coffeeShop.drinks
                            .removeWhere((category) => category.id == id);
                        coffeeShopState.coffeeShop.drinks.add(category);

                        //coffeeShopState.update(coffeeShopState.coffeeShop);
                        menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop));

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoButton(
                    text: "Create Category",
                    textStyle: TextStyles.kLargeCaramelTextStyle,
                    color: AppColors.caramel,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        Category category =
                            Category(Uuid().v4(), drinks, title, description);

                        coffeeShopState.coffeeShop.drinks.add(category);
                        // coffeeShopState.update(coffeeShopState.coffeeShop);
                        menuBloc.add(UpdateMenu(coffeeShopState.coffeeShop));

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }
}

enum CategoryType { drink, food, addIn }
