import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/utilities/http_exceptions.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/widgets/general/custom_circular_progress.dart';
import 'package:shop_app/widgets/general/customized_elevated_button.dart';
import 'package:shop_app/widgets/general/customized_text_button.dart';
import 'package:shop_app/widgets/show_dialog.dart';

enum AuthMode { SignUp, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {'email': '', 'password': ''};

  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _animationController;
  Animation<double> _opacityAnimation;
  Animation _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    /* _heightAnimation = Tween<Size>(
        begin: Size(double.infinity, 260),
        end: Size(double.infinity, 360),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear),
      );*/
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    _loading(true);

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<AuthProvider>(context, listen: false)
            .signIN(_authData['email'], _authData['password']);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on SocketException{
      rethrow;
    }
    on HttpExceptions catch (error) {
      _authDialog(context, error.authHandlerExceptions(error));
    }
    catch (error) {
      const errorMessage = 'Network Error please try later';
      _authDialog(context, errorMessage);
    }
    _loading(false);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
          height: _authMode == AuthMode.SignUp
              ? deviceSize.height * 0.46
              : deviceSize.height * 0.36,
          //height: _heightAnimation.value.height,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.SignUp
                  ? deviceSize.height * 0.44
                  : deviceSize.height * 0.35),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                          maxHeight: _authMode == AuthMode.SignUp
                              ? deviceSize.height * 15
                              : 0),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                              position: _slideAnimation,
                              child: TextFormField(
                                enabled: _authMode == AuthMode.SignUp,
                                decoration: const InputDecoration(
                                    labelText: 'Confirm Password'),
                                obscureText: true,
                                validator: _authMode == AuthMode.SignUp
                                    ? (value) {
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match!';
                                        }
                                        return null;
                                      }
                                    : null,
                              )))),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const CustomCircularProgress()
                  else
                    EditElevatedButton(
                        onPressed: _submit,
                        text:
                            '${_authMode == AuthMode.SignUp ? 'SIGN UP' : 'LOGIN'}',
                        onPrimary: theme.primaryTextTheme.button.color,
                        primary: theme.primaryColor),
                  EditTextButton(
                    onPressed: _switchAuthMode,
                    text:
                        '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'} INSTEAD',
                    onPrimary: theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool _loading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
    return loading;
  }
}

  void _authDialog(BuildContext context, String message) {
  CustomShowDialog.alertDialog(
    message: message,
    title: 'An Error occurred',
    context: context,
    buttonOk: () => Navigator.of(context).pop(true),
    buttonNo: null,
    buttonYes: null,
  );
}
