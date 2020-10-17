import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messager/presentation/di/custom_theme.dart';

enum PopupState { OK, YesNo }

class Popups {
  static Future showBottomSheet(BuildContext context, PopupState state,
      {String title,
      String description,
      String confirmBtnLabel,
      String discardBtnLabel,
      bool isScrollControlled = false,
      bool crossButtonOnlyCloseBottomSheet = false}) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: isScrollControlled,
        builder: (BuildContext context) {
          return Container(
            color: CustomTheme.of(context).backgroundColor,
            padding: EdgeInsets.only(top: 15.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 19.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => crossButtonOnlyCloseBottomSheet
                              ? Navigator.pop(context)
                              : Navigator.pop(context, false),
                          child: Icon(
                            Icons.close,
                            size: 40,
                          ))
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 25.0, left: 21.0, right: 21.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30.0,
                          letterSpacing: -0.024,
                          color: CustomTheme.of(context).textBlackColor,
                          fontFamily: CustomTheme.of(context).boldFontFamily),
                    )),
                description != null
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 21.0),
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              letterSpacing: -0.024,
                              color: CustomTheme.of(context).grayColor),
                        ),
                      )
                    : Container(),
                state == PopupState.OK
                    ? Container(
                        margin: EdgeInsets.only(top: 31.0),
                        height: 48.0,
                        width: 220.0,
                        child: RaisedButton(
                          onPressed: () => Navigator.pop(context),
                          color: CustomTheme.of(context).primaryColor,
                          child: Text(
                            'OK',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: CustomTheme.of(context).boldFontFamily),
                          ),
                        ),
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 31.0),
                              height: 48.0,
                              width: 220.0,
                              child: RaisedButton(
                                onPressed: () => Navigator.pop(context, true),
                                color: CustomTheme.of(context).primaryColor,
                                child: Text(
                                  confirmBtnLabel == null ? 'YES' : confirmBtnLabel,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontFamily: CustomTheme.of(context).boldFontFamily),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context, false),
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                margin: EdgeInsets.only(top: 19.0),
                                child: Text(
                                  discardBtnLabel == null ? 'NO' : discardBtnLabel,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: CustomTheme.of(context).primaryColor,
                                      fontFamily: CustomTheme.of(context).boldFontFamily),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
//                  Container(
//                    height: 57.0,
//                  )
              ],
            ),
          );
        });
  }

  static showModalDialog(BuildContext context, PopupState state,
      {String title,
      String description,
      String confirmBtnLabel,
      String discardBtnLabel,
      Color buttonColor}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            child: AlertDialog(
              backgroundColor: CustomTheme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              title: title != null && title.isNotEmpty
                  ? Text(
                      title,
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              titleTextStyle: TextStyle(
                  fontSize: 24.0,
                  color: CustomTheme.of(context).textBlackColor,
                  fontFamily: CustomTheme.of(context).boldFontFamily),
              titlePadding: EdgeInsets.only(top: 30.0, left: 19.0, right: 19.0),
              contentPadding: EdgeInsets.all(0.0),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    description != null
                        ? Container(
                            padding: EdgeInsets.only(top: 6.0, left: 19.0, right: 19.0),
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: -0.024,
                                  color: CustomTheme.of(context).grayColor),
                            ),
                          )
                        : Container(),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0))),
                      child: Row(
                        children: <Widget>[
                          state == PopupState.OK
                              ? Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 31.0),
                                    height: 56.0,
                                    child: RaisedButton(
                                      onPressed: () => Navigator.pop(context),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.vertical(bottom: Radius.circular(16.0))),
                                      color: buttonColor == null
                                          ? CustomTheme.of(context).primaryColor
                                          : buttonColor,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            confirmBtnLabel == null
                                                ? 'OK'
                                                : confirmBtnLabel.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontFamily: CustomTheme.of(context).boldFontFamily),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 31.0),
                                          height: 56.0,
                                          child: RaisedButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(16.0))),
                                            color: Colors.white,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  discardBtnLabel == null
                                                      ? 'NO'
                                                      : discardBtnLabel.toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: CustomTheme.of(context).grayColor,
                                                      fontFamily:
                                                          CustomTheme.of(context).boldFontFamily),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 31.0),
                                          height: 56.0,
                                          child: RaisedButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(16.0))),
                                            color: buttonColor == null
                                                ? CustomTheme.of(context).primaryColor
                                                : buttonColor,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  confirmBtnLabel == null
                                                      ? 'YES'
                                                      : confirmBtnLabel.toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          CustomTheme.of(context).boldFontFamily),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<dynamic> showProgressPopup(BuildContext context, Future future) async {
    dynamic result;
    Completer completer = Completer();
    future.catchError((e) {}).then((r) {
      if (!completer.isCompleted) {
        result = r;
        Navigator.of(context, rootNavigator: true).pop();
        completer.complete();
      }
    });
    await showDialog(
        context: context,
        barrierDismissible: false,
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(CustomTheme.of(context).primaryColor),
              strokeWidth: 2,
            ),
          ),
        ));
    if (!completer.isCompleted) {
      completer.complete();
    }
    return result;
  }
}
