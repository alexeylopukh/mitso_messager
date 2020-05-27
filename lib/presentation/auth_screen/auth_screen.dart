import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messager/presentation/components/custom_elevation.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/sign_in_view/sign_in_view.dart';
import 'package:messager/presentation/sign_up_view/sign_up_view.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => new _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  double _screenHeight;
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var forms = [
      SignInView(
        onChangePage: () {
          _pageController.animateToPage(1,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
      SignUpView(onChangePage: () {
        _pageController.animateToPage(0,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }),
    ];
    return GeneralScaffold(child: LayoutBuilder(builder: (context, c) {
      if (_screenHeight == null) _screenHeight = c.maxHeight;
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: _screenHeight, minHeight: _screenHeight),
          child: Container(
            height: _screenHeight,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CustomElevation(
                      height: 120,
                      child: SizedBox(
                          width: 120,
                          height: 120,
                          child:
                              SvgPicture.asset('assets/images/app_icon.svg')),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: <Widget>[forms[0], forms[1]],
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
                buildWaves()
              ],
            ),
          ),
        ),
      );
    }));
  }

  buildWaves() {
    return Container(
      height: 150,
      width: double.infinity,
      child: WaveWidget(
        config: CustomConfig(
          colors: [
            CustomTheme.of(context).primaryColor.withOpacity(0.2),
            CustomTheme.of(context).primaryColor.withOpacity(0.5),
            CustomTheme.of(context).primaryColor,
          ],
          durations: [19440, 10800, 6000],
          heightPercentages: [0.23, 0.25, 0.4],
        ),
        backgroundColor: Colors.transparent,
        size: Size(double.infinity, double.infinity),
        waveAmplitude: 10,
      ),
    );
  }
}
