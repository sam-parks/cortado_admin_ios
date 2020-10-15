import 'dart:async';

import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/data/message.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/coffee_shop_tile.dart';
import 'package:flutter/material.dart';

class CoffeeShopsPage extends StatefulWidget {
  CoffeeShopsPage({Key key, this.user}) : super(key: key);
  final CortadoUser user;
  @override
  _CoffeeShopsPageState createState() => _CoffeeShopsPageState();
}

class _CoffeeShopsPageState extends State<CoffeeShopsPage> {
  List<List<Message>> _conversations = [];
  StreamSubscription _messagesStream;
  List<CoffeeShop> _coffeeShops = [];
  StreamSubscription _coffeeShopsStream;
  Future<Map<String, CortadoUser>> _admins;

  @override
  void dispose() {
    super.dispose();
    _messagesStream.cancel();
    _coffeeShopsStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Coffee Shop Messages",
            style: TextStyles.kWelcomeTitleTextStyle,
          ),
        ),
        (_conversations.isEmpty || _coffeeShops.isEmpty)
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.caramel)),
              )
            : Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: FutureBuilder(
                    future: _admins,
                    builder: (context,
                        AsyncSnapshot<Map<String, CortadoUser>>
                            adminsSnapshot) {
                      if (!adminsSnapshot.hasData) {
                        return Center(
                            child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.caramel))));
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            height: 2,
                            color: AppColors.caramel,
                          );
                        },
                        itemCount: _coffeeShops.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, CortadoUser> adminMap =
                              adminsSnapshot.data;

                          CoffeeShop coffeeShop = _coffeeShops[index];
                          Iterable<CortadoUser> matchedAdmins =
                              adminsSnapshot.data.values.where((admin) =>
                                  coffeeShop.id == admin.coffeeShopId);
                          if (matchedAdmins.isNotEmpty) {
                            CortadoUser admin = matchedAdmins.first;
                            String adminKey = adminMap.keys.firstWhere(
                                (k) => adminMap[k] == admin,
                                orElse: () => null);
                            return CoffeeShopTile(coffeeShop, adminKey,
                                admin.firstName ?? admin.email);
                          }

                          return CoffeeShopTile(coffeeShop, null, null);
                        },
                      );
                    },
                  ),
                ),
              )
      ],
    );
  }

  generateFromIds(List<List<Message>> conversations) {
    List<String> fromIds = [];
    conversations.forEach((conversation) {
      fromIds.add(conversation.first.idFrom);
    });

    return fromIds;
  }
}
