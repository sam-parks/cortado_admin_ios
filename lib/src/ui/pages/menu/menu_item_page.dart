import 'package:cortado_admin_ios/src/bloc/menu/add_in_item/add_in_item_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/drink_item/drink_item_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/food_item/food_item_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/item/item_bloc.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/add_in_form.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/drink_form.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/food_form.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final ItemTemplate item;
  final bool newCategory;

  @override
  _MenuItemPageState createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemBloc, ItemState>(
        listener: (context, ItemState state) {
      if (state is ItemAdded) Navigator.of(context).pop();
      if (state is ItemUpdated) Navigator.of(context).pop();
    }, builder: (context, state) {
      switch (widget.categoryType) {
        case CategoryType.drink:
          return BlocProvider(
              create: (context) =>
                  DrinkItemBloc()..add(InitializeDrinkItem(widget.item)),
              child: Builder(
                builder: (context) {
                  return DrinkForm(
                    editing: widget.editing,
                    categoryId: widget.category.id,
                    newCategory: widget.newCategory,
                  );
                },
              ));
          break;
        case CategoryType.food:
          return BlocProvider(
              create: (context) =>
                  FoodItemBloc()..add(InitializeFoodItem(widget.item)),
              child: Builder(
                builder: (context) {
                  return FoodForm(
                    editing: widget.editing,
                    categoryId: widget.category.id,
                    newCategory: widget.newCategory,
                  );
                },
              ));
          break;
        case CategoryType.addIn:
          return BlocProvider(
              create: (context) =>
                  AddInItemBloc()..add(InitializeAddInItem(widget.item)),
              child: Builder(
                builder: (context) {
                  return AddInForm(
                    editing: widget.editing,
                    categoryId: widget.category.id,
                    newCategory: widget.newCategory,
                  );
                },
              ));
          break;
        default:
          return Container();
      }
    });
  }
}
