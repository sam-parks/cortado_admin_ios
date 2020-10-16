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

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> _allOrders = [];
  List<Order> _currentOrders = [];
  List<Order> _pastOrders = [];
  CoffeeShop _coffeeShop;
  OrdersBloc _ordersBloc;
  bool _loading = true;

  bool _viewCurrentOrders = true;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ordersBloc = BlocProvider.of<OrdersBloc>(context);
    _coffeeShop = BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop;
    _ordersBloc.add(GetOrders(_coffeeShop.reference));
  }

  @override
  Widget build(BuildContext context) {
    _currentOrders = _allOrders
        .where((order) => order.status != OrderStatus.completed)
        .toList();
    _pastOrders = _allOrders
        .where((order) => order.status == OrderStatus.completed)
        .toList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Scrollbar(
        controller: _scrollController,
        child: Padding(
         padding: const EdgeInsets.only(left: 130.0, right: 20),
          child: Center(
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20.0),
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
                BlocListener(
                    cubit: _ordersBloc,
                    listener: (BuildContext context, state) {
                      if (state is OrdersLoadingState) {
                        setState(() {
                          _loading = true;
                        });
                      }
                      if (state is OrdersRetrieved) {
                        setState(() {
                          _loading = false;
                          _allOrders = state.orders;
                        });
                      }

                      if (state is OrderStarted) {
                        _updateStatusOfOrder(state.id, OrderStatus.started);
                      }

                      if (state is ReadyForPickupState) {
                        _updateStatusOfOrder(
                            state.id, OrderStatus.readyForPickup);
                      }

                      if (state is OrderCompleted) {
                        _updateStatusOfOrder(state.id, OrderStatus.completed);
                      }
                    },
                    child: _loading
                        ? Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.caramel)))
                        : _viewCurrentOrders
                            ? _currentOrdersGrid()
                            : _pastOrdersGrid())
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updateStatusOfOrder(String id, OrderStatus orderStatus) {
    Order order =
        _currentOrders.singleWhere((order) => order.orderRef.id == id);
    int index = _currentOrders.indexOf(order);
    order.status = orderStatus;
    _currentOrders[index] = order;
    setState(() {});
  }

  _currentOrdersGrid() {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      height: SizeConfig.screenHeight * .8,
      decoration: BoxDecoration(
          color: AppColors.dark, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Current Order Count: " + _currentOrders.length.toString(),
              style: TextStyles.kLargeCreamTextStyle,
            ),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _currentOrders.length,
                itemBuilder: (context, index) {
                  List<Item> items = [];
                  items.addAll(_currentOrders[index].food);
                  items.addAll(_currentOrders[index].drinks);
                  return OrderCard(
                      orderNumber: _currentOrders[index].orderNumber,
                      createdAt: _currentOrders[index].createdAt,
                      orderStatus: _currentOrders[index].status,
                      orderRef: _currentOrders[index].orderRef,
                      customer: _currentOrders[index].customerName,
                      items: items);
                }),
          ),
        ],
      ),
    );
  }

  _pastOrdersGrid() {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      height: SizeConfig.screenHeight * .8,
      decoration: BoxDecoration(
          color: AppColors.dark, borderRadius: BorderRadius.circular(8)),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _pastOrders.length,
          itemBuilder: (context, index) {
            List<Item> items = [];
            items.addAll(_pastOrders[index].food);
            items.addAll(_pastOrders[index].drinks);
            return OrderCard(
                orderNumber: _pastOrders[index].orderNumber,
                createdAt: _pastOrders[index].createdAt,
                orderStatus: _pastOrders[index].status,
                orderRef: _pastOrders[index].orderRef,
                customer: _pastOrders[index].customerName,
                items: items);
          }),
    );
  }
}
