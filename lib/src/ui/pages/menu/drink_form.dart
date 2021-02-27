import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/drink_item/drink_item_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/item/item_bloc.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/latte_loader.dart';
import 'package:cortado_admin_ios/src/utils/currency_input_formatter.dart';
import 'package:cortado_admin_ios/src/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrinkForm extends StatefulWidget {
  DrinkForm({Key key, this.editing, this.categoryId, this.newCategory})
      : super(key: key);

  final bool editing;
  final String categoryId;
  final bool newCategory;
  @override
  _DrinkFormState createState() => _DrinkFormState();
}

class _DrinkFormState extends State<DrinkForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.caramel,
      ),
      backgroundColor: AppColors.light,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<DrinkItemBloc, DrinkItemState>(
        builder: (context, state) {
          if (state.drinkTemplate == null) return Center(child: LatteLoader());

          return Container(
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
                      initialValue: state.drinkTemplate.name,
                      onChanged: (value) {
                        context.read<DrinkItemBloc>().add(ChangeName(value));
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
                    child: TextFormField(
                      initialValue: state.drinkTemplate.description,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        context
                            .read<DrinkItemBloc>()
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
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Sizes and Prices",
                        style: TextStyles.kDefaultLargeDarkTextStyle),
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(state.regularSizes.length, (index) {
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
                                    value: state.drinkTemplate.sizePriceMap.keys
                                        .contains(state.regularSizes[index]),
                                    onChanged: (_) {
                                      if (state.drinkTemplate.sizePriceMap.keys
                                          .contains(
                                              state.regularSizes[index])) {
                                        context.read<DrinkItemBloc>().add(
                                            RemovePriceFromSizePriceMap(
                                                state.regularSizes[index]));
                                      } else {
                                        context.read<DrinkItemBloc>().add(
                                            AddPriceToSizePriceMap(
                                                state.regularSizes[index]));
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    state.regularSizes[index].sizeToString(),
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
                              visible: state.drinkTemplate.sizePriceMap.keys
                                  .contains(state.regularSizes[index]),
                              child: Container(
                                width: 160,
                                child: Row(
                                  children: [
                                    Text(
                                      "Price: \$ ",
                                      style:
                                          TextStyles.kDefaultCaramelTextStyle,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            initialValue: state
                                                    .drinkTemplate.sizePriceMap[
                                                state.regularSizes[index]],
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              CurrencyInputFormatter()
                                            ],
                                            validator: (value) {
                                              if (state.drinkTemplate
                                                  .sizePriceMap.keys
                                                  .contains(state
                                                      .regularSizes[index])) {
                                                return Validate.requiredField(
                                                    value, "Required field.");
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              context.read<DrinkItemBloc>().add(
                                                  ChangePriceForSize(
                                                      state.regularSizes[index],
                                                      value.substring(1)));
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
                  availableAddins(state.drinkTemplate),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Required Add Ins",
                        style: TextStyles.kDefaultLargeDarkTextStyle),
                  ),
                  requiredAddIns(state.drinkTemplate),
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
                              value: state.drinkTemplate.servedIced,
                              onChanged: (serveIced) {
                                context
                                    .read<DrinkItemBloc>()
                                    .add(ChangeServeIced(serveIced));
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
                                  value: state.drinkTemplate.redeemableType ==
                                      RedeemableType.black,
                                  onChanged: (blackRedeemable) {
                                    if (blackRedeemable)
                                      context.read<DrinkItemBloc>().add(
                                          ChangeRedeemableType(
                                              RedeemableType.black,
                                              state.drinkTemplate
                                                          .redeemableSize ==
                                                      null
                                                  ? SizeInOunces.eight
                                                  : state.drinkTemplate
                                                      .redeemableSize));
                                    else
                                      context.read<DrinkItemBloc>().add(
                                          ChangeRedeemableType(
                                              RedeemableType.none,
                                              SizeInOunces.none));
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
                                  value: state.drinkTemplate.redeemableType ==
                                      RedeemableType.premium,
                                  onChanged: (premiumRedeemable) {
                                    if (premiumRedeemable)
                                      ChangeRedeemableType(
                                          RedeemableType.premium,
                                          state.drinkTemplate.redeemableSize ==
                                                  null
                                              ? SizeInOunces.eight
                                              : state.drinkTemplate
                                                  .redeemableSize);
                                    else
                                      context.read<DrinkItemBloc>().add(
                                          ChangeRedeemableType(
                                              RedeemableType.none,
                                              SizeInOunces.none));
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
                  if (state.drinkTemplate.redeemableType != RedeemableType.none)
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
                              List.generate(state.regularSizes.length, (index) {
                            return Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: AppColors.dark,
                                  ),
                                  child: Checkbox(
                                      activeColor: AppColors.dark,
                                      checkColor: AppColors.cream,
                                      value:
                                          state.drinkTemplate.redeemableSize ==
                                              state.regularSizes[index],
                                      onChanged: (value) {
                                        if (value) {
                                          context.read<DrinkItemBloc>().add(
                                              ChangeRedeemableSize(
                                                  state.regularSizes[index]));
                                        } else {
                                          context.read<DrinkItemBloc>().add(
                                              ChangeRedeemableSize(
                                                  SizeInOunces.none));
                                        }
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      state.regularSizes[index].sizeToString(),
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
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(30),
        child: CortadoFatButton(
          text: widget.editing ? "Update Drink" : "Create Drink",
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
    DrinkTemplate foodTemplate =
        context.read<DrinkItemBloc>().state.drinkTemplate;
    Menu menu = context.read<MenuBloc>().state.menu;
    String coffeeShopId = context.read<CoffeeShopBloc>().state.coffeeShop.id;
    if (widget.newCategory)
      Navigator.of(context).pop(foodTemplate);
    else {
      if (widget.editing)
        context.read<ItemBloc>().add(UpdateItem(CategoryType.drink,
            widget.categoryId, foodTemplate, menu, coffeeShopId));
      else
        context.read<ItemBloc>().add(AddItem(CategoryType.drink,
            widget.categoryId, foodTemplate, menu, coffeeShopId));
    }
  }

  requiredAddIns(DrinkTemplate drink) {
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
                      if (drink.requiredAddIns.contains(addInCategory.id)) {
                        context
                            .read<DrinkItemBloc>()
                            .add(RemoveFromRequiredAddIns(addInCategory.id));
                      } else {
                        context
                            .read<DrinkItemBloc>()
                            .add(AddToRequiredAddIns(addInCategory.id));
                      }
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

  availableAddins(DrinkTemplate drink) {
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
                      if (drink.availableAddIns.contains(addInCategory.id)) {
                        context
                            .read<DrinkItemBloc>()
                            .add(RemoveFromAvailableAddIns(addInCategory.id));
                      } else {
                        context
                            .read<DrinkItemBloc>()
                            .add(AddToAvailableAddIns(addInCategory.id));
                      }
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
}
