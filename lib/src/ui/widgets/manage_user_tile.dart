import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';

class ManageUserTile extends StatefulWidget {
  ManageUserTile({Key key, this.user}) : super(key: key);
  final CortadoUser user;
  @override
  _ManageUserTileState createState() => _ManageUserTileState();
}

class _ManageUserTileState extends State<ManageUserTile>
    with TickerProviderStateMixin {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      curve: Curves.easeInOutQuad,
      duration: Duration(milliseconds: 250),
      child: Padding(
          padding: const EdgeInsets.only(right: 6.0, left: 6.0),
          child: Container(
            color: _expanded ? AppColors.cream : AppColors.light,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              top: 8,
                              left: 6,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: (widget.user.firstName == null)
                                  ? Text(
                                      widget.user.email,
                                      style:
                                          TextStyles.kDefaultLargeDarkTextStyle,
                                    )
                                  : Text(
                                      widget.user.firstName +
                                          " " +
                                          widget.user.lastName,
                                      style:
                                          TextStyles.kDefaultLargeDarkTextStyle,
                                    ),
                            ),
                          ),
                          Spacer(
                            flex: 10,
                          ),
                          Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(right: 10, top: 15),
                              child: Icon(
                                  _expanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: AppColors.dark)),
                        ],
                      ),
                    ),
                  ),
                  _lowerWidget(widget.user),
                ],
              ),
            ),
          )),
    );
  }

  _lowerWidget(CortadoUser user) {
    if (_expanded) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(102),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          children: _lowerExpanded(user),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: 14, bottom: 20),
        alignment: Alignment.topLeft,
        child: Text(
          getAccountType(user),
          style: TextStyles.kDefaultDarkTextStyle,
        ),
      );
    }
  }
}

List<Widget> _lowerExpanded(CortadoUser user) {
  List<Widget> list = <Widget>[];
  //name
  list.add(Row(
    children: <Widget>[
      Flexible(
        child: Container(
          padding: EdgeInsets.only(left: 8),
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            getAccountType(user),
            maxLines: 2,
            minFontSize: 20,
            maxFontSize: 25,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontFamily: kFontFamilyNormal,
              decoration: TextDecoration.underline,
              color: AppColors.caramel,
              fontSize: 25,
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(right: 10),
        child: CircleAvatar(
          backgroundColor: AppColors.dark,
          child: Icon(
            Icons.edit,
            color: AppColors.dark,
            size: 20,
          ),
        ),
      ),
    ],
  ));
  list.add(SizedBox(
    height: 5,
  ));
  //email
  list.add(Row(
    children: <Widget>[
      Container(
          padding: EdgeInsets.only(left: 8),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.email,
            color: AppColors.dark,
          )),
      Container(
        constraints: BoxConstraints(minWidth: 200),
        padding: EdgeInsets.only(left: 4),
        alignment: Alignment.centerLeft,
        child: Text(
          user.email,
          style: TextStyle(
            fontFamily: kFontFamilyNormal,
            color: AppColors.caramel,
            fontSize: 15,
          ),
        ),
      ),
      Container(
          padding: EdgeInsets.only(left: 8),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.phone,
            color: AppColors.dark,
          )),
      if (user.phone != null)
        Container(
          padding: EdgeInsets.only(left: 4),
          alignment: Alignment.centerLeft,
          child: Text(
            user.phone ?? '',
            style: TextStyle(
              fontFamily: kFontFamilyNormal,
              color: AppColors.caramel,
              fontSize: 15,
            ),
          ),
        ),
    ],
  ));

  list.add(Row(
    children: <Widget>[
      Container(
          padding: EdgeInsets.only(left: 8),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.redeem,
            color: AppColors.dark,
          )),
     /*  Container(
        constraints: BoxConstraints(minWidth: 200),
        padding: EdgeInsets.only(left: 4),
        alignment: Alignment.centerLeft,
        child: Text(
          user.redemptionsLeft ?? '0',
          style: TextStyle(
            fontFamily: kFontFamilyNormal,
            color: AppColors.caramel,
            fontSize: 15,
          ),
        ),
      ),
      if (user.reloadDate != null)
        Container(
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.timer,
              color: AppColors.dark,
            )),
      if (user.reloadDate != null)
        Container(
          padding: EdgeInsets.only(left: 4),
          alignment: Alignment.centerLeft,
          child: Text(
            Format.dateFormatter.format(user.reloadDate),
            style: TextStyle(
              fontFamily: kFontFamilyNormal,
              color: AppColors.caramel,
              fontSize: 15,
            ),xe
          ),
        ), */
    ],
  ));

  return list;
}

getAccountType(CortadoUser user) {
  switch (user.cbPlanId) {
    case "premium-unlimited":
      return "Premium Unlimited";
    case "black-unlimited":
      return "Black Unlimited";
    case "premium-daily":
      return "Premium Daily";
    case "black-daily":
      return "Black Daily";
    case "mini-pack":
      return "Mini Pack";
    default:
      return "Not Subscribed";
  }
}
