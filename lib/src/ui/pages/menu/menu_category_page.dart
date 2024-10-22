import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/category/category_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/item/item_bloc.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:cortado_admin_ios/src/ui/router.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class MenuCategoryPage extends StatefulWidget {
  MenuCategoryPage(
    this.editing,
    this.newCategory, {
    Key key,
    this.categoryType,
    this.category,
  }) : super(key: key);
  final CategoryType categoryType;
  final Category category;
  final bool editing;
  final bool newCategory;

  @override
  _MenuCategoryPageState createState() => _MenuCategoryPageState();
}

class _MenuCategoryPageState extends State<MenuCategoryPage> {
  ScrollController _scrollController = ScrollController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool editing;
  bool newCategory;

  TextEditingController titleController;
  TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    if (widget.category.id == null) widget.category.id = Uuid().v4();

    editing = widget.editing;
    newCategory = widget.newCategory;

    titleController = TextEditingController(text: widget.category.title);
    descriptionController =
        TextEditingController(text: widget.category.description);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(builder: (context, menuState) {
      return BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryAdded || state is CategoryUpdated) {
            Navigator.of(context).pop();
          }
        },
        builder: (BuildContext context, CategoryState state) {
          switch (widget.categoryType) {
            case CategoryType.drink:
              return _drinkForm(menuState.menu);
              break;
            case CategoryType.food:
              return _foodform(menuState.menu);
              break;
            case CategoryType.addIn:
              return _addInForm(menuState.menu);
              break;
            default:
              return Container();
          }
        },
      );
    });
  }

  _addInForm(Menu menu) {
    List<AddIn> addIns;
    if (widget.newCategory) {
      addIns = List.castFrom<ItemTemplate, AddIn>(widget.category.items);
    } else {
      Category category = menu.addIns
          .firstWhere((category) => category.id == widget.category.id);
      addIns = List.castFrom<ItemTemplate, AddIn>(category.items);
    }

    addIns.sort((a, b) => a.id.compareTo(b.id));

    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.caramel,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.cream,
                size: 40,
              ),
            ),
            title: Text(
              widget.category.title,
              style: TextStyle(
                  color: AppColors.light,
                  fontFamily: kFontFamilyNormal,
                  fontSize: 40),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.cream,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      editing = !editing;
                    });
                  },
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.light,
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.only(left: 100, right: 100, top: 20),
                  child: TextFormField(
                    validator: (value) {
                      return Validate.requiredField(value, "Required field");
                    },
                    autofocus: true,
                    controller: titleController,
                    enabled: editing || newCategory,
                    onChanged: (value) {},
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
                      disabledBorder: OutlineInputBorder(
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
                    enabled: editing || newCategory,
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
                      disabledBorder: OutlineInputBorder(
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
                            "Add Ins",
                            style: TextStyles.kDefaultLargeDarkTextStyle,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () async {
                              var addIn = await Navigator.of(context)
                                  .pushNamed(kItemRoute, arguments: [
                                false,
                                widget.newCategory,
                                CategoryType.addIn,
                                widget.category,
                                AddIn(
                                  id: Uuid().v4(),
                                ),
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
                Expanded(
                  child: Container(
                    height: SizeConfig.screenHeight * .4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 90,
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        scrollDirection: Axis.vertical,
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
                                          color: AppColors.cream,
                                        ),
                                        onPressed: () {
                                          Menu menu = context
                                              .read<MenuBloc>()
                                              .state
                                              .menu;
                                          String coffeeShopId = context
                                              .read<CoffeeShopBloc>()
                                              .state
                                              .coffeeShop
                                              .id;
                                          context.read<ItemBloc>().add(
                                              RemoveItem(
                                                  widget.categoryType,
                                                  widget.category.id,
                                                  addIns[index],
                                                  menu,
                                                  coffeeShopId));
                                        },
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: AppColors.cream,
                                        ),
                                        onPressed: () async {
                                          var addIn =
                                              await Navigator.of(context)
                                                  .pushNamed(kItemRoute,
                                                      arguments: [
                                                true,
                                                false,
                                                CategoryType.addIn,
                                                widget.category,
                                                addIns[index],
                                              ]);

                                          Menu menu = context
                                              .read<MenuBloc>()
                                              .state
                                              .menu;
                                          String coffeeShopId = context
                                              .read<CoffeeShopBloc>()
                                              .state
                                              .coffeeShop
                                              .id;

                                          if (addIn != null) {
                                            context.read<ItemBloc>().add(
                                                UpdateItem(
                                                    widget.categoryType,
                                                    widget.category.id,
                                                    addIn,
                                                    menu,
                                                    coffeeShopId));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8.0),
                                        child: AutoSizeText(
                                          addIns[index].name,
                                          maxLines: 2,
                                          style:
                                              TextStyles.kDefaultLightTextStyle,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(
                                        '\$ ' + (addIns[index].price ?? "0.00"),
                                        style:
                                            TextStyles.kDefaultLightTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    addIns[index].description ?? '',
                                    style: TextStyles.kDefaultLightTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: editing
              ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoFatButton(
                    text: "Finish Editing",
                    textStyle: TextStyles.kDefaultLightTextStyle,
                    backgroundColor: AppColors.caramel,
                    width: 300,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        String id = widget.category.id;
                        Category category =
                            Category(id, addIns, title, description);
                        Menu menu = context.read<MenuBloc>().state.menu;
                        String coffeeShopId =
                            context.read<CoffeeShopBloc>().state.coffeeShop.id;
                        context.read<CategoryBloc>().add(UpdateCategory(
                            CategoryType.addIn, category, menu, coffeeShopId));
                      }
                    },
                  ),
                )
              : newCategory
                  ? Padding(
                      padding: const EdgeInsets.all(30),
                      child: CortadoFatButton(
                        text: "Create Category",
                        width: 300,
                        textStyle: TextStyles.kDefaultLightTextStyle,
                        backgroundColor: AppColors.caramel,
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            String title = titleController.text;
                            String description = descriptionController.text;
                            Category category = Category(
                                Uuid().v4(), addIns, title, description);

                            Menu menu = context.read<MenuBloc>().state.menu;
                            String coffeeShopId = context
                                .read<CoffeeShopBloc>()
                                .state
                                .coffeeShop
                                .id;

                            context.read<CategoryBloc>().add(AddCategory(
                                CategoryType.addIn,
                                category,
                                menu,
                                coffeeShopId));
                          }
                        },
                      ),
                    )
                  : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  _foodform(Menu menu) {
    List<FoodTemplate> food;
    if (widget.newCategory) {
      food = List.castFrom<ItemTemplate, FoodTemplate>(widget.category.items);
    } else {
      Category category = menu.foodTemplates
          .firstWhere((category) => category.id == widget.category.id);
      food = List.castFrom<ItemTemplate, FoodTemplate>(category.items);
    }

    food.sort((a, b) => a.id.compareTo(b.id));
    return Form(
        key: _formKey,
        child: Scaffold(
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
              widget.category.title,
              style: TextStyle(
                  color: AppColors.light,
                  fontFamily: kFontFamilyNormal,
                  fontSize: 40),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.cream,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      editing = !editing;
                    });
                  },
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.light,
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.only(left: 100, right: 100, top: 20),
                  child: TextFormField(
                    validator: (value) {
                      return Validate.requiredField(value, "Required field");
                    },
                    autofocus: true,
                    controller: titleController,
                    enabled: editing || newCategory,
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
                      disabledBorder: OutlineInputBorder(
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
                    enabled: editing || newCategory,
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
                      disabledBorder: OutlineInputBorder(
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
                            "Food Items",
                            style: TextStyles.kDefaultLargeDarkTextStyle,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () async {
                              var foodItem = await Navigator.of(context)
                                  .pushNamed(kItemRoute, arguments: [
                                false,
                                widget.newCategory,
                                CategoryType.food,
                                widget.category,
                                FoodTemplate(
                                  id: Uuid().v4(),
                                ),
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
                Expanded(
                  child: Container(
                    height: SizeConfig.screenHeight * .4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 90,
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
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
                                          color: AppColors.cream,
                                        ),
                                        onPressed: () {
                                          Menu menu = context
                                              .read<MenuBloc>()
                                              .state
                                              .menu;
                                          String coffeeShopId = context
                                              .read<CoffeeShopBloc>()
                                              .state
                                              .coffeeShop
                                              .id;
                                          context.read<ItemBloc>().add(
                                              RemoveItem(
                                                  widget.categoryType,
                                                  widget.category.id,
                                                  food[index],
                                                  menu,
                                                  coffeeShopId));
                                        },
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: AppColors.cream,
                                        ),
                                        onPressed: () async {
                                          var foodItem =
                                              await Navigator.of(context)
                                                  .pushNamed(kItemRoute,
                                                      arguments: [
                                                true,
                                                false,
                                                CategoryType.food,
                                                widget.category,
                                                food[index],
                                              ]);

                                          Menu menu = context
                                              .read<MenuBloc>()
                                              .state
                                              .menu;
                                          String coffeeShopId = context
                                              .read<CoffeeShopBloc>()
                                              .state
                                              .coffeeShop
                                              .id;
                                          if (foodItem != null) {
                                            context.read<ItemBloc>().add(
                                                UpdateItem(
                                                    widget.categoryType,
                                                    widget.category.id,
                                                    foodItem,
                                                    menu,
                                                    coffeeShopId));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      food[index].name,
                                      style: TextStyles.kDefaultLightTextStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor:
                                              AppColors.light,
                                        ),
                                        child: Checkbox(
                                            activeColor: AppColors.caramel,
                                            checkColor: AppColors.light,
                                            value: food[index].soldOut,
                                            onChanged: (soldOut) {
                                              FoodTemplate foodItem =
                                                  food[index].copyWith(
                                                      soldOut: soldOut);

                                              Menu menu = context
                                                  .read<MenuBloc>()
                                                  .state
                                                  .menu;
                                              String coffeeShopId = context
                                                  .read<CoffeeShopBloc>()
                                                  .state
                                                  .coffeeShop
                                                  .id;

                                              context.read<ItemBloc>().add(
                                                  UpdateItem(
                                                      widget.categoryType,
                                                      widget.category.id,
                                                      foodItem,
                                                      menu,
                                                      coffeeShopId));
                                            }),
                                      ),
                                      Text("Sold Out?",
                                          style: TextStyles
                                              .kDefaultSmallTextCreamStyle)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: editing
              ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoFatButton(
                    text: "Finish Editing",
                    textStyle: TextStyles.kDefaultLightTextStyle,
                    backgroundColor: AppColors.caramel,
                    width: 300,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        String id = widget.category.id;
                        Category category =
                            Category(id, food, title, description);

                        Menu menu = context.read<MenuBloc>().state.menu;
                        String coffeeShopId =
                            context.read<CoffeeShopBloc>().state.coffeeShop.id;

                        context.read<CategoryBloc>().add(UpdateCategory(
                            CategoryType.food, category, menu, coffeeShopId));
                      }
                    },
                  ),
                )
              : newCategory
                  ? Padding(
                      padding: const EdgeInsets.all(30),
                      child: CortadoFatButton(
                        text: "Create Category",
                        width: 300,
                        textStyle: TextStyles.kDefaultLightTextStyle,
                        backgroundColor: AppColors.caramel,
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            String title = titleController.text;
                            String description = descriptionController.text;
                            Category category =
                                Category(Uuid().v4(), food, title, description);

                            Menu menu = context.read<MenuBloc>().state.menu;
                            String coffeeShopId = context
                                .read<CoffeeShopBloc>()
                                .state
                                .coffeeShop
                                .id;

                            context.read<CategoryBloc>().add(AddCategory(
                                CategoryType.food,
                                category,
                                menu,
                                coffeeShopId));
                          }
                        },
                      ),
                    )
                  : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  _drinkForm(Menu menu) {
    List<DrinkTemplate> drinks;
    if (widget.newCategory) {
      drinks =
          List.castFrom<ItemTemplate, DrinkTemplate>(widget.category.items);
    } else {
      Category category = menu.drinkTemplates
          .firstWhere((category) => category.id == widget.category.id);
      drinks = List.castFrom<ItemTemplate, DrinkTemplate>(category.items);
    }

    drinks.sort((a, b) => a.id.compareTo(b.id));
    return Form(
        key: _formKey,
        child: Scaffold(
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
              widget.category.title,
              style: TextStyle(
                  color: AppColors.light,
                  fontFamily: kFontFamilyNormal,
                  fontSize: 40),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.cream,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      editing = !editing;
                    });
                  },
                ),
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.only(left: 100, right: 100, top: 20),
                  child: TextFormField(
                    validator: (value) {
                      return Validate.requiredField(value, "Required field");
                    },
                    enabled: editing || newCategory,
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
                      disabledBorder: OutlineInputBorder(
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
                    enabled: editing || newCategory,
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
                      disabledBorder: OutlineInputBorder(
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
                                  .pushNamed(kItemRoute, arguments: [
                                false,
                                widget.newCategory,
                                CategoryType.drink,
                                widget.category,
                                DrinkTemplate(
                                    id: Uuid().v4(),
                                    redeemableType: RedeemableType.none,
                                    redeemableSize: SizeInOunces.none,
                                    servedIced: false,
                                    requiredAddIns: [],
                                    availableAddIns: [],
                                    sizePriceMap: {
                                      SizeInOunces.eight: "0.00",
                                      SizeInOunces.twelve: "0.00",
                                      SizeInOunces.sixteen: "0.00",
                                    }),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 90,
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          itemCount: drinks.length,
                          itemBuilder: (context, index) {
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
                                            color: AppColors.cream,
                                          ),
                                          onPressed: () {
                                            Menu menu = context
                                                .read<MenuBloc>()
                                                .state
                                                .menu;
                                            String coffeeShopId = context
                                                .read<CoffeeShopBloc>()
                                                .state
                                                .coffeeShop
                                                .id;
                                            context.read<ItemBloc>().add(
                                                RemoveItem(
                                                    widget.categoryType,
                                                    widget.category.id,
                                                    drinks[index],
                                                    menu,
                                                    coffeeShopId));
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: AppColors.cream,
                                          ),
                                          onPressed: () async {
                                            var drink =
                                                await Navigator.of(context)
                                                    .pushNamed(kItemRoute,
                                                        arguments: [
                                                  true,
                                                  false,
                                                  CategoryType.drink,
                                                  widget.category,
                                                  drinks[index],
                                                ]);

                                            Menu menu = context
                                                .read<MenuBloc>()
                                                .state
                                                .menu;
                                            String coffeeShopId = context
                                                .read<CoffeeShopBloc>()
                                                .state
                                                .coffeeShop
                                                .id;
                                            if (drink != null) {
                                              context.read<ItemBloc>().add(
                                                  UpdateItem(
                                                      widget.categoryType,
                                                      widget.category.id,
                                                      drink,
                                                      menu,
                                                      coffeeShopId));
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      drinks[index].name ?? '',
                                      minFontSize: 16,
                                      style: TextStyles.kDefaultLightTextStyle,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                AppColors.light,
                                          ),
                                          child: Checkbox(
                                              activeColor: AppColors.caramel,
                                              checkColor: AppColors.light,
                                              value: drinks[index].soldOut ??
                                                  false,
                                              onChanged: (soldOut) {
                                                DrinkTemplate drink =
                                                    drinks[index].copyWith(
                                                        soldOut: soldOut);
                                                assert(
                                                    drink.soldOut == soldOut);

                                                Menu menu = context
                                                    .read<MenuBloc>()
                                                    .state
                                                    .menu;
                                                String coffeeShopId = context
                                                    .read<CoffeeShopBloc>()
                                                    .state
                                                    .coffeeShop
                                                    .id;
                                                context.read<ItemBloc>().add(
                                                    UpdateItem(
                                                        widget.categoryType,
                                                        widget.category.id,
                                                        drink,
                                                        menu,
                                                        coffeeShopId));
                                              }),
                                        ),
                                        Text("Sold Out?",
                                            style: TextStyles
                                                .kDefaultSmallTextCreamStyle)
                                      ],
                                    ),
                                  ),
                                  if (drinks[index].redeemableType !=
                                      RedeemableType.none)
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          'images/coffee_bean.svg',
                                          color: AppColors.cream,
                                          height: 18,
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
          floatingActionButton: editing
              ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: CortadoFatButton(
                    text: "Finish Editing",
                    textStyle: TextStyles.kDefaultLightTextStyle,
                    backgroundColor: AppColors.caramel,
                    width: 300,
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String description = descriptionController.text;
                        String id = widget.category.id;
                        Category category =
                            Category(id, drinks, title, description);

                        Menu menu = context.read<MenuBloc>().state.menu;
                        String coffeeShopId =
                            context.read<CoffeeShopBloc>().state.coffeeShop.id;

                        context.read<CategoryBloc>().add(UpdateCategory(
                            CategoryType.drink, category, menu, coffeeShopId));
                      }
                    },
                  ),
                )
              : newCategory
                  ? Padding(
                      padding: const EdgeInsets.all(30),
                      child: CortadoFatButton(
                        text: "Create Category",
                        width: 300,
                        textStyle: TextStyles.kDefaultLightTextStyle,
                        backgroundColor: AppColors.caramel,
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            String title = titleController.text;
                            String description = descriptionController.text;
                            Category category = Category(
                                Uuid().v4(), drinks, title, description);

                            Menu menu = context.read<MenuBloc>().state.menu;
                            String coffeeShopId = context
                                .read<CoffeeShopBloc>()
                                .state
                                .coffeeShop
                                .id;

                            context.read<CategoryBloc>().add(AddCategory(
                                CategoryType.drink,
                                category,
                                menu,
                                coffeeShopId));
                          }
                        },
                      ),
                    )
                  : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }
}

enum CategoryType { drink, food, addIn }
