import 'package:flutter/cupertino.dart';
import 'package:messager/constants.dart';
import 'package:messager/network/rpc/sign_up_rpc.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/sign_in_view/sign_in_view_model.dart';
import 'package:rxdart/rxdart.dart';

class SignUpPresenter {
  final UserScopeData userScope;

  SignUpPresenter(this.userScope);

  BehaviorSubject<SignInViewModel> _viewModelStream =
      BehaviorSubject.seeded(SignInViewModel());
  ValueStream<SignInViewModel> get viewModelStream => _viewModelStream.stream;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  register() async {
    _viewModelStream.add(SignInViewModel(networkOperation: true));
    var email = emailController.text.trim();
    var pass = passController.text.trim();
    var name = nameController.text.trim();
    if (email.isEmpty) {
      _viewModelStream
          .add(SignInViewModel(errorText: 'Email не может быть пустым'));
      return;
    }
    if (!isEmail(email)) {
      _viewModelStream
          .add(SignInViewModel(errorText: 'Введите валидный Email'));
      return;
    }
    if (pass.isEmpty) {
      _viewModelStream
          .add(SignInViewModel(errorText: 'Пароль не может быть пустым'));
      return;
    }
    if (name.isEmpty) {
      _viewModelStream
          .add(SignInViewModel(errorText: 'ФИО не может быть пустым'));
      return;
    }
    if (name.split(' ').length < 3) {
      _viewModelStream.add(SignInViewModel(errorText: 'Введите валидное ФИО'));
      return;
    }

    _handleRegister(email, pass, name);
  }

  _handleRegister(String email, String pass, String name) async {
    var response = await SignUpRpc().signUp(email, pass, name).catchError((e) {
      if (e is SignUpRpcException) {
        _viewModelStream.add(SignInViewModel(errorText: e.message));
      } else {
        _viewModelStream.add(SignInViewModel(errorText: UNKNOWN_ERROR_MESSAGE));
      }
    });
    if (response != null) {
      _viewModelStream.add(SignInViewModel());
      await userScope.setMyProfile(response.profile);
      String token = response.token;
      userScope.setAuthToken(token);
    }
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  dispose() {
    _viewModelStream.close();
  }
}
