import 'package:cortado_admin_ios/src/ui/widgets/cortado_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style.dart';

class CortadoEditableField extends StatefulWidget {
  CortadoEditableField(
      {Key key,
      this.isPassword,
      this.label,
      this.textCapitalization,
      this.controller,
      this.focusNode,
      this.textInputFormatter,
      this.onChanged,
      this.enabled,
      this.bottomPadding,
      this.textStyle,
      this.editIconColor,
      this.color,
      this.onEdit,
      this.labelStyle,
      this.bottomPosition})
      : super(key: key);

  final double bottomPadding;
  final TextEditingController controller;
  final Color editIconColor;
  @required
  final FocusNode focusNode;
  final String label;
  final TextStyle labelStyle;
  final bool enabled;
  final bool isPassword;
  final TextCapitalization textCapitalization;
  final TextInputFormatter textInputFormatter;
  final TextStyle textStyle;
  final Color color;
  @override
  _CortadoEditableFieldState createState() => _CortadoEditableFieldState();

  final Function(String) onChanged;
  final Function onEdit;
  final double bottomPosition;
}

class _CortadoEditableFieldState extends State<CortadoEditableField> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CortadoInputField(
          color: widget.color,
          style: widget.textStyle,
          label: widget.label,
          labelStyle:
              widget.labelStyle ?? TextStyles.kDefaultSmallTextCaramelStyle,
          onChanged: widget.onChanged,
          focusNode: widget.focusNode,
          controller: widget.controller,
          isPassword: widget.isPassword ?? false,
          autofocus: false,
          textAlign: TextAlign.left,
          enabled: widget.enabled ?? _editing,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.words),
      Positioned(
        right: 20,
        bottom: 0,
        child: IconButton(
            color: widget.editIconColor ?? AppColors.caramel,
            icon: Icon(Icons.edit),
            onPressed: widget.onEdit ??
                () {
                  setState(() {
                    _editing = !_editing;
                    FocusScope.of(context).requestFocus(widget.focusNode);
                  });
                }),
      )
    ]);
  }
}
