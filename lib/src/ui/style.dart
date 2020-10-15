import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

final kCortadoTheme = ThemeData(
  primaryColor: AppColors.caramel,
  primaryColorDark: AppColors.dark,
  backgroundColor: AppColors.light,
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  ),
);

const String kFontFamilyNormal = 'Mermaid';

class AppColors {
  AppColors._();
  static const Color light = Color(0xFFFFF6EE);
  static const Color cream = Color(0xFFEDCAA6);
  static const Color dark = Color(0xFF421F00);
  static const Color dark_low_opacity = Color(0xFF421F00);
  static const Color light_caramel = Color(0xFF7C431C);
  static const Color caramel = Color(0xFF7C3F00);
  static const Color tan = Color(0xFFEDCAA6);
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth;
    blockSizeVertical = screenHeight;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal);
    safeBlockVertical = (screenHeight - _safeAreaVertical);
  }
}

class Format {
  static String phoneToE164(String phone) {
    String formattedPhone = phone
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(' ', '');

    return '+1' + formattedPhone;
  }

  static String capitalize(String word) {
    return word[0].toUpperCase() + word.substring(1);
  }

  static final dateFormatter = DateFormat('MM/dd/yyyy');

  static final dateTimeFormatter = DateFormat.yMd().add_jm();
}

class TextStyles {
  static final TextStyle kDefaultTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 20,
    color: AppColors.caramel,
  );

  static final TextStyle kDefaultTextSmallStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 16,
    color: AppColors.caramel,
  );

  static final TextStyle kDefaultSmallTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 16,
    color: AppColors.cream,
  );

  static final TextStyle kDefaultSmallTextDarkStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 16,
    color: AppColors.dark,
  );

  static final TextStyle kDefaultVerySmallTextDarkStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 12,
    color: AppColors.dark,
  );
  static final TextStyle kDefaultSmallTextCaramelStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 16,
    color: AppColors.caramel,
  );

  static final TextStyle kDefaultSmallTextCreamStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 14,
    color: AppColors.cream,
  );

  static final TextStyle kDefaultSmallTextCaramelStyleUnderline = TextStyle(
      fontFamily: kFontFamilyNormal,
      fontSize: 16,
      color: AppColors.caramel,
      decoration: TextDecoration.underline);

  static final TextStyle kDefaultSmallTextDarkStyleUnderline = TextStyle(
      fontFamily: kFontFamilyNormal,
      fontSize: 16,
      color: AppColors.dark,
      decoration: TextDecoration.underline);

  static final TextStyle kTextDarkStyleUnderline = TextStyle(
      fontFamily: kFontFamilyNormal,
      fontSize: 20,
      color: AppColors.dark,
      decoration: TextDecoration.underline);

  static final TextStyle kDefaultDarkTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 20,
    color: AppColors.dark,
  );

  static final TextStyle kDefaultSmallDarkTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 14,
    color: AppColors.dark,
  );

  static final TextStyle kDefaultLargeDarkTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 30,
    color: AppColors.dark,
  );

  static final TextStyle kDefaultCaramelTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 20,
    color: AppColors.caramel,
  );

  static final TextStyle kLargeCaramelTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 30,
    color: AppColors.caramel,
  );

  static final TextStyle kDefaultSmallCaramelTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 12,
    color: AppColors.caramel,
  );

  static final TextStyle kDefaultLightTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 24,
    color: AppColors.light,
  );

  static final TextStyle kDefaultSmallLightTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 14,
    color: AppColors.light,
  );

  static final TextStyle kDefaultCreamTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 24,
    color: AppColors.cream,
  );
  static final TextStyle kLargeCreamTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 28,
    color: AppColors.cream,
  );

  static final TextStyle kCoffeeDrawerTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 22,
    color: AppColors.light,
  );

  static final TextStyle kCoffeeNavSelectedTextStyle = TextStyle(
      fontFamily: kFontFamilyNormal,
      fontSize: 18,
      color: AppColors.cream,
      fontWeight: FontWeight.bold);

  static final TextStyle kCoffeeNavTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 14,
    color: AppColors.caramel,
  );

  static final TextStyle kCoffeeShopTitleTextStyle = TextStyle(
      fontFamily: kFontFamilyNormal,
      fontSize: 14,
      color: AppColors.light,
      fontWeight: FontWeight.bold);

  static final TextStyle kAccountTitleTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 40,
    color: AppColors.caramel,
  );

  static final TextStyle kSubtitleTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 28,
    color: AppColors.caramel,
  );

  static final TextStyle kHintTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 20,
    color: AppColors.dark,
  );

  static final TextStyle kWelcomeTitleTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 40,
    color: AppColors.dark,
  );

  static final TextStyle kWelcomeTitleLightTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 76,
    color: AppColors.light,
  );

  static final TextStyle kAccountNameTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 46,
    color: AppColors.cream,
  );

  static final TextStyle kContinueTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 28,
    color: AppColors.caramel,
  );

  static final TextStyle kButtonLightTextStyle = TextStyle(
    fontFamily: kFontFamilyNormal,
    fontSize: 28,
    color: AppColors.light,
  );
}

class UsNumberTextInputFormatter extends TextInputFormatter {
  // ignore: deprecated_member_use
  WhitelistingTextInputFormatter formatter =
      // ignore: deprecated_member_use
      WhitelistingTextInputFormatter(new RegExp(r'\d+'));

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    TextEditingValue formattedValue =
        formatter.formatEditUpdate(oldValue, newValue);
    if (oldValue.text == newValue.text) {
      return newValue;
    }
    final int newTextLength = formattedValue.text.length;

    int selectionIndex = formattedValue.selection.extentOffset;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (formattedValue.selection.extentOffset >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(
          formattedValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (formattedValue.selection.extentOffset >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(
          formattedValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (formattedValue.selection.extentOffset >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(
          formattedValue.text.substring(6, usedSubstringIndex = 10) + '');
      if (formattedValue.selection.extentOffset >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(formattedValue.text.substring(usedSubstringIndex));

    if (oldValue != null &&
        oldValue.text != null &&
        oldValue.text.length > newText.toString().length) {
      //selectionIndex++;
    }

    if (oldValue.text == newText.toString()) {
      return oldValue;
    }
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
