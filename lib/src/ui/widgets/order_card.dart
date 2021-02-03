import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/data/order.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/chat_box.dart';
import 'package:cortado_admin_ios/src/ui/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCard extends StatefulWidget {
  OrderCard({Key key, this.order, this.items}) : super(key: key);
  final List<Item> items;
  final Order order;

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var dateFormat = DateFormat('jm');

  @override
  Widget build(BuildContext context) {
    String coffeeShopId = context.watch<CoffeeShopBloc>().state.coffeeShop.id;
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.caramel,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cream, width: 3)),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 8.0, left: 8.0, top: 40),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 90,
                            width: 120,
                            child: Column(
                              children: [
                                Flexible(
                                  child: AutoSizeText(
                                    'Ordered At',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyles.kDefaultCreamTextStyle,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: AutoSizeText(
                                    dateFormat.format(widget.order.createdAt),
                                    style: TextStyle(
                                      fontFamily: kFontFamilyNormal,
                                      fontSize: 18,
                                      color: AppColors.light,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            height: 70,
                            width: 1.0,
                            color: AppColors.light,
                          ),
                          Container(
                            height: 90,
                            width: 120,
                            child: Column(
                              children: [
                                Flexible(
                                  child: AutoSizeText(
                                    'Estimated Pick Up Time',
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: TextStyles.kDefaultCreamTextStyle,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: AutoSizeText(
                                        Format.timeFormatter.format(
                                                widget.order.pickUpTime) ??
                                            Format.timeFormatter
                                                .format(DateTime.now()),
                                        maxLines: 1,
                                        style:
                                            TextStyles.kDefaultLightTextStyle,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                        TimeOfDay time =
                                            await showCustomTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay.fromDateTime(
                                                        widget.order
                                                                .pickUpTime ??
                                                            DateTime.now()));
                                        if (time != null) {
                                          final now = new DateTime.now();
                                          widget.order.orderRef.update({
                                            'pickUpTime': DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                time.hour,
                                                time.minute)
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        if (widget.items[index] is Drink) {
                          Drink drink = widget.items[index];

                          return Stack(children: [
                            Container(
                              height: 160,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  border: Border.all(
                                      color: AppColors.dark, width: 3),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: AutoSizeText(
                                            drink.name,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: kFontFamilyNormal,
                                              fontSize: 26,
                                              color: AppColors.dark,
                                            ),
                                          ),
                                        ),
                                        AutoSizeText(
                                          drink.size ?? "12 oz",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: kFontFamilyNormal,
                                            fontSize: 26,
                                            color: AppColors.dark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (drink.addIns != null &&
                                      drink.addIns.isNotEmpty)
                                    Container(
                                      width: 250,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                scrollDirection:
                                                    Axis.horizontal,
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 1,
                                                childAspectRatio: 1 / 4,
                                                children: List.generate(
                                                    drink.addIns.length,
                                                    (index) {
                                                  return Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child:
                                                              SvgPicture.asset(
                                                            'images/coffee_bean.svg',
                                                            color:
                                                                AppColors.dark,
                                                            width: 15,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: AutoSizeText(
                                                            drink.addIns[index]
                                                                .name,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .caramel,
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
                            ),
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Text(
                                drink.quantity.toString(),
                                style: TextStyles.kDefaultLargeDarkTextStyle,
                              ),
                            )
                          ]);
                        }
                        Food food = widget.items[index];
                        return Container(
                          height: 140,
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColors.dark, width: 3),
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
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ChatBox(
                                coffeeShopId: coffeeShopId,
                                peerId: widget.order.customer.id,
                                customerName: widget.order.customerName,
                              ),
                            ));
                  },
                  child: Row(
                    children: [
                      AutoSizeText(
                        (widget.order.customerName ?? ""),
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: kFontFamilyNormal,
                          fontSize: 18,
                          color: AppColors.light,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.chat, color: AppColors.light),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: AutoSizeText(
                  "# " + widget.order.orderNumber ?? "",
                  style: TextStyle(
                    fontFamily: kFontFamilyNormal,
                    fontSize: 18,
                    color: AppColors.light,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
