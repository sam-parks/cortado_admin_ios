import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/bloc/orders/bloc.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/data/order.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatefulWidget {
  OrderCard(
      {Key key,
      this.items,
      this.customer,
      this.orderRef,
      this.orderStatus,
      this.createdAt,
      this.orderNumber})
      : super(key: key);
  final String orderNumber;
  final DocumentReference orderRef;
  final DateTime createdAt;
  final String customer;
  final List<Item> items;
  final OrderStatus orderStatus;
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var dateFormat = DateFormat('jm');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: MediaQuery.of(context).size.height,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: AppColors.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    widget.customer ?? "",
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: kFontFamilyNormal,
                      fontSize: 26,
                      color: AppColors.caramel,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "# " + widget.orderNumber ?? "",
                        style: TextStyle(
                          fontFamily: kFontFamilyNormal,
                          fontSize: 18,
                          color: AppColors.caramel,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AutoSizeText(
                        dateFormat.format(widget.createdAt),
                        style: TextStyle(
                          fontFamily: kFontFamilyNormal,
                          fontSize: 18,
                          color: AppColors.caramel,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  if (widget.items[index] is Drink) {
                    Drink drink = widget.items[index];

                    return Container(
                      height: 160,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: AppColors.tan,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  drink.name,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: kFontFamilyNormal,
                                    fontSize: 26,
                                    color: AppColors.caramel,
                                  ),
                                ),
                                AutoSizeText(
                                  drink.size ?? "12 oz",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: kFontFamilyNormal,
                                    fontSize: 26,
                                    color: AppColors.caramel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (drink.addIns != null && drink.addIns.isNotEmpty)
                            Container(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Add-Ins",
                                      style: TextStyles
                                          .kDefaultSmallTextDarkStyleUnderline,
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 250,
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.count(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 1,
                                        childAspectRatio: 1 / 4,
                                        children: List.generate(
                                            drink.addIns.length, (index) {
                                          return Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.asset(
                                                    'images/coffee_bean.png',
                                                    color: AppColors.dark,
                                                    width: 15,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: AutoSizeText(
                                                    drink.addIns[index].name,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.caramel,
                                                        fontFamily:
                                                            kFontFamilyNormal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  }
                  Food food = widget.items[index];
                  return Container(
                    height: 140,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            food.name,
                            style: TextStyle(
                              fontFamily: kFontFamilyNormal,
                              fontSize: 26,
                              color: AppColors.caramel,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: widget.orderStatus == OrderStatus.ordered
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CortadoFatButton(
                        width: SizeConfig.screenWidth * .2,
                        text: "Start Order",
                        onTap: () {
                          Provider.of<OrdersBloc>(context, listen: false)
                              .add(StartOrder(widget.orderRef));
                        },
                        backgroundColor: AppColors.cream,
                        color: AppColors.dark,
                      ),
                    )
                  : widget.orderStatus == OrderStatus.started
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CortadoFatButton(
                            width: SizeConfig.screenWidth * .2,
                            text: "Ready For Pickup",
                            onTap: () {
                              Provider.of<OrdersBloc>(context, listen: false)
                                  .add(ReadyForPickup(widget.orderRef));
                            },
                            backgroundColor: AppColors.caramel,
                            color: AppColors.light,
                          ),
                        )
                      : widget.orderStatus == OrderStatus.readyForPickup
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CortadoFatButton(
                                width: SizeConfig.screenWidth * .2,
                                text: "Complete",
                                onTap: () {
                                  Provider.of<OrdersBloc>(context,
                                          listen: false)
                                      .add(CompleteOrder(widget.orderRef));
                                },
                                backgroundColor: AppColors.dark,
                                color: AppColors.light,
                              ))
                          : Container(),
            )
          ],
        ),
      ),
    );
  }
}
