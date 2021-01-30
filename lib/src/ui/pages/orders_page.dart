import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/data/order.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  CoffeeShop _coffeeShop;

  bool _viewCurrentOrders = true;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _coffeeShop = BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop;
    BlocProvider.of<OrdersBloc>(context).add(GetOrders(_coffeeShop.reference));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (BuildContext context, state) {
          if (state is OrdersLoadingState) {
            return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.caramel)));
          }

          List<Order> currentOrders = state.orders
              .where((order) => order.status != OrderStatus.completed)
              .toList();
          List<Order> pastOrders = state.orders
              .where((order) => order.status == OrderStatus.completed)
              .toList();

          return Scrollbar(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(left: 130.0, right: 20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AutoSizeText(
                                  "Orders",
                                  maxLines: 1,
                                  style: TextStyles.kWelcomeTitleTextStyle,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "View daily current or past orders from customers.",
                                    style: TextStyles.kDefaultCaramelTextStyle,
                                  ),
                                )
                              ],
                            ),
                            CortadoFatButton(
                              text: !_viewCurrentOrders
                                  ? "View Current Orders"
                                  : "View Past Orders",
                              backgroundColor: AppColors.dark,
                              textStyle: TextStyles.kDefaultCreamTextStyle,
                              onTap: () {
                                setState(() {
                                  _viewCurrentOrders = !_viewCurrentOrders;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    _viewCurrentOrders
                        ? _currentOrdersGrid(currentOrders)
                        : _pastOrdersGrid(pastOrders)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /* _updateStatusOfOrder(String id, OrderStatus orderStatus) {
    Order order =
        _currentOrders.singleWhere((order) => order.orderRef.id == id);
    int index = _currentOrders.indexOf(order);
    order.status = orderStatus;
    _currentOrders[index] = order;
    setState(() {});
  }
 */
  _currentOrdersGrid(List<Order> orders) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      height: SizeConfig.screenHeight * .8,
      decoration: BoxDecoration(
          color: AppColors.dark, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Current Order Count: " + orders.length.toString(),
              style: TextStyles.kLargeCreamTextStyle,
            ),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  List<Item> items = [];
                  items.addAll(orders[index].food);
                  items.addAll(orders[index].drinks);

                  return Container(
                    width: 300,
                    child: Stack(
                      children: [
                        OrderCard(order: orders[index], items: items),
                        statusButton(orders[index])
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _pastOrdersGrid(List<Order> orders) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      height: SizeConfig.screenHeight * .8,
      decoration: BoxDecoration(
          color: AppColors.dark, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Past Order Count: " + orders.length.toString(),
              style: TextStyles.kLargeCreamTextStyle,
            ),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  List<Item> items = [];
                  items.addAll(orders[index].food);
                  items.addAll(orders[index].drinks);

                  return Container(
                    width: 300,
                    child: Stack(
                      children: [
                        OrderCard(order: orders[index], items: items),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  statusButton(Order order) {
    OrderStatus status = order.status;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          status == OrderStatus.ordered
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    minWidth: 250,
                    height: 40,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        Provider.of<OrdersBloc>(context, listen: false)
                            .add(StartOrder(order.orderRef));
                      },
                      child: Text(
                        "Start Order",
                        style: TextStyle(
                          fontFamily: kFontFamilyNormal,
                          fontSize: 20,
                          color: AppColors.dark,
                        ),
                      ),
                      color: AppColors.light,
                    ),
                  ),
                )
              : status == OrderStatus.started
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonTheme(
                        minWidth: 250,
                        height: 40,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "Ready For Pickup",
                            style: TextStyle(
                              fontFamily: kFontFamilyNormal,
                              fontSize: 20,
                              color: AppColors.caramel,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<OrdersBloc>(context, listen: false)
                                .add(ReadyForPickup(order.orderRef));
                          },
                          color: AppColors.cream,
                        ),
                      ),
                    )
                  : status == OrderStatus.readyForPickup
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonTheme(
                            minWidth: 250,
                            height: 40,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "Complete",
                                style: TextStyle(
                                  fontFamily: kFontFamilyNormal,
                                  fontSize: 20,
                                  color: AppColors.light,
                                ),
                              ),
                              onPressed: () {
                                Provider.of<OrdersBloc>(context, listen: false)
                                    .add(CompleteOrder(order.orderRef));
                              },
                              color: AppColors.dark,
                            ),
                          ))
                      : Container()
        ],
      ),
    );
  }
}
