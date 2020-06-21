import 'package:flutter/material.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/components/popups.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/sign_in_view/sign_in_view_model.dart';
import 'package:messager/presentation/sign_up_view/sign_up_presenter.dart';

class SignUpView extends StatefulWidget {
  final Function onChangePage;

  const SignUpView({Key key, @required this.onChangePage}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  SignUpPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    if (_presenter == null) _presenter = SignUpPresenter(UserScopeWidget.of(context));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<SignInViewModel>(
          stream: _presenter.viewModelStream,
          builder: (context, snapshot) {
            SignInViewModel viewModel = _presenter.viewModelStream.value;
            if (viewModel.errorText != null) {
              showErrorDialog(viewModel.errorText);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
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
                TextFormField(
                  controller: _presenter.nameController,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: "ФИО",
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
                          'Создать аккаунт',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: CustomTheme.of(context).boldFontFamily),
                        ),
                  height: 50,
                  width: double.infinity,
                  onTap: () {
                    if (!viewModel.networkOperation) {
                      _presenter.register();
                    }
                  },
                ),
                Container(
                  height: 20,
                ),
                Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.onChangePage,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Уже есть аккаунт?',
                        style: TextStyle(color: CustomTheme.of(context).grayColor),
                      ),
                      Container(
                        height: 3,
                      ),
                      Text('Войти',
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
    });
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
}
