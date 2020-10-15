import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/chat_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeShopTile extends StatefulWidget {
  CoffeeShopTile(
    this.coffeeShop,
    this.peerId,
    this.adminName, {
    Key key,
  }) : super(key: key);

  final CoffeeShop coffeeShop;
  final String peerId;
  final String adminName;

  @override
  _CoffeeShopTileState createState() => _CoffeeShopTileState();
}

class _CoffeeShopTileState extends State<CoffeeShopTile> {
  @override
  Widget build(BuildContext context) {
    AuthState authState = Provider.of<AuthBloc>(context).state;
    return Padding(
        padding: const EdgeInsets.only(right: 6.0, left: 6.0),
        child: Container(
          color: AppColors.dark,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.coffeeShop.name,
                                style: TextStyles.kDefaultLargeDarkTextStyle,
                              ),
                              widget.peerId == null
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.only(left: 30),
                                      child: IconButton(
                                        icon: Icon(Icons.message,
                                            color: AppColors.light),
                                        onPressed: () => showDialog(
                                            context: context,
                                            child: Dialog(
                                              child: ChatBox(
                                                userId: authState.user.id,
                                                peerId: widget.peerId,
                                                coffeeShopName:
                                                    widget.coffeeShop.name,
                                                adminName: widget.adminName,
                                              ),
                                            )),
                                      )),
                              Spacer()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
