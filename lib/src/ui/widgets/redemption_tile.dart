
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/redemption.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';

class RedemptionTile extends StatefulWidget {
  const RedemptionTile({Key key, this.redemption}) : super(key: key);
  final Redemption redemption;

  @override
  State<StatefulWidget> createState() => _RedemptionTileState();
}

class _RedemptionTileState extends State<RedemptionTile> {
  Future<DocumentSnapshot> futureCoffeeShop;
  @override
  void initState() {
    super.initState();
    futureCoffeeShop = widget.redemption.coffeeShop.get();
  }

  Widget build(BuildContext context) {
    return Container(
      color: AppColors.light,
      child: ListTile(
        /*   leading: (widget.redemption.type == 'discount')
            ? SvgPicture.asset(
                'images/discount.svg',
                color: AppColors.dark,
                height: 70,
              )
            : SvgPicture.asset(
                "images/coffee.svg",
                height: 90,
              ), */
        title: Container(
          child: widget.redemption.drinkTitle != null
              ? Text(
                  widget.redemption.drinkTitle.toUpperCase(),
                  style: TextStyles.kDefaultSmallTextDarkStyleUnderline,
                )
              : Text(
                  widget.redemption.type.toUpperCase(),
                  style: TextStyles.kDefaultSmallTextDarkStyleUnderline,
                ),
        ),
        subtitle: Text(Format.dateFormatter.format(widget.redemption.createdAt),
            style: TextStyles.kDefaultDarkTextStyle),
      ),
    );
  }
}
