import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/item/item_bloc.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tuple/tuple.dart';

class MenuItemPage extends StatefulWidget {
  MenuItemPage(
    this.editing,
    this.newCategory, {
    Key key,
    this.item,
    this.category,
    this.categoryType,
  }) : super(key: key);

  final Category category;
  final CategoryType categoryType;
  final bool editing;
  final Item item;
  final bool newCategory;

  @override
  _MenuItemPageState createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: close_sinks
  ItemBloc _itemBloc;
  List<Tuple2<SizeInOunces, TextEditingController>> regularSizesTuples;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _itemBloc = BlocProvider.of<ItemBloc>(context);
    if (widget.categoryType == CategoryType.drink)
      regularSizesTuples = _initSizesAndDrinkInfo();
  }

  _initSizesAndDrinkInfo() {
    List<SizeInOunces> regularSizes = [
      SizeInOunces.six,
      SizeInOunces.eight,
      SizeInOunces.twelve,
      SizeInOunces.sixteen,
      SizeInOunces.twenty,
      SizeInOunces.twentyFour
    ];

    nameController.text = widget.item.name;
    descriptionController.text = widget.item.description;

    return List.generate(regularSizes.length, (index) {
      return Tuple2(
          regularSizes[index],
          MoneyMaskedTextController(
            initialValue: double.parse(
                (widget.item as Drink).sizePriceMap[regularSizes[index]] ??
                    '0.00'),
            decimalSeparator: '.',
            thousandSeparator: ',',
          ));
    });
  }

  _drinkItemForm(CoffeeShopState coffeeShopState) {
    Drink drink = widget.item;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.caramel,
        ),
        backgroundColor: AppColors.light,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    keyboardType: TextInputType.text,
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
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
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
                Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(regularSizesTuples.length, (index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: AppColors.dark,
                              ),
                              child: Checkbox(
                                  activeColor: AppColors.dark,
                                  checkColor: AppColors.cream,
                                  value: drink.sizePriceMap.keys.contains(
                                      regularSizesTuples[index].item1),
                                  onChanged: (_) {
                                    setState(() {
                                      if (drink.sizePriceMap.keys.contains(
                                          regularSizesTuples[index].item1)) {
                                        drink.sizePriceMap.remove(
                                            regularSizesTuples[index].item1);
                                      } else {
                                        drink.sizePriceMap[
                                            regularSizesTuples[index]
                                                .item1] = '';
                                      }
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  regularSizesTuples[index]
                                      .item1
                                      .sizeToString(),
                                  style: TextStyle(
                                      color: AppColors.caramel,
                                      fontFamily: kFontFamilyNormal,
                                      fontSize: 24)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Visibility(
                            visible: drink.sizePriceMap.keys
                                .contains(regularSizesTuples[index].item1),
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
                                          controller:
                                              regularSizesTuples[index].item2,
                                          validator: (value) {
                                            if (drink.sizePriceMap.keys
                                                .contains(
                                                    regularSizesTuples[index]
                                                        .item1)) {
                                              return Validate.requiredField(
                                                  value, "Required field.");
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            drink.sizePriceMap[
                                                    regularSizesTuples[index]
                                                        .item1] =
                                                regularSizesTuples[index]
                                                    .item2
                                                    .text;
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
                        )
                      ],
                    );
                  }),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Available Add Ins",
                      style: TextStyles.kDefaultLargeDarkTextStyle),
                ),
                availableAddins(drink),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Required Add Ins",
                      style: TextStyles.kDefaultLargeDarkTextStyle),
                ),
                requiredAddIns(drink),
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
                                  Map<SizeInOunces, dynamic> icedMap = {};
                                  if (drink.sizePriceMap
                                      .containsKey(SizeInOunces.six))
                                    icedMap.addAll({
                                      SizeInOunces.sixIced:
                                          regularSizesTuples[0].item2.text
                                    });
                                  if (drink.sizePriceMap
                                      .containsKey(SizeInOunces.eight))
                                    icedMap.addAll({
                                      SizeInOunces.eightIced:
                                          regularSizesTuples[1].item2.text
                                    });
                                  if (drink.sizePriceMap
                                      .containsKey(SizeInOunces.twelve))
                                    icedMap.addAll({
                                      SizeInOunces.twelveIced:
                                          regularSizesTuples[2].item2.text
                                    });
                                  if (drink.sizePriceMap
                                      .containsKey(SizeInOunces.sixteen))
                                    icedMap.addAll({
                                      SizeInOunces.sixteenIced:
                                          regularSizesTuples[3].item2.text
                                    });
                                  if (drink.sizePriceMap
                                      .containsKey(SizeInOunces.twenty))
                                    icedMap.addAll({
                                      SizeInOunces.twentyIced:
                                          regularSizesTuples[4].item2.text
                                    });
                                  if (drink.sizePriceMap
                                      .containsKey(SizeInOunces.twentyFour))
                                    icedMap.addAll({
                                      SizeInOunces.twentyFourIced:
                                          regularSizesTuples[5].item2.text
                                    });

                                  drink.sizePriceMap.addAll(icedMap);
                                });
                              else
                                setState(() {
                                  drink.servedIced = false;
                                  drink.sizePriceMap
                                      .remove(SizeInOunces.sixIced);
                                  drink.sizePriceMap
                                      .remove(SizeInOunces.eightIced);
                                  drink.sizePriceMap
                                      .remove(SizeInOunces.twelveIced);
                                  drink.sizePriceMap
                                      .remove(SizeInOunces.sixteenIced);
                                  drink.sizePriceMap
                                      .remove(SizeInOunces.twentyIced);
                                  drink.sizePriceMap
                                      .remove(SizeInOunces.twentyFourIced);
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
                      Wrap(
                        children:
                            List.generate(regularSizesTuples.length, (index) {
                          return Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: AppColors.dark,
                                ),
                                child: Checkbox(
                                    activeColor: AppColors.dark,
                                    checkColor: AppColors.cream,
                                    value: drink.redeemableSize ==
                                        regularSizesTuples[index].item1,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value) {
                                          drink.redeemableSize =
                                              regularSizesTuples[index].item1;
                                        } else {
                                          drink.redeemableSize =
                                              SizeInOunces.none;
                                        }
                                      });
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    regularSizesTuples[index]
                                        .item1
                                        .sizeToString(),
                                    style: TextStyle(
                                        color: AppColors.caramel,
                                        fontFamily: kFontFamilyNormal,
                                        fontSize: 24)),
                              ),
                            ],
                          );
                        }),
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
          child: CortadoFatButton(
            text: widget.editing ? "Update Drink" : "Create Drink",
            textStyle: TextStyles.kDefaultLightTextStyle,
            backgroundColor: AppColors.caramel,
            width: 300,
            onTap: () => _updateAddItem(drink, coffeeShopState),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _foodItemForm(CoffeeShopState coffeeShopState) {
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
          padding: const EdgeInsets.symmetric(horizontal: 100),
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
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
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
          child: CortadoFatButton(
            text: widget.editing ? "Update Food Item" : "Create Food Item",
            textStyle: TextStyles.kDefaultLightTextStyle,
            backgroundColor: AppColors.caramel,
            width: 300,
            onTap: () => _updateAddItem(food, coffeeShopState),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _updateAddItem(Item item, CoffeeShopState coffeeShopState) {
    if (_formKey.currentState.validate()) {
      Menu menu = context.read<MenuBloc>().state.menu;
      String coffeeShopId = context.read<CoffeeShopBloc>().state.coffeeShop.id;
      if (widget.newCategory)
        Navigator.of(context).pop(item);
      else {
        if (widget.editing)
          _itemBloc.add(UpdateItem(widget.categoryType, widget.category.id,
              item, menu, coffeeShopId));
        else
          _itemBloc.add(AddItem(widget.categoryType, widget.category.id, item,
              menu, coffeeShopId));
      }
    }
  }

  requiredAddIns(Drink drink) {
    Menu menu = context.read<MenuBloc>().state.menu;
    List<Category> addIns = menu.addIns;
    return Container(
      height: 150,
      child: GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        childAspectRatio: 1 / 4,
        children: List.generate(addIns.length, (index) {
          Category addInCategory = addIns[index];
          return Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: AppColors.dark,
                ),
                child: Checkbox(
                    activeColor: AppColors.dark,
                    checkColor: AppColors.cream,
                    value: drink.requiredAddIns.contains(addInCategory.id),
                    onChanged: (_) {
                      setState(() {
                        if (drink.requiredAddIns.contains(addInCategory.id)) {
                          drink.requiredAddIns.remove(addInCategory.id);
                        } else {
                          drink.requiredAddIns.add(addInCategory.id);
                        }
                      });
                    }),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(addInCategory.title,
                      maxLines: 1,
                      minFontSize: 24,
                      style: TextStyle(
                          color: AppColors.caramel,
                          fontFamily: kFontFamilyNormal,
                          fontSize: 24)),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  availableAddins(Drink drink) {
    Menu menu = context.read<MenuBloc>().state.menu;
    List<Category> addIns = menu.addIns;
    return Container(
      height: 150,
      child: GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        childAspectRatio: 1 / 4,
        children: List.generate(addIns.length, (index) {
          Category addInCategory = addIns[index];

          return Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: AppColors.dark,
                ),
                child: Checkbox(
                    activeColor: AppColors.dark,
                    checkColor: AppColors.cream,
                    value: drink.availableAddIns.contains(addInCategory.id),
                    onChanged: (_) {
                      setState(() {
                        if (drink.availableAddIns.contains(addInCategory.id)) {
                          drink.availableAddIns.remove(addInCategory.id);
                        } else {
                          drink.availableAddIns.add(addInCategory.id);
                        }
                      });
                    }),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(addInCategory.title,
                      maxLines: 1,
                      minFontSize: 24,
                      style: TextStyle(
                          color: AppColors.caramel,
                          fontFamily: kFontFamilyNormal,
                          fontSize: 24)),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  _addInItemForm(CoffeeShopState coffeeShopState) {
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
          padding: const EdgeInsets.symmetric(horizontal: 100),
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
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
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
          child: CortadoFatButton(
            text: widget.editing ? "Update Add In" : "Create Add In",
            textStyle: TextStyles.kDefaultLightTextStyle,
            backgroundColor: AppColors.caramel,
            width: 300,
            onTap: () => _updateAddItem(addIn, coffeeShopState),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CoffeeShopState coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;

    return BlocConsumer(
        cubit: _itemBloc,
        listener: (context, ItemState state) {
          if (state is ItemAdded) Navigator.of(context).pop();
          if (state is ItemUpdated) Navigator.of(context).pop();
        },
        builder: (context, state) {
          switch (widget.categoryType) {
            case CategoryType.drink:
              return _drinkItemForm(coffeeShopState);
              break;
            case CategoryType.food:
              return _foodItemForm(coffeeShopState);
              break;
            case CategoryType.addIn:
              return _addInItemForm(coffeeShopState);
              break;
            default:
              return Container();
          }
        });
  }
}
