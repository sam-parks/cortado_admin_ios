import 'package:cortado_admin_ios/src/data/models/coffee_shop_state.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscountDialogContent extends StatefulWidget {
  DiscountDialogContent(
      {Key key, this.title, this.description, this.active, this.edit})
      : super(key: key);
  final String title;
  final String description;
  final bool active;
  final bool edit;

  @override
  _DiscountDialogContentState createState() => _DiscountDialogContentState();
}

class _DiscountDialogContentState extends State<DiscountDialogContent> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  bool _active;
  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.description;
    _titleController.text = widget.title;
    _active = widget.active ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShopState>(
      builder:
          (BuildContext context, CoffeeShopState coffeeShopState, Widget _) {
        return Container(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "New Discount",
                    style: TextStyle(
                        color: AppColors.light,
                        fontFamily: kFontFamilyNormal,
                        fontSize: 20),
                  ),
                  IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.cancel, color: AppColors.light),
                      onPressed: () => Navigator.of(context).pop())
                ],
              ),
              Container(
                child: TextField(
                  autofocus: true,
                  controller: _titleController,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.light,
                    fontFamily: kFontFamilyNormal,
                    letterSpacing: .75,
                  ),
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.cream,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.light, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.light, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                child: TextField(
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  controller: _descriptionController,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.light,
                    fontFamily: kFontFamilyNormal,
                    letterSpacing: .75,
                  ),
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.cream,
                      fontFamily: kFontFamilyNormal,
                      letterSpacing: .75,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.light, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.light, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: AppColors.cream,
                    ),
                    child: Checkbox(
                        activeColor: AppColors.cream,
                        checkColor: AppColors.dark,
                        value: _active,
                        onChanged: (_) {
                          setState(() {
                            _active = !_active;
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Active",
                        style: TextStyle(
                            color: AppColors.cream,
                            fontFamily: kFontFamilyNormal,
                            fontSize: 18)),
                  )
                ],
              )
            ],
          ),
          floatingActionButton: CortadoButton(
            text: widget.edit ? "Update Discount" : "Create Discount",
            height: 40,
            color: AppColors.cream,
            onTap: () {
              String title = _titleController.text;
              String description = _descriptionController.text;

              Navigator.of(context).pop({
                'title': title,
                'description': description,
                "active": _active
              });
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
      },
    );
  }
}
