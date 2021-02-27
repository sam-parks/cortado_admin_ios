import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/food_item/food_item_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/item/item_bloc.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/latte_loader.dart';
import 'package:cortado_admin_ios/src/utils/currency_input_formatter.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodForm extends StatefulWidget {
  FoodForm({Key key, this.editing, this.categoryId, this.newCategory})
      : super(key: key);

  final bool editing;
  final String categoryId;
  final bool newCategory;
  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.caramel,
      ),
      backgroundColor: AppColors.light,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<FoodItemBloc, FoodItemState>(
        builder: (context, state) {
          if (state.foodTemplate == null) return Center(child: LatteLoader());

          return Container(
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
                    initialValue: state.foodTemplate.name,
                    validator: (value) {
                      return Validate.requiredField(value, "Required field.");
                    },
                    onChanged: (value) {
                      context.read<FoodItemBloc>().add(ChangeName(value));
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
                  child: TextFormField(
                    initialValue: state.foodTemplate.description,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      context
                          .read<FoodItemBloc>()
                          .add(ChangeDescription(value));
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
                SizedBox(height: 5),
                Container(
                  child: TextFormField(
                    initialValue: state.foodTemplate.price,
                    validator: (value) {
                      return Validate.requiredField(value, "Required field.");
                    },
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter()
                    ],
                    onChanged: (value) {
                      context
                          .read<FoodItemBloc>()
                          .add(ChangePrice(value.substring(1)));
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
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(30),
        child: CortadoFatButton(
          text: widget.editing ? "Update Food Item" : "Create Food Item",
          textStyle: TextStyles.kDefaultLightTextStyle,
          backgroundColor: AppColors.caramel,
          width: 300,
          onTap: () => _updateAddItem(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _updateAddItem() {
    FoodTemplate foodTemplate = context.read<FoodItemBloc>().state.foodTemplate;
    Menu menu = context.read<MenuBloc>().state.menu;
    String coffeeShopId = context.read<CoffeeShopBloc>().state.coffeeShop.id;
    if (widget.newCategory)
      Navigator.of(context).pop(foodTemplate);
    else {
      if (widget.editing)
        context.read<ItemBloc>().add(UpdateItem(CategoryType.food,
            widget.categoryId, foodTemplate, menu, coffeeShopId));
      else
        context.read<ItemBloc>().add(AddItem(CategoryType.food,
            widget.categoryId, foodTemplate, menu, coffeeShopId));
    }
  }
}
