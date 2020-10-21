import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatefulWidget {
  OrderCard(
      {Key key, this.items, this.customer, this.createdAt, this.orderNumber})
      : super(key: key);
  final String orderNumber;
  final DateTime createdAt;
  final String customer;
  final List<Item> items;
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var dateFormat = DateFormat('jm');

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.caramel,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cream, width: 3)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    "Customer:  " + widget.customer ?? "",
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: kFontFamilyNormal,
                      fontSize: 26,
                      color: AppColors.cream,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "# " + widget.orderNumber ?? "",
                        style: TextStyle(
                          fontFamily: kFontFamilyNormal,
                          fontSize: 18,
                          color: AppColors.cream,
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
                          color: AppColors.cream,
                        ),
                      ),
                    ),
                  ],
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

                      return Container(
                        height: 160,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: AppColors.cream,
                            border: Border.all(color: AppColors.dark, width: 3),
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
                                                    child: SvgPicture.asset(
                                                      'images/coffee_bean.svg',
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
                          border: Border.all(color: AppColors.dark, width: 3),
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
      ),
    );
  }
}
