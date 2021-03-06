import 'package:flutter/material.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/components/popups.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/sign_in_view/sign_in_presenter.dart';

import 'sign_in_view_model.dart';

class SignInView extends StatefulWidget {
  final Function onChangePage;

  const SignInView({Key key, @required this.onChangePage}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  SignInPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    if (_presenter == null) _presenter = SignInPresenter(UserScopeWidget.of(context));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<SignInViewModel>(
          stream: _presenter.viewModelStream,
          builder: (context, snapshot) {
            var viewModel = _presenter.viewModelStream.valueWrapper.value;
            if (viewModel.errorText != null) {
              showErrorDialog(viewModel.errorText);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  height: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 40,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Вход',
                    style: TextStyle(
                        fontSize: 28,
                        color: CustomTheme.of(context).textBlackColor,
                        fontFamily: CustomTheme.of(context).boldFontFamily),
                  ),
                ),
                TextFormField(
                  controller: _presenter.emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                Container(
                  height: 20,
                ),
                TextFormField(
                  controller: _presenter.passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Пароль",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                Container(
                  height: 20,
                ),
                CustomButton(
                  child: viewModel.networkOperation
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.0,
                        )
                      : Text(
                          'Войти',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: CustomTheme.of(context).boldFontFamily),
                        ),
                  height: 50,
                  width: double.infinity,
                  onTap: () {
                    if (!viewModel.networkOperation) {
                      _presenter.login();
                    }
                  },
                ),
                Container(
                  height: 40,
                ),
                Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (!viewModel.networkOperation) {
                      widget.onChangePage();
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Нужен аккаунт?',
                        style: TextStyle(color: CustomTheme.of(context).grayColor),
                      ),
                      Container(
                        height: 3,
                      ),
                      Text('Зарегистрировать',
                          style: TextStyle(
                              color: CustomTheme.of(context).grayColor,
                              decoration: TextDecoration.underline))
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  showErrorDialog(String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Popups.showModalDialog(context, PopupState.OK, title: 'Ошибка', description: text);
      _presenter.viewModelStream.valueWrapper.value.errorText = null;
    });
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
}
