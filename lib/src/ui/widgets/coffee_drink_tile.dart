import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/data/models/coffee_shop_state.dart';
import 'package:cortado_admin_ios/src/services/firebase_service.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeDrinkTile extends StatefulWidget {
  CoffeeDrinkTile(
    this.name,
    this.type,
    this.reoadDrinks, {
    Key key,
  }) : super(key: key);
  final String name;
  final String type;
  final Function reoadDrinks;
  @override
  _CoffeeDrinkTileState createState() => _CoffeeDrinkTileState();
}

class _CoffeeDrinkTileState extends State<CoffeeDrinkTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShopState>(
      builder: (BuildContext context, CoffeeShopState coffeeShopState, _) {
        return Container(
          height: 140,
          width: double.infinity,
          child: Card(
            color: AppColors.light,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        widget.name,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: kFontFamilyNormal,
                            color: AppColors.caramel),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: AppColors.dark,
                          child: IconButton(
                            color: AppColors.light,
                            onPressed: () {
                              if (widget.type == "black") {
                                coffeeShopState.coffeeShop.blackCoffees
                                    .remove(widget.name);
                                updateDrinks(
                                    coffeeShopState.coffeeShop.id,
                                    coffeeShopState.coffeeShop.blackCoffees,
                                    widget.type);
                                widget.reoadDrinks();
                              } else {
                                coffeeShopState.coffeeShop.premiumCoffees
                                    .remove(widget.name);
                                updateDrinks(
                                    coffeeShopState.coffeeShop.id,
                                    coffeeShopState.coffeeShop.premiumCoffees,
                                    widget.type);
                                widget.reoadDrinks();
                              }
                            },
                            icon: Icon(Icons.delete),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
