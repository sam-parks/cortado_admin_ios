import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/finance/account/finance_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/finance/links/finance_links_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/user_management/user_management_bloc.dart';
import 'package:cortado_admin_ios/src/data/custom_account.dart';
import 'package:cortado_admin_ios/src/ui/router.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_admin_loading_indicator.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/dashboard_card.dart';
import 'package:cortado_admin_ios/src/ui/widgets/loading_state_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cortado_admin_ios/src/ui/widgets/dialogs.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(
    this.reauth, {
    Key key,
  }) : super(key: key);

  final bool reauth;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ignore: close_sinks
  FinanceBloc financeBloc;

  // ignore: close_sinks
  FinanceLinksBloc financeLinksBloc;

  Uint8List uploadedImage;

  BaristaManagementBloc _baristaManagementBloc;
  Uint8List _pictureBytes;

  @override
  void initState() {
    super.initState();
    _baristaManagementBloc = BlocProvider.of<BaristaManagementBloc>(context);
    if (_baristaManagementBloc.state is! BaristasLoadSuccess)
      _baristaManagementBloc.add(RetrieveBaristas(
          BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop.id));
  }

  _payoutWidget(FinanceStatus status) {
    return Stack(
      children: [
        DashboardCard(
            innerHorizontalPadding: 10,
            title: "Payout details",
            innerColor: AppColors.light,
            content: _financeStatusToWidget(status)),
        if (status == FinanceStatus.verified)
          Positioned(
            right: 15,
            top: 10,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CortadoFatButton(
                  width: SizeConfig.screenWidth * .17,
                  height: 35,
                  backgroundColor: AppColors.tan,
                  text: "Update Account Information",
                  textStyle: TextStyles.kDefaultCaramelTextStyle,
                  onTap: () => financeLinksBloc.add(
                      CreateCustomAccountUpdateLink(
                          financeBloc.state.customAccount.id))),
            ),
          )
      ],
    );
  }

  _startFilePicker() async {}

  _baristaWidget(CoffeeShopState coffeeShopState) {
    return Stack(
      children: [
        DashboardCard(
          innerHorizontalPadding: 10,
          title: "Manage Your Baristas",
          content: _baristaContent(coffeeShopState),
          innerColor: AppColors.light,
        ),
        Positioned(
          right: 15,
          top: 10,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CortadoFatButton(
              width: SizeConfig.screenWidth * .1,
              height: 35,
              backgroundColor: AppColors.tan,
              textStyle: TextStyles.kDefaultCaramelTextStyle,
              text: "Add a Barista",
              onTap: () {
                Navigator.of(context).pushNamed(kAddBaristaRoute);
              },
            ),
          ),
        )
      ],
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

  _financeStatusToWidget(FinanceStatus status) {
    switch (status) {
      case FinanceStatus.initial:
        return _financeInitialWidget();
        break;
      case FinanceStatus.unverified:
        return _verifyAccountContent();
        break;
      case FinanceStatus.verified:
        return _customAccountContent();
        break;
      case FinanceStatus.loading:
        return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.caramel)),
        );
        break;
    }
  }

  _customAccountContent() {
    ExternalAccount externalAccount =
        financeBloc.state.customAccount.externalAccounts.externalAccounts.first;
    return Column(
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
            financeBloc.state.customAccount.email ?? '',
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
            externalAccount.accountHolderName ?? '',
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
            externalAccount.last4,
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
            externalAccount.routingNumber,
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
            externalAccount.status,
            style: TextStyle(
                color: AppColors.caramel,
                fontFamily: kFontFamilyNormal,
                fontSize: 18),
          ),
        ),
      ],
    );
  }

  _financeInitialWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              "In order to start recieving payouts, we need you to create an account by filling in your business email and banking information. Then you will be prompted to fill out a verification form through Stripe. After that, you're all set to start recieving payouts through Cortado!",
              style: TextStyles.kDefaultCaramelTextStyle,
              maxLines: 6,
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, bottom: SizeConfig.screenHeight * .075),
                    child: CortadoFatButton(
                      width: SizeConfig.screenWidth * .13,
                      height: 50,
                      backgroundColor: AppColors.dark,
                      text: "Create Payout Account",
                      onTap: () {
                        Navigator.of(context).pushNamed(kInitiateFinance);
                      },
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                    flex: 5, child: Image.asset('images/make_it_rain.png')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _baristaContent(CoffeeShopState coffeeShopState) {
    return BlocBuilder(
      cubit: _baristaManagementBloc,
      builder: (BuildContext context, BaristaManagementState baristaState) {
        if (baristaState is BaristasLoadInProgress)
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.caramel)),
          );

        return Stack(
          children: <Widget>[
            Container(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .6,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                scrollDirection: Axis.horizontal,
                itemCount:
                    (baristaState as BaristasLoadSuccess).baristas.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.caramel,
                        borderRadius: BorderRadiusDirectional.circular(8.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                (baristaState as BaristasLoadSuccess)
                                    .baristas[index]
                                    .displayName,
                                style: TextStyles.kDefaultLightTextStyle,
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
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              (baristaState as BaristasLoadSuccess)
                                  .baristas[index]
                                  .email,
                              style: TextStyles.kDefaultSmallLightTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _verifyAccountContent() {
    return Container(
      child: Column(
        children: <Widget>[
          financeBloc.state.customAccount == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    "We still need some information to get you verified! Please click the link below to complete your account.",
                    style: TextStyles.kDefaultCaramelTextStyle,
                    maxLines: 4,
                  ),
                )
              : financeBloc
                      .state.customAccount.requirements.currentlyDue.isNotEmpty
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
                LoadingStateButton<FinanceLinksLoading>(
                  bloc: financeLinksBloc,
                  button: CortadoFatButton(
                      width: SizeConfig.screenWidth * .1,
                      height: 70,
                      backgroundColor: AppColors.dark,
                      text: "Get Verified",
                      onTap: () => financeLinksBloc.add(CreateCustomAccountLink(
                          financeBloc.state.customAccount.id))),
                ),
                Expanded(child: Image.asset('images/make_it_rain.png')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    CoffeeShopState coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;

    // ignore: close_sinks
    financeBloc = Provider.of<FinanceBloc>(context);
    financeLinksBloc = Provider.of<FinanceLinksBloc>(context);

    return BlocConsumer(
      cubit: financeLinksBloc,
      listener: (context, state) {
        if (state is CustomUpdateLinkCreated) {
          launch(state.link);
        }

        if (state is CustomAccountLinkCreated) {
          launch(state.link);
        }
      },
      builder: (BuildContext context, financeLinksState) {
        return BlocBuilder(
          cubit: financeBloc,
          builder: (BuildContext context, FinanceState financeState) {
            return Scaffold(
              body: Scrollbar(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(left: 130.0, right: 20),
                  child: ListView(
                    controller: _scrollController,
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
                                    "Profile",
                                    maxLines: 1,
                                    style: TextStyles.kWelcomeTitleTextStyle,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "Edit your shop details and payout details.",
                                      style:
                                          TextStyles.kDefaultCaramelTextStyle,
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              if (financeLinksState is FinanceLinksLoading)
                                CortadoAdminLoadingIndicator(),
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
                              _payoutWidget(financeState.status),
                              _baristaWidget(coffeeShopState)
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
