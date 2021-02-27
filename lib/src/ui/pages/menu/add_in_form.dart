import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/add_in_item/add_in_item_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
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
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddInForm extends StatefulWidget {
  AddInForm({Key key, this.editing, this.categoryId, this.newCategory})
      : super(key: key);

  final bool editing;
  final String categoryId;
  final bool newCategory;
  @override
  _AddInFormState createState() => _AddInFormState();
}

class _AddInFormState extends State<AddInForm> {
  MoneyMaskedTextController priceController;
  @override
  void initState() {
    priceController = MoneyMaskedTextController(
      initialValue: 0.00,
      leftSymbol: '\$',
      decimalSeparator: '.',
      thousandSeparator: ',',
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.caramel,
      ),
      backgroundColor: AppColors.light,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AddInItemBloc, AddInItemState>(
        builder: (context, state) {
          if (state.addIn == null) return Center(child: LatteLoader());

          priceController.text = state.addIn.price;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "AddIn Item Info",
                    style: TextStyles.kDefaultLargeDarkTextStyle,
                  ),
                ),
                Container(
                  child: TextFormField(
                    initialValue: state.addIn.name,
                    validator: (value) {
                      return Validate.requiredField(value, "Required field.");
                    },
                    autofocus: true,
                    onChanged: (value) {
                      context.read<AddInItemBloc>().add(ChangeName(value));
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
                SizedBox(height: 10),
                Container(
                  child: TextFormField(
                    initialValue: state.addIn.price,
                    validator: (value) {
                      return Validate.requiredField(value, "Required field.");
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter()
                    ],
                    onChanged: (value) {
                      context
                          .read<AddInItemBloc>()
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
          text: widget.editing ? "Update Add In" : "Create Add In",
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
    AddIn addIn = context.read<AddInItemBloc>().state.addIn;
    Menu menu = context.read<MenuBloc>().state.menu;
    String coffeeShopId = context.read<CoffeeShopBloc>().state.coffeeShop.id;
    if (widget.newCategory)
      Navigator.of(context).pop(addIn);
    else {
      if (widget.editing)
        context.read<ItemBloc>().add(UpdateItem(
            CategoryType.addIn, widget.categoryId, addIn, menu, coffeeShopId));
      else
        context.read<ItemBloc>().add(AddItem(
            CategoryType.addIn, widget.categoryId, addIn, menu, coffeeShopId));
    }
  }
}
