import 'dart:ui';

import 'package:barcode_scan/model/model.dart';
import 'package:barcode_scan/model/scan_options.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messager/interactor/join_room_interactor.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/create_room_screen/create_room_screen.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/helper/incoming_uri_helper.dart';

import 'widget/more_screen_avatar_view.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      child: Column(
        children: <Widget>[
          navBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text(
              UserScopeWidget.of(context).myProfile.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: CustomTheme.of(context).textBlackGrayColor,
                  fontFamily: CustomTheme.of(context).boldFontFamily,
                  fontSize: 24),
            ),
          ),
          MoreScreenAvatarView(),
          Container(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                ScanResult result = await BarcodeScanner.scan(
                    options: ScanOptions(strings: {
                  "cancel": "Отмена",
                  "flash_on": "Включить вспышку",
                  "flash_off": "Выключить вспышку",
                }));
                if (result.rawContent != null && result.rawContent.isNotEmpty) {
                  Uri uri = Uri.parse(result.rawContent);
                  IncomingUriHelperData data =
                      IncomingUriHelper().incomingUriHandler(uri);
                  if (data == null) return;
                  if (data.type == IncomingUriType.JoinRoom) {
                    IncomingUriJoinRoomData uriJoinRoomData = data;
                    if (uriJoinRoomData.uuid != null &&
                        uriJoinRoomData.roomId != null) {
                      JoinRoomInteractor(UserScopeWidget.of(context))
                          .join(uriJoinRoomData.roomId);
                    }
                  }
                } else
                  Fluttertoast.showToast(
                      msg: 'Ничего не найдено',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      fontSize: 16.0);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 50,
                        height: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 34,
                              width: 34,
                              child:
                                  SvgPicture.asset('assets/icons/ic_qr.svg')),
                        )),
                    Text('Присоединиться к чату по QR',
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateRoomScreen()));
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 50,
                        height: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 34,
                              width: 34,
                              child:
                                  SvgPicture.asset('assets/icons/ic_qr.svg')),
                        )),
                    Text('Создать чат', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navBar() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).padding.top + 55,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                height: 55 + MediaQuery.of(context).padding.top,
                color: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Еще',
                      style: TextStyle(
                          color: CustomTheme.of(context).textBlackColor,
                          fontSize: 28,
                          fontFamily: CustomTheme.of(context).boldFontFamily),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
