import 'package:flutter/material.dart';
import 'package:huy_commerce/Authenticate/AuthenticateScreen.dart';
import 'package:huy_commerce/Service/UserService.dart';

import 'AuthenticateComponent.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';
  String emailErrorText, passwordErrorText = 'Không được để trống';
  bool emailError = false, passwordError = false;
  bool isLoading = false;

  void validateInput() {
    if (email.isEmpty || email == null) {
      setState(() {
        emailError = true;
        emailErrorText = 'Không được để trống';
      });
    } else if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      setState(() {
        emailError = false;
      });
    } else {
      setState(() {
        emailError = true;
        emailErrorText = 'Mời nhập đúng dạng email';
      });
    }

    if (password.isEmpty || password == null) {
      setState(() {
        passwordError = true;
        passwordErrorText = 'Không được để trống';
      });
    } else {
      setState(() {
        passwordError = false;
      });
    }
  }

  Future<void> validateOnServer() async {
    setState(() {
      isLoading = true;
    });
    await UserService.logIn(email, password, errorHandle: (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          emailError = true;
          emailErrorText = 'Email đã không tồn tại';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          passwordError = true;
          passwordErrorText = 'Sai mật khẩu';
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var divider10 = Divider(height: 10, color: Colors.transparent);
    var divider30 = Divider(height: 30, color: Colors.transparent);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: (width / 2 - 150)),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        UserEmail(email: email,function: (String text) {
                          setState(() {
                            email = text;
                          });
                        }),
                        divider10,
                        Visibility(
                          child: Text(
                            emailErrorText ?? '',
                            style: TextStyle(color: Colors.red),
                          ),
                          visible: emailError,
                        ),
                        divider30,
                        UserPassword(password:password,function: (text) {
                          setState(() {
                            password = text;
                          });
                        }),
                        divider10,
                        Visibility(
                          child: Text(
                            passwordErrorText ?? '',
                            style: TextStyle(color: Colors.red),
                          ),
                          visible: passwordError,
                        ),
                        divider30,
                        divider10,
                        FlatButton(
                          height: 50,
                          minWidth: 300,
                          color: Colors.blue[700],
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            validateInput();
                            if (!(emailError || passwordError)) {
                              await validateOnServer();
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        Divider(
                          height: 40,
                          thickness: 2,
                        ),
                        Container(
                          child: FlatButton(
                            color: Color.fromRGBO(54, 164, 32, 1),
                            height: 70,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AuthenticateScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Tạo tài khoản mới',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
