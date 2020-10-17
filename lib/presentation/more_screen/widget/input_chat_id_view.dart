import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messager/interactor/join_room_interactor.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class InputChatIdView extends StatefulWidget {
  @override
  _InputChatIdViewState createState() => _InputChatIdViewState();
}

class _InputChatIdViewState extends State<InputChatIdView> {
  bool isNetworkOperation = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomTheme.of(context).backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
            child: TextField(
              autofocus: true,
              controller: controller,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => joinRoom(controller.text),
            ),
          ),
          CustomButton(
              height: 50,
              width: 200,
              child: isNetworkOperation
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.0,
                    )
                  : Text(
                      'Создать',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: CustomTheme.of(context).boldFontFamily),
                    ),
              onTap: () => joinRoom(controller.text))
        ],
      ),
    );
  }

  void joinRoom(String id) async {
    if (isNetworkOperation || controller.text.trim().isEmpty) return;
    int id = int.tryParse(controller.text.trim());
    if (id == null) return;
    isNetworkOperation = true;
    update();
    await JoinRoomInteractor(UserScopeWidget.of(context)).join(id);
    isNetworkOperation = false;
    update();
    Navigator.of(context).pop();
  }

  void update() {
    if (mounted) setState(() {});
  }
}
