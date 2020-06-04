import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/create_news_screen/create_news_screen.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/news_screen/news_view_model.dart';
import 'package:messager/presentation/news_screen/widgets/news_fab.dart';
import 'package:messager/presentation/news_screen/widgets/news_item_widget.dart';

import 'news_screen_presenter.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsScreenPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    if (_presenter == null) {
      _presenter = NewsScreenPresenter(userScope: UserScopeWidget.of(context));
    }
    return GeneralScaffold(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              navBar(),
              Expanded(
                child: StreamBuilder<NewsViewModel>(
                  stream: _presenter.viewModelStream,
                  builder: (context, snapshot) {
                    NewsViewModel vm = snapshot.data;
                    if (vm?.news == null)
                      return Container();
                    else
                      return ListView.builder(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  MediaQuery.of(context).padding.bottom +
                                  55),
                          itemCount: vm?.news?.length,
                          itemBuilder: (context, index) {
                            return NewsItemWidget(
                              newsModel: vm.news[index],
                            );
                          });
                  },
                ),
              )
            ],
          ),
          if (UserScopeWidget.of(context).myProfile.permissionsLevel > 0)
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 78, right: 20),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: NewsFab(
                      onTab: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => CreateNewsScreen()));
                      },
                    )))
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
                      'Новости',
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

  @override
  void dispose() {
    super.dispose();
  }
}
