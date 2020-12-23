import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/navigation/navigation_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_fat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tuple/tuple.dart';

class HoursPage extends StatefulWidget {
  HoursPage({Key key}) : super(key: key);

  @override
  _HoursPageState createState() => _HoursPageState();
}

class _HoursPageState extends State<HoursPage> {
  List<Tuple2<String, Tuple2>> readableHours;
  var maskFormatter =
      MaskTextInputFormatter(mask: '##:##', filter: {"#": RegExp(r'[0-9]')});

  List<Tuple2> aMPMSelections = List.generate(7, (index) => Tuple2("AM", "PM"));

  @override
  void didChangeDependencies() {
    print('did change');
    CoffeeShop coffeeShop =
        BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop;
    if (readableHours == null)
      readableHours = reformatHoursToRead(context, coffeeShop.hoursDaily);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Review/Update Hours",
          style: TextStyle(
              color: AppColors.light,
              fontFamily: kFontFamilyNormal,
              fontSize: 40),
        ),
        backgroundColor: AppColors.caramel,
      ),
      backgroundColor: AppColors.dark,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...List.generate(7, (index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textFromDayString(readableHours[index].item1),
                        style: TextStyles.kDefaultLightTextStyle,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: 60,
                      child: TextFormField(
                          inputFormatters: [maskFormatter],
                          initialValue: readableHours[index].item2.item1,
                          onChanged: (value) {
                            setState(() {
                              readableHours[index] = Tuple2(
                                  readableHours[index].item1,
                                  Tuple2(
                                      value, readableHours[index].item2.item2));
                            });
                          },
                          style: TextStyles.kDefaultCreamTextStyle),
                    ),
                    DropdownButton(
                        value: aMPMSelections[index].item1,
                        items: [
                          DropdownMenuItem(
                            value: "AM",
                            child: Text("AM",
                                style: TextStyles.kDefaultCreamTextStyle),
                          ),
                          DropdownMenuItem(
                            value: "PM",
                            child: Text("PM",
                                style: TextStyles.kDefaultCreamTextStyle),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            aMPMSelections[index] =
                                Tuple2(value, aMPMSelections[index].item2);
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text("-", style: TextStyles.kDefaultCreamTextStyle),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: 60,
                      child: TextFormField(
                          inputFormatters: [maskFormatter],
                          initialValue: readableHours[index].item2.item2,
                          onChanged: (value) {
                            setState(() {
                              readableHours[index] = Tuple2(
                                  readableHours[index].item1,
                                  Tuple2(
                                      readableHours[index].item2.item1, value));
                            });
                            print(readableHours[index]);
                          },
                          style: TextStyles.kDefaultCreamTextStyle),
                    ),
                    DropdownButton(
                        value: aMPMSelections[index].item2,
                        items: [
                          DropdownMenuItem(
                            value: "AM",
                            child: Text("AM",
                                style: TextStyles.kDefaultCreamTextStyle),
                          ),
                          DropdownMenuItem(
                            value: "PM",
                            child: Text("PM",
                                style: TextStyles.kDefaultCreamTextStyle),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            aMPMSelections[index] =
                                Tuple2(aMPMSelections[index].item1, value);
                          });
                        }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CortadoFatButton(
        text: "Update Hours",
        textStyle: TextStyles.kDefaultLightTextStyle,
        backgroundColor: AppColors.caramel,
        width: 300,
        onTap: () async {
          CoffeeShop coffeeShop =
              BlocProvider.of<CoffeeShopBloc>(context).state.coffeeShop;

          Map hours = reformatHoursUpdate(readableHours);

          await coffeeShop.reference.update({'hoursDaily': hours});

          BlocProvider.of<CoffeeShopBloc>(context)
              .add(InitializeCoffeeShop(coffeeShop.id));

          BlocProvider.of<NavigationBloc>(context).add(ChangeDashboardPage(
              CortadoAdminScreen.dashboard,
              BlocProvider.of<NavigationBloc>(context).state.menuItems.first));

          Navigator.of(context).pop();
        },
      ),
    );
  }

  List<Tuple2<String, Tuple2>> reformatHoursToRead(
      BuildContext context, Map hours) {
    List<Tuple2<String, Tuple2>> reformattedHours = [];

    hours.forEach((day, openAndClose) {
      if (openAndClose[0] != 0) {
        String open = Format.formatMilitaryTime(openAndClose[0], context)
            .replaceAll(RegExp(r'[a-zA-Z]'), '');

        String close = Format.formatMilitaryTime(openAndClose[1], context)
            .replaceAll(RegExp(r'[a-zA-Z]'), '');

        Tuple2 openAndCloseTuple = Tuple2(open, close);
        reformattedHours.add(Tuple2(day, openAndCloseTuple));
      }
    });

    reformattedHours.sort((a, b) => a.item1.compareTo(b.item1));

    return reformattedHours;
  }

  Map reformatHoursUpdate(List<Tuple2<String, Tuple2>> hours) {
    Map reformattedHours = {};

    hours.forEach((dayTuple) {
      reformattedHours[dayTuple.item1] = [
        Format.toMilitaryTime(dayTuple.item2.item1 +
            aMPMSelections[int.parse(dayTuple.item1) - 1].item1),
        Format.toMilitaryTime(dayTuple.item2.item2 +
            aMPMSelections[int.parse(dayTuple.item1) - 1].item2)
      ];
    });

    return reformattedHours;
  }
}

textFromDayString(String day) {
  switch (day) {
    case "1":
      return "Mon";
      break;
    case "2":
      return "Tue";
      break;
    case "3":
      return "Wed";
      break;
    case "4":
      return "Thur";
      break;
    case "5":
      return "Fri";
      break;
    case "6":
      return "Sat";
      break;
    case "7":
      return "Sun";
      break;
  }
}
