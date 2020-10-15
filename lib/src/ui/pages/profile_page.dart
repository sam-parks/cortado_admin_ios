import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/payment/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/user_management_bloc.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/data/custom_account.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:cortado_admin_ios/src/ui/widgets/loading_state_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cortado_admin_ios/src/ui/widgets/dialogs.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.reauth}) : super(key: key);
  final bool reauth;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CustomAccount _customAccount;

  Uint8List _pictureBytes;
  Uint8List uploadedImage;

  ExternalAccount _externalAccount;
  PaymentBloc _paymentBloc;
  String _customAccountId;
  bool _loading = false;
  bool _baristasLoading = false;

  List<CortadoUser> _baristas = [];
  UserManagementBloc _userManagementBloc;
  // ignore: close_sinks
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();

    _authBloc = BlocProvider.of<AuthBloc>(context);
    _paymentBloc = BlocProvider.of<PaymentBloc>(context);
    _userManagementBloc = BlocProvider.of<UserManagementBloc>(context);
    _customAccountId = BlocProvider.of<CoffeeShopBloc>(context)
        .state
        .coffeeShop
        .customStripeAccountId;
    if (_customAccountId != null) {
      _paymentBloc.add(RetrieveCustomAccount(_customAccountId));
    }

    _baristasLoading = true;
    _userManagementBloc.add(RetrieveBaristas(
        Provider.of<CoffeeShopState>(context, listen: false).coffeeShop.id));
    if (widget.reauth) {
      CoffeeShopState coffeeShopState =
          Provider.of<CoffeeShopState>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await reauthDialog(context, _paymentBloc, coffeeShopState);
      });
    }
  }

  _payoutWidget(CoffeeShopState coffeeShopState) {
    return DashboardCard(
      innerHorizontalPadding: 10,
      title: "Payout details",
      innerColor: AppColors.light,
      content: _customAccountId == null
          ? _startPayoutAccountContent(coffeeShopState)
          : _customAccount == null
              ? _verifyAccountContent(coffeeShopState)
              : _customAccount.requirements.currentlyDue.isNotEmpty
                  ? _verifyAccountContent(coffeeShopState)
                  : _customAccountContent(coffeeShopState),
    );
  }

  _startFilePicker() async {}

  _baristaWidget(CoffeeShopState coffeeShopState) {
    return DashboardCard(
      innerHorizontalPadding: 10,
      title: "Manage Your Baristas",
      content: _baristaContent(coffeeShopState),
      innerColor: AppColors.light,
    );
  }

  _shopDetailsWidget(CoffeeShopState coffeeShopState) {
    return Expanded(
      child: DashboardCard(
        innerHorizontalPadding: 10,
        title: "Shop/Café Details",
        innerColor: AppColors.light,
        height: SizeConfig.screenHeight * 1.05,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: SizeConfig.screenWidth * .35,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Café Banner",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.dark,
                          fontFamily: kFontFamilyNormal,
                          fontSize: 24)),
                  Tooltip(
                    message: 'Upload File',
                    child: IconButton(
                      icon: Icon(
                        Icons.file_upload,
                        color: AppColors.dark,
                      ),
                      onPressed: () {
                        _startFilePicker();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: SizeConfig.screenWidth * .25,
              child: _pictureBytes == null
                  ? Image.asset(
                      "images/coffee-shop-default.jpg",
                      fit: BoxFit.fitWidth,
                    )
                  : Image.memory(
                      _pictureBytes,
                      fit: BoxFit.fitWidth,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Café Name",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                coffeeShopState.coffeeShop.name,
                style: TextStyle(
                    color: AppColors.caramel,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Café Address",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 24)),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      coffeeShopState.coffeeShop.address['street'] + ',',
                      style: TextStyle(
                          color: AppColors.caramel,
                          fontFamily: kFontFamilyNormal,
                          fontSize: 18),
                    ),
                    Text(
                      coffeeShopState.coffeeShop.address['city'] +
                          ',' +
                          coffeeShopState.coffeeShop.address['state'] +
                          " " +
                          coffeeShopState.coffeeShop.address['zipcode'],
                      style: TextStyle(
                          color: AppColors.caramel,
                          fontFamily: kFontFamilyNormal,
                          fontSize: 18),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Café Description",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.dark,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                coffeeShopState.coffeeShop.description,
                style: TextStyle(
                    color: AppColors.caramel,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Café Hours",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.dark,
                          fontFamily: kFontFamilyNormal,
                          fontSize: 24)),
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.dark),
                    onPressed: () {
                      updateHoursDialog(
                          context, coffeeShopState.coffeeShop.hours);
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Text(
                  "Mon-Fri   " + coffeeShopState.coffeeShop.hours["Mon-Fri"],
                  style: TextStyle(
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 18),
                ),
                Text(
                  "Sat   " + coffeeShopState.coffeeShop.hours["Sat"],
                  style: TextStyle(
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 18),
                ),
                Text(
                  "Sun   " + coffeeShopState.coffeeShop.hours["Sun"],
                  style: TextStyle(
                      color: AppColors.caramel,
                      fontFamily: kFontFamilyNormal,
                      fontSize: 18),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return Consumer<CoffeeShopState>(
      builder: (BuildContext context, CoffeeShopState coffeeShopState, _) {
        _customAccountId = coffeeShopState.coffeeShop.customStripeAccountId;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: MultiBlocListener(
            listeners: [
              BlocListener(
                  cubit: _userManagementBloc,
                  listener: (context, state) {
                    if (state is BaristasRetrieved) {
                      setState(() {
                        _baristas = state.baristas;
                        _baristasLoading = false;
                      });
                    }
                  }),
              BlocListener(
                cubit: _paymentBloc,
                listener: (context, state) async {
                  if (state is PaymentLoadingState) {
                    setState(() {
                      _loading = true;
                    });
                  }

                  if (state is CustomAccountCreated) {
                    setState(() {
                      _loading = false;
                    });
                  }

                  if (state is CustomAccountLinkCreated) {
                    setState(() {
                      _loading = false;
                    });

                    await launch(state.url);
                  }
                  if (state is CustomAccountRetrieved) {
                    setState(() {
                      _loading = false;
                      _customAccount = state.customAccount;

                      if (_customAccount
                          .externalAccounts.externalAccounts.isEmpty) {
                        return;
                      }

                      _externalAccount = _customAccount
                          .externalAccounts.externalAccounts.first;
                    });
                  }
                },
              )
            ],
            child: _loading
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.caramel)))
                : Scrollbar(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130),
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, top: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AutoSizeText(
                                        "Profile",
                                        maxLines: 1,
                                        style:
                                            TextStyles.kWelcomeTitleTextStyle,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Edit your shop details and payout details.",
                                          style: TextStyles
                                              .kDefaultCaramelTextStyle,
                                        ),
                                      )
                                    ],
                                  ),
                                  IconButton(
                                      color: AppColors.dark,
                                      tooltip: "Logout",
                                      icon: Icon(FontAwesomeIcons.signOutAlt),
                                      onPressed: () =>
                                          _authBloc.add(SignOut())),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _shopDetailsWidget(coffeeShopState),
                              Column(
                                children: <Widget>[
                                  _payoutWidget(coffeeShopState),
                                  _baristaWidget(coffeeShopState)
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  _customAccountContent(CoffeeShopState coffeeShopState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Business Email",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 24)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _customAccount.email,
                style: TextStyle(
                    color: AppColors.caramel,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 18),
              ),
            ),
            Text("Account Holder Name",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 24)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _externalAccount.accountHolderName,
                style: TextStyle(
                    color: AppColors.caramel,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 18),
              ),
            ),
            Text("Account Number Last 4",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 24)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _externalAccount.last4,
                style: TextStyle(
                    color: AppColors.caramel,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 18),
              ),
            ),
            Text("Routing Number",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 24)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _externalAccount.routingNumber,
                style: TextStyle(
                    color: AppColors.caramel,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 18),
              ),
            ),
            Text("Account Status",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.dark,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 24)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _externalAccount.status,
                style: TextStyle(
                    color: AppColors.caramel,
                    fontFamily: kFontFamilyNormal,
                    fontSize: 18),
              ),
            ),
          ],
        ),
        CortadoFatButton(
            width: SizeConfig.screenWidth * .17,
            backgroundColor: AppColors.dark,
            text: "Update Account Info",
            onTap: () => _paymentBloc.add(CreateCustomAccountUpdateLink(
                coffeeShopState.coffeeShop.customStripeAccountId)))
      ],
    );
  }

  _startPayoutAccountContent(CoffeeShopState coffeeShopState) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              "In order to start recieving payouts, we need you to create an account by filling in your business email and banking information. Then you will be prompted to fill out a verification form through Stripe. After that, you're all set to start recieving payouts through Cortado!",
              style: TextStyles.kDefaultCaramelTextStyle,
              maxLines: 4,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, bottom: SizeConfig.screenHeight * .075),
                    child: CortadoFatButton(
                      width: SizeConfig.screenWidth * .1,
                      height: 70,
                      backgroundColor: AppColors.dark,
                      text: "Create Payout Account",
                      onTap: () async {
                        await createPayoutAccountDialog(context);
                      },
                    ),
                  ),
                ),
                Expanded(child: Image.asset('images/make_it_rain.png')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _baristaContent(CoffeeShopState coffeeShopState) {
    return Container(
      child: _baristasLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.caramel)),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _baristas.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 350,
                                padding: const EdgeInsets.all(8),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.caramel,
                                    borderRadius:
                                        BorderRadiusDirectional.circular(8.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: AutoSizeText(
                                              _baristas[index].displayName,
                                              style: TextStyles
                                                  .kDefaultLightTextStyle,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: AppColors.cream,
                                                ),
                                                onPressed: () async {},
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: AppColors.cream,
                                                ),
                                                onPressed: () {},
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _baristas[index].email,
                                        style: TextStyles
                                            .kDefaultSmallLightTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CortadoFatButton(
                            width: SizeConfig.screenWidth * .1,
                            height: 70,
                            backgroundColor: AppColors.dark,
                            text: "Add a Barista",
                            onTap: () async {
                              await createBaristaDialog(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  _verifyAccountContent(CoffeeShopState coffeeShopState) {
    return Container(
      child: Column(
        children: <Widget>[
          _customAccount == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    "We still need some information to get you verified! Please click the link below to complete your account.",
                    style: TextStyles.kDefaultCaramelTextStyle,
                    maxLines: 4,
                  ),
                )
              : _customAccount.requirements.currentlyDue.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "We still need some information to get you verified! Please click the link below to complete your account.",
                        style: TextStyles.kDefaultCaramelTextStyle,
                        maxLines: 4,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "Now that you've created your payout account, it's time to get verified!",
                        style: TextStyles.kDefaultCaramelTextStyle,
                        maxLines: 4,
                      ),
                    ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                LoadingStateButton<PaymentLoadingState>(
                  bloc: _paymentBloc,
                  button: CortadoFatButton(
                      width: SizeConfig.screenWidth * .1,
                      height: 70,
                      backgroundColor: AppColors.dark,
                      text: "Get Verified",
                      onTap: () => _paymentBloc.add(CreateCustomAccountLink(
                          coffeeShopState.coffeeShop.customStripeAccountId))),
                ),
                Expanded(child: Image.asset('images/make_it_rain.png')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
