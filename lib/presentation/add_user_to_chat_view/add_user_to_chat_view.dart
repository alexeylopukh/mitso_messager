import 'package:flutter/material.dart';
import 'package:messager/network/rpc/find_users_rpc.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/add_user_to_chat_view/user_item_view.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class AddUserToChatView extends StatefulWidget {
  @override
  _AddUserToChatViewState createState() => _AddUserToChatViewState();
}

class _AddUserToChatViewState extends State<AddUserToChatView> {
  TextEditingController searchController = TextEditingController();

  List<Profile> users;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: Container(
        color: CustomTheme.of(context).backgroundColor.withOpacity(0.95),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(height: 2, width: 100, color: Colors.black54),
            ),
            TextFormField(
              controller: searchController,
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              autofocus: true,
              enableInteractiveSelection: true,
              cursorColor: CustomTheme.of(context).primaryColor,
              decoration: InputDecoration(
                hintText: 'ФИО',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 11, right: 5),
              ),
              onChanged: (String text) async {
                if (text.isEmpty) {
                  users = null;
                } else
                  users = await FindUsersRpc(UserScopeWidget.of(context)).getProfiles(text);
                updateView();
              },
            ),
            if (users == null)
              Container()
            else if (users.isEmpty)
              Center(
                child: Text(
                  "Ничего не найдено",
                  style: TextStyle(
                      color: CustomTheme.of(context).textBlackGrayColor,
                      fontFamily: CustomTheme.of(context).boldFontFamily,
                      fontSize: 18),
                ),
              )
            else
              Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (c, i) {
                        return UserItemView(
                          profile: users[i],
                          showAddButton: true,
                        );
                      }))
          ],
        ),
      ),
    );
  }

  void updateView() {
    if (mounted) setState(() {});
  }
}
