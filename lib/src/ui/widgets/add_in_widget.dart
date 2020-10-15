import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/ui/widgets/cortado_button.dart';
import 'package:cortado_admin_ios/src/ui/widgets/inherited_add_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:uuid/uuid.dart';

import '../style.dart';

class AddInWidget extends StatefulWidget {
  AddInWidget(
      {Key key,
      this.cancel,
      this.updateParent,
      this.editing,
      this.addIn,
      this.dialog})
      : super(key: key);
  final Function cancel;
  final Function updateParent;
  final bool editing;
  final AddIn addIn;
  final bool dialog;
  @override
  _AddInWidgetState createState() => _AddInWidgetState();
}

class _AddInWidgetState extends State<AddInWidget> {
  final _priceController = MoneyMaskedTextController(
    leftSymbol: '\$',
    initialValue: 0.00,
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  AddIn addIn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addIn =
        widget.dialog ? widget.addIn : InheritedAddInProvider.of(context).addIn;
    if (addIn != null) {
      _nameController.text = addIn.name;
      _priceController.text = addIn.price;
      _descriptionController.text = addIn.description;
    } else {
      addIn = AddIn(id: Uuid().v4());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            widget.dialog
                ? Container()
                : IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.light),
                    onPressed: widget.cancel),
          ],
        ),
        Container(
          child: TextField(
            autofocus: true,
            controller: _nameController,
            onChanged: (value) {
              addIn.name = value.trim();
              widget.updateParent(addIn);
            },
            style: TextStyle(
              fontSize: 14,
              color: AppColors.light,
              fontFamily: kFontFamilyNormal,
              letterSpacing: .75,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.light, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.light, width: 2.0),
              ),
              labelText: "Name",
              labelStyle: TextStyle(
                fontSize: 14,
                color: AppColors.cream,
                fontFamily: kFontFamilyNormal,
                letterSpacing: .75,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: TextField(
            controller: _priceController,
            onChanged: (value) {
              addIn.price = _priceController.text.substring(1);
              widget.updateParent(addIn);
            },
            style: TextStyle(
              fontSize: 14,
              color: AppColors.light,
              fontFamily: kFontFamilyNormal,
              letterSpacing: .75,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.light, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.light, width: 2.0),
              ),
              labelText: "Price",
              labelStyle: TextStyle(
                fontSize: 14,
                color: AppColors.cream,
                fontFamily: kFontFamilyNormal,
                letterSpacing: .75,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: TextField(
            controller: _descriptionController,
            onChanged: (value) {
              addIn.description = value.trim();
              widget.updateParent(addIn);
            },
            style: TextStyle(
              fontSize: 14,
              color: AppColors.light,
              fontFamily: kFontFamilyNormal,
              letterSpacing: .75,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.light, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.light, width: 2.0),
              ),
              labelText: "Description",
              labelStyle: TextStyle(
                fontSize: 14,
                color: AppColors.cream,
                fontFamily: kFontFamilyNormal,
                letterSpacing: .75,
              ),
            ),
          ),
        ),
        if (widget.dialog)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CortadoButton(
              text: widget.editing ? "Update Add In" : "Create Add In",
              height: 40,
              color: AppColors.cream,
              onTap: () {
                Navigator.of(context).pop(addIn);
              },
            ),
          ),
      ],
    );
  }
}
