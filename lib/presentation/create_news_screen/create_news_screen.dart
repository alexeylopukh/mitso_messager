import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class CreateNewsScreen extends StatefulWidget {
  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  bool networkOperation = false;

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      child: Column(
        children: <Widget>[
          navBar(),
          TextFormField(
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableInteractiveSelection: true,
            cursorColor: CustomTheme.of(context).primaryColor,
            decoration: InputDecoration(
              hintText: 'Заголовок',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 5),
            ),
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: textController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableInteractiveSelection: true,
              cursorColor: CustomTheme.of(context).primaryColor,
              decoration: InputDecoration(
                hintText: 'Текст',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 5),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 5, left: 20, right: 20),
            child: CustomButton(
              height: 50,
              onTap: () {
                if (networkOperation) return;
                networkOperation = true;
                update();
                UserScopeWidget.of(context)
                    .socketInteractor
                    .sendNews(titleController.text, textController.text);
              },
              width: double.infinity,
              child: networkOperation
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.0,
                    )
                  : Text(
                      'Опубликовать',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
            ),
          )
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
            child: Container(
              height: 55 + MediaQuery.of(context).padding.top,
              color: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onBackButtonPress();
                    },
                    child: Container(
                      width: 45,
                      height: 55,
                      alignment: Alignment.center,
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset('assets/icons/ic_back.svg')),
                    ),
                  ),
                  Text(
                    'Создать новость',
                    style: TextStyle(
                        color: CustomTheme.of(context).textBlackColor,
                        fontSize: 28,
                        fontFamily: CustomTheme.of(context).boldFontFamily),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  onBackButtonPress() {
    Navigator.of(context).pop();
  }

  update() {
    if (mounted) setState(() {});
  }
}
