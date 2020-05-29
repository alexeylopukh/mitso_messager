import 'package:flutter/cupertino.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/news_screen/news_view_model.dart';
import 'package:rxdart/rxdart.dart';

class NewsScreenPresenter {
  final UserScopeData userScope;
  NewsScreenPresenter({@required this.userScope}) {
    userScope.socketInteractor.newsModels.listen((value) {
      _viewModelStream.add(NewsViewModel(news: List.from(value.reversed)));
    });
  }

  BehaviorSubject<NewsViewModel> _viewModelStream = BehaviorSubject.seeded(NewsViewModel(news: []));
  ValueStream<NewsViewModel> get viewModelStream => _viewModelStream.stream;

  dispose() {
    _viewModelStream.close();
  }
}
