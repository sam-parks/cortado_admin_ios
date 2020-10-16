import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_button.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class MenuItemPage extends StatefulWidget {
  MenuItemPage({
    Key key,
    this.newCategory,
    this.item,
    this.category,
    this.categoryType,
    this.editing,
  }) : super(key: key);
  final CategoryType categoryType;
  final bool newCategory;
  final Item item;
  final Category category;
  final bool editing;

  @override
  _MenuItemPageState createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MenuBloc menuBloc = BlocProvider.of<MenuBloc>(context);
    CoffeeShopState coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;

    switch (widget.categoryType) {
      case CategoryType.drink:
        return _drinkItemForm(coffeeShopState, menuBloc);
        break;
      case CategoryType.food:
        return _foodItemForm(coffeeShopState, menuBloc);
        break;
      case CategoryType.addIn:
        return _addInItemForm(coffeeShopState, menuBloc);
        break;
      default:
        return Container();
    }
  }

  _drinkItemForm(CoffeeShopState coffeeShopState, MenuBloc menuBloc) {
    Drink drink = widget.item;

    if (drink?.servedIced == null) drink.servedIced = false;
    final smallPriceController = MoneyMaskedTextController(
      initialValue: 0.00,
      decimalSeparator: '.',
      thousandSeparator: ',',
    );

    final mediumPriceController = MoneyMaskedTextController(
      initialValue: 0.00,
      decimalSeparator: '.',
      thousandSeparator: ',',
    );
    final largePriceController = MoneyMaskedTextController(
      initialValue: 0.00,
      decimalSeparator: '.',
      thousandSeparator: ',',
    );
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    nameController.text = drink.name;
    descriptionController.text = drink.description;
    smallPriceController.text = drink.sizePriceMap['8 oz'];
    mediumPriceController.text = drink.sizePriceMap['12 oz'];
    largePriceController.text = drink.sizePriceMap['16 oz'];

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Drink Info",
                    style: TextStyles.kDefaultLargeDarkTextStyle,
                  ),
                ),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      return Validate.requiredField(value, "Required field.");
                    },
                    autofocus: true,
                    controller: nameController,
                    onChanged: (value) {
                      drink.name = value.trim();
                    },
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
                      labelText: "Name",
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
                  child: TextField(
                    maxLines: 6,
                    controller: descriptionController,
                    onChanged: (value) {
                      drink.description = value.trim();
                    },
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
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Sizes and Prices",
                      style: TextStyles.kDefaultLargeDarkTextStyle),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: [
                          Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: AppColors.dark,
                                ),
                                child: Checkbox(
                                    activeColor: AppColors.dark,
                                    checkColor: AppColors.cream,
                                    value: drink.sizePriceMap.keys
                                        .contains('8 oz'),
                                    onChanged: (_) {
                                      setState(() {
                                        if (drink.sizePriceMap.keys
                                            .contains('8 oz')) {
                                          drink.sizePriceMap.remove('8 oz');
                                        } else {
                                          Map<String, dynamic> map = {
                                            '8 oz': ''
                                          };
                                          drink.sizePriceMap.addAll(map);
                                        }
                                      });
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("8 oz",
                                    style: TextStyle(
                                        color: AppColors.caramel,
                                        fontFamily: kFontFamilyNormal,
                                        fontSize: 24)),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: drink.sizePriceMap.keys.contains('8 oz'),
                            child: Container(
                              width: 160,
                              child: Row(
                                children: [
                                  Text(
                                    "Price: \$ ",
                                    style: TextStyles.kDefaultCaramelTextStyle,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          controller: smallPriceController,
                                          validator: (value) {
                                            if (drink.sizePriceMap.keys
                                                .contains('8 oz')) {
                                              return Validate.requiredField(
                                                  value, "Required field.");
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            print(smallPriceController.text);
                                            drink.sizePriceMap['8 oz'] =
                                                smallPriceController.text;
                                          },
                                          style: TextStyle(
                                              color: AppColors.dark,
                                              fontFamily: kFontFamilyNormal,
                                              fontSize: 20)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: AppColors.dark,
                                ),
                                child: Checkbox(
                                    activeColor: AppColors.dark,
                                    checkColor: AppColors.cream,
                                    value: drink.sizePriceMap.keys
                                        .contains('12 oz'),
                                    onChanged: (_) {
                                      setState(() {
                                        if (drink.sizePriceMap.keys
                                            .contains('12 oz')) {
                                          drink.sizePriceMap.remove('12 oz');
                                        } else {
                                          Map<String, dynamic> map = {
                                            '12 oz': ''
                                          };
                                          drink.sizePriceMap.addAll(map);
                                        }
                                      });
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("12 oz",
                                    style: TextStyle(
                                        color: AppColors.caramel,
                                        fontFamily: kFontFamilyNormal,
                                        fontSize: 24)),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: drink.sizePriceMap.keys.contains('12 oz'),
                            child: Container(
                              width: 160,
                              child: Row(
                                children: [
                                  Text(
                                    "Price: \$ ",
                                    style: TextStyles.kDefaultCaramelTextStyle,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          controller: mediumPriceController,
                                          validator: (value) {
                                            if (drink.sizePriceMap.keys
                                                .contains('12 oz')) {
                                              return Validate.requiredField(
                                                  value, "Required field.");
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            drink.sizePriceMap['12 oz'] =
                                                mediumPriceController.text;
                                          },
                                          style: TextStyle(
                                              color: AppColors.dark,
                                              fontFamily: kFontFamilyNormal,
                                              fontSize: 20)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: AppColors.dark,
                                ),
                                child: Checkbox(
                                    activeColor: AppColors.dark,
                                    checkColor: AppColors.cream,
                                    value: drink.sizePriceMap.keys
                                        .contains('16 oz'),
                                    onChanged: (_) {
                                      setState(() {
                                        if (drink.sizePriceMap.keys
                                            .contains('16 oz')) {
                                          drink.sizePriceMap.remove('16 oz');
                                        } else {
                                          Map<String, dynamic> map = {
                                            '16 oz': ''
                                          };
                                          drink.sizePriceMap.addAll(map);
                                        }
                                      });
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("16 oz",
                                    style: TextStyle(
                                        color: AppColors.caramel,
                                        fontFamily: kFontFamilyNormal,
                                        fontSize: 24)),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: drink.sizePriceMap.keys.contains('16 oz'),
                            child: Container(
                              width: 160,
                              child: Row(
                                children: [
                                  Text(
                                    "Price: \$ ",
                                    style: TextStyles.kDefaultCaramelTextStyle,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          controller: largePriceController,
                                          validator: (value) {
                                            if (drink.sizePriceMap.keys
                                                .contains('16 oz')) {
                                              return Validate.requiredField(
                                                  value, "Required field.");
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            drink.sizePriceMap['16 oz'] =
                                                largePriceController.text;
                                          },
                                          style: TextStyle(
                                              color: AppColors.dark,
                                              fontFamily: kFontFamilyNormal,
                                              fontSize: 20)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Serve Iced?",
                      style: TextStyles.kDefaultLargeDarkTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: AppColors.dark,
                        ),
                        child: Checkbox(
                            activeColor: AppColors.dark,
                            checkColor: AppColors.cream,
                            value: drink.servedIced,
                            onChanged: (serveIced) {
                              if (serveIced)
                                setState(() {
                                  drink.servedIced = true;
                                  drink.sizePriceMap.addAll({
                                    '8 oz Iced': smallPriceController.text,
                                    '12 oz Iced': mediumPriceController.text,
                                    '16 oz Iced': largePriceController.text
                                  });
                                });
                              else
                                setState(() {
                                  drink.servedIced = false;
                                  drink.sizePriceMap.remove('8 oz Iced');
                                  drink.sizePriceMap.remove('12 oz Iced');
                                  drink.sizePriceMap.remove('16 oz Iced');
                                });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Yes",
                            style: TextStyle(
                                color: AppColors.caramel,
                                fontFamily: kFontFamilyNormal,
                                fontSize: 20)),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Redeemable",
                      style: TextStyles.kDefaultLargeDarkTextStyle),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: AppColors.dark,
                            ),
                            child: Checkbox(
                                activeColor: AppColors.dark,
                                checkColor: AppColors.cream,
                                value: drink.redeemableType ==
                                    RedeemableType.black,
                                onChanged: (blackRedeemable) {
                                  if (blackRedeemable)
                                    setState(() {
                                      drink.redeemableType =
                                          RedeemableType.black;
                                      drink.redeemableSize = SizeInOunces.eight;
                                    });
                                  else
                                    setState(() {
                                      drink.redeemableType =
                                          RedeemableType.none;
                                      drink.redeemableSize = SizeInOunces.none;
                                    });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Black",
                                style: TextStyle(
                                    color: AppColors.caramel,
                                    fontFamily: kFontFamilyNormal,
                                    fontSize: 20)),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: AppColors.dark,
                            ),
                            child: Checkbox(
                                activeColor: AppColors.dark,
                                checkColor: AppColors.cream,
                                value: drink.redeemableType ==
                                    RedeemableType.premium,
                                onChanged: (premiumRedeemable) {
                                  if (premiumRedeemable)
                                    setState(() {
                                      drink.redeemableType =
                                          RedeemableType.premium;
                                      drink.redeemableSize = SizeInOunces.eight;
                                    });
                                  else
                                    setState(() {
                                      drink.redeemableType =
                                          RedeemableType.none;
                                      drink.redeemableSize = SizeInOunces.none;
                                    });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text("Premium",
                                style: TextStyle(
                                    color: AppColors.caramel,
                                    fontFamily: kFontFamilyNormal,
                                    fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (drink.redeemableType != RedeemableType.none)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text("Redeemable Size",
                            style: TextStyles.kDefaultLargeDarkTextStyle),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: AppColors.dark,
                                ),
                                child: Checkbox(
                                    activeColor: AppColors.dark,
                                    checkColor: AppColors.cream,
                                    value: drink.redeemableSize ==
                                        SizeInOunces.eight,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value) {
                                          drink.redeemableSize =
                                              SizeInOunces.eight;
                                        } else {
                                          drink.redeemableSize =
                                              SizeInOunces.none;
                                        }
                                      });
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("8 oz",
                                    style: TextStyle(
                                        color: AppColors.caramel,
                                        fontFamily: kFontFamilyNormal,
                                        fontSize: 24)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: AppColors.dark,
                                ),
                                child: Checkbox(
                                    activeColor: AppColors.dark,
                                    checkColor: AppColors.cream,
                                    value: drink.redeemableSize ==
                                        SizeInOunces.twelve,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value) {
                                          drink.redeemableSize =
                                              SizeInOunces.twelve;
                                        } else {
                                          drink.redeemableSize =
                                              SizeInOunces.none;
                                        }
                                      });
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("12 oz",
                                    style: TextStyle(
                                        color: AppColors.caramel,
                                        fontFamily: kFontFamilyNormal,
                                        fontSize: 24)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: AppColors.dark,
                                ),
                                child: Checkbox(
                                    activeColor: AppColors.dark,
                                    checkColor: AppColors.cream,
                                    value: drink.redeemableSize ==
                                        SizeInOunces.sixteen,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value) {
                                          drink.redeemableSize =
                                              SizeInOunces.sixteen;
                                        } else {
                                          drink.redeemableSize =
                                              SizeInOunces.none;
                                        }
                                      });
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("16 oz",
                                    style: TextStyle(
                                        color: AppColors.caramel,
                                        fontFamily: kFontFamilyNormal,
                                        fontSize: 24)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 200),
                    ],
                  ),
                SizedBox(
                  height: 200,
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(30),
          child: CortadoButton(
            text: widget.editing ? "Update Drink" : "Create Drink",
            textStyle: TextStyles.kLargeCaramelTextStyle,
            color: AppColors.caramel,
            onTap: () {
              if (_formKey.currentState.validate()) {
                Navigator.of(context).pop(drink);
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _foodItemForm(CoffeeShopState coffeeShopState, MenuBloc menuBloc) {
    final priceController = MoneyMaskedTextController(
      initialValue: 0.00,
      decimalSeparator: '.',
      thousandSeparator: ',',
    );

    TextEditingController nameController = TextEditingController();

    TextEditingController descriptionController = TextEditingController();
    Food food = widget.item;

    nameController.text = food.name;
    descriptionController.text = food.description;
    priceController.text = food.price;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Food Item Info",
                  style: TextStyles.kDefaultLargeDarkTextStyle,
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (value) {
                    return Validate.requiredField(value, "Required field.");
                  },
                  autofocus: true,
                  controller: nameController,
                  onChanged: (value) {
                    food.name = value.trim();
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    letterSpacing: .75,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    labelText: "Name",
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
                child: TextField(
                  maxLines: 6,
                  controller: descriptionController,
                  onChanged: (value) {
                    food.description = value.trim();
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    letterSpacing: .75,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
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
              SizedBox(height: 5),
              Container(
                child: TextFormField(
                  validator: (value) {
                    return Validate.requiredField(value, "Required field.");
                  },
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  controller: priceController,
                  onChanged: (value) {
                    food.price = priceController.text;
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    letterSpacing: .75,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    labelText: "Price",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(30),
          child: CortadoButton(
            text: widget.editing ? "Update Food Item" : "Create Food Item",
            textStyle: TextStyles.kLargeCaramelTextStyle,
            color: AppColors.caramel,
            onTap: () {
              if (_formKey.currentState.validate()) {
                Navigator.of(context).pop(food);
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _addInItemForm(CoffeeShopState coffeeShopState, MenuBloc menuBloc) {
    final priceController = MoneyMaskedTextController(
      initialValue: 0.00,
      decimalSeparator: '.',
      thousandSeparator: ',',
    );
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    AddIn addIn = widget.item;

    nameController.text = addIn.name;
    descriptionController.text = addIn.description;
    priceController.text = addIn.price;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Add In Info",
                  style: TextStyles.kDefaultLargeDarkTextStyle,
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (value) {
                    return Validate.requiredField(value, "Required field.");
                  },
                  autofocus: true,
                  controller: nameController,
                  onChanged: (value) {
                    addIn.name = value.trim();
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    letterSpacing: .75,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    labelText: "Name",
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
                child: TextField(
                  maxLines: 6,
                  controller: descriptionController,
                  onChanged: (value) {
                    addIn.description = value.trim();
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    letterSpacing: .75,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
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
              SizedBox(height: 5),
              Container(
                child: TextFormField(
                  validator: (value) {
                    return Validate.requiredField(value, "Required field.");
                  },
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  controller: priceController,
                  onChanged: (value) {
                    addIn.price = priceController.text;
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    letterSpacing: .75,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark, width: 2.0),
                    ),
                    labelText: "Price",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(30),
          child: CortadoButton(
            text: widget.editing ? "Update Add In" : "Create Add In",
            textStyle: TextStyles.kLargeCaramelTextStyle,
            color: AppColors.caramel,
            onTap: () {
              if (_formKey.currentState.validate()) {
                Navigator.of(context).pop(addIn);
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
