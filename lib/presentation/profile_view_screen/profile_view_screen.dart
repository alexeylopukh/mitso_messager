import 'package:flutter/material.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/components/avatar_view.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/di/custom_theme.dart';

class ProfileViewScreen extends StatefulWidget {
  final Profile profile;

  const ProfileViewScreen({Key key, @required this.profile}) : super(key: key);

  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  Profile get profile => widget.profile;

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.top + MediaQuery.of(context).padding.top),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: AvatarView(
              size: MediaQuery.of(context).size.width - 100,
              avatarKey: profile.avatarUrl,
              name: profile.name),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            profile.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CustomTheme.of(context).textBlackGrayColor,
                fontFamily: CustomTheme.of(context).boldFontFamily,
                fontSize: 24),
          ),
        ),
        Container(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                height: 56,
                width: 100,
                child: Text(
                  'Личное сообщение',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onTap: () {}),
            Container(
              width: 10,
            ),
            CustomButton(
                height: 56,
                width: 100,
                child: Text(
                  'Позвонить',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onTap: () {}),
          ],
        ),
        Spacer(),
      ],
    ));
  }
}
