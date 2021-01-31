import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  VerificationPage({Key key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  double _curveMargin = 400;
  TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _curveMargin = 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.light,
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.0, color: Colors.transparent)),
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: 0,
              child: Image.asset(
                'images/coffee-beans-left.png',
                width: 100,
              ),
            ),
            Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(
                    "images/Cortado-AdminLogo.png",
                    height: 80,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AutoSizeText(
                  "Sip Coffee. Support Local. Save Money.",
                  maxLines: 1,
                  style: TextStyles.kSubtitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Enter Verification Code",
                        style: TextStyles.kDefaultDarkTextStyle,
                      ),
                    ),
                    Container(
                      width: 350,
                      child: PinCodeTextField(
                        pinTheme: PinTheme(
                          inactiveColor: AppColors.tan,
                          activeColor: AppColors.caramel,
                          selectedColor: AppColors.caramel,
                          fieldHeight: 60,
                          fieldWidth: 45,
                          shape: PinCodeFieldShape.box,
                        ),
                        textStyle: TextStyle(color: AppColors.caramel),
                        onCompleted: (value) {},
                        backgroundColor: AppColors.light,
                        autoFocus: true,
                        controller: _pinController,
                        length: 6,
                        animationType: AnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
                        appContext: context,
                        onChanged: (String value) {},
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [AppColors.dark, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [.98, .02]),
                      border:
                          Border.all(width: 0.0, color: Colors.transparent)),
                  margin: EdgeInsets.only(top: _curveMargin),
                  child: ClipPath(
                    clipper: PinInputClippingClass(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.light,
                          border: Border.all(
                              width: 0.0, color: Colors.transparent)),
                    ),
                  ),
                ),
              ),
            ]),
            Positioned(
              bottom: 250,
              right: 0,
              child: Image.asset(
                'images/coffee-beans-right.png',
                width: 100,
                color: AppColors.cream,
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              child: Image.asset(
                'images/coffee-beans-left.png',
                width: 100,
                color: AppColors.cream,
              ),
            ),
            Positioned(
              top: 100,
              right: 0,
              child: Image.asset(
                'images/latte_right.png',
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PinInputClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 30.0);
    path.quadraticBezierTo(size.width / 4, 80, size.width / 2, 70);
    path.quadraticBezierTo(3 / 4 * size.width, 50, size.width, 70);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
