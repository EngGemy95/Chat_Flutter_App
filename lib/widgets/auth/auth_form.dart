import 'dart:io';

import 'package:chat_app/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.isLoading, this.submitFormFunc, {Key? key}) : super(key: key);

  final isLoading;

  final Function(
      String username,
      String email,
      String password,
      File? userImage,
      bool isLogin,
      BuildContext ctx,
      Function(bool isSignedUp)) submitFormFunc;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _password = '';
  File? _userImageFile;

  bool _isLogin = true;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select an image!'),
          duration: Duration(seconds: 3),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();

      widget.submitFormFunc(_userName.trim(), _userEmail.trim(),
          _password.trim(), _userImageFile, _isLogin, context, _restartPage);
      // print(_userName);
      // print(_userEmail);
      // print(_password);
    }
  }

  void _prepareUserImage(File? imageFile) {
    _userImageFile = imageFile;
  }

  void _restartPage(bool _finishedSignup) {
    if (_finishedSignup) {
      setState(() {
        _isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(_prepareUserImage),
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('email'),
                      onSaved: (newValue) {
                        _userEmail = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter valid email !';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        //   borderSide:
                        //       BorderSide(color: Theme.of(context).primaryColor),
                        // ),
                        label: Text(
                          'Email Address',
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (!_isLogin)
                      TextFormField(
                        autocorrect: true,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.words,
                        key: ValueKey('userName'),
                        onSaved: (newValue) {
                          _userName = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter user name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                          label: Text(
                            'User Name',
                            style: TextStyle(color: Colors.pink),
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    TextFormField(
                      key: ValueKey('password'),
                      onSaved: (newValue) {
                        _password = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 7) {
                          return 'Please must be at least 6 characters!';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        label: Text(
                          'Password',
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                      ),
                    TextButton(
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            widget.isLoading
                                ? Colors.grey
                                : Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
