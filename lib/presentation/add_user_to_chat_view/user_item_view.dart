import 'package:flutter/material.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/components/avatar_view.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/di/custom_theme.dart';

class UserItemView extends StatelessWidget {
  final Profile profile;
  final bool showAddButton;
  final Function(Profile profile) onAddClick;

  const UserItemView(
      {Key key, @required this.profile, @required this.showAddButton, @required this.onAddClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: AvatarView(
              avatarKey: profile.avatarUrl,
              name: profile.name,
              size: 55.0,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                      color: CustomTheme.of(context).textBlackGrayColor,
                      fontFamily: CustomTheme.of(context).boldFontFamily,
                      fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    profile.email,
                    style: TextStyle(
                        color: CustomTheme.of(context).textBlackGrayColor,
                        fontFamily: CustomTheme.of(context).defaultFontFamily,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          if (showAddButton)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CustomButton(
                height: 45,
                width: 45,
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onTap: () {
                  onAddClick(profile);
                },
              ),
            )
        ],
      ),
    );
  }
}
