import 'package:flutter/material.dart';
import 'package:huy_commerce/Authenticate/AuthenticateComponent.dart';
import 'package:huy_commerce/Service/UserService.dart';

enum AuthState { signIn, signUp, forgetPassword }

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  String email = '', password = '', name = '', gender = 'Nam';
  String emailErrorText,
      passwordErrorText = 'Không được để trống',
      nameErrorText = 'Không được để trống';
  bool emailError = false, passwordError = false, nameError = false;
  bool isLoading = false;
  AuthState authState = AuthState.signIn;

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

    if (name.isEmpty || name == null) {
      setState(() {
        nameError = true;
        nameErrorText = 'Không được để trống';
      });
    } else {
      setState(() {
        nameError = false;
      });
    }
  }

  Future<void> validateSignUp() async {
    await UserService.createUser(email, password, name, gender,
        errorHandle: (e) {
      if (e.code.contains('email'))
        setState(() {
          emailError = true;
          emailErrorText = 'Email không hợp lệ';
        });
      if (e.code.contains('password'))
        setState(() {
          passwordError = true;
          passwordErrorText = e.code;
        });
      if (e.code == 'email-already-in-use') {
        setState(() {
          emailError = true;
          emailErrorText = 'Email đã tồn tại';
        });
      } else if (e.code == 'weak-password') {
        setState(() {
          passwordError = true;
          passwordErrorText = 'Mật khẩu yếu';
        });
      }
    });
  }

  Future<void> validateSignIn() async {
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
  }

  Future<void> validateForgetPassWord() async {
    await UserService.forgetPassword(email);
  }

  Widget signInButton() {
    return Button(
      button: 'Đăng nhập',
      onPressed: () async {
        validateInput();
        if (!(emailError || passwordError)) {
          setState(() {
            isLoading = true;
          });
          await validateSignIn();
          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }

  Widget signUpButton(BuildContext context) {
    return Button(
      button: 'Đăng kí',
      onPressed: () async {
        validateInput();
        if (!(emailError || passwordError || nameError)) {
          setState(() {
            isLoading = true;
          });
          await validateSignUp();
          setState(() {
            isLoading = false;
          });
        }
        if (!(emailError || passwordError || nameError)) {
          setState(() {
            authState = AuthState.signIn;
            name = '';
            emailError = false;
            passwordError = false;
            nameError = false;
          });

          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng ký thành công'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget submitSendNewPasswordButton(BuildContext context) {
    return Button(
      button: 'Gửi mật khẩu',
      onPressed: () async {
        validateInput();
        if (!(emailError)) {
          setState(() {
            isLoading = true;
          });
          validateForgetPassWord();
          setState(() {
            isLoading = false;
            authState = AuthState.signIn;
            password = '';
            emailError = false;
            passwordError = false;
            nameError = false;
          });
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã gửi thông tin đến email của bạn'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget forgetPassword() {
    return ListTile(
      dense: true,
      title: Text(
        'Quên mật khẩu',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () async {
        setState(() {
          authState = AuthState.forgetPassword;
          emailError = false;
          passwordError = false;
          nameError = false;
        });
      },
    );
  }

  Widget hadAccount({String name}) {
    return ListTile(
      dense: true,
      title: Text(
        name ?? 'Đã có tài khoản',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        setState(() {
          authState = AuthState.signIn;
          emailError = false;
          passwordError = false;
          nameError = false;
        });
      },
    );
  }

  Widget createNewAccountButton() {
    return Container(
      child: FlatButton(
        color: Color.fromRGBO(54, 164, 32, 1),
        height: 70,
        onPressed: () {
          setState(() {
            authState = AuthState.signUp;
            name = '';
            gender = 'Nam';
            emailError = false;
            passwordError = false;
            nameError = false;
          });
        },
        child: Text(
          'Tạo tài khoản mới',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget genderSelector(String value) {
    return ListTile(
      title: Text(value),
      leading: Radio(
        value: value,
        groupValue: gender,
        onChanged: (val) {
          setState(() {
            gender = val;
          });
        },
      ),
    );
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
          body: Builder(
            builder: (context) => Padding(
              padding: EdgeInsets.symmetric(horizontal: (width / 2 - 150)),
              child: Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          UserEmail(
                            email: email,
                            function: (String text) {
                              setState(() {
                                email = text.trim();
                              });
                            },
                          ),
                          divider10,
                          Visibility(
                            child: Text(
                              emailErrorText ?? '',
                              style: TextStyle(color: Colors.red),
                            ),
                            visible: emailError,
                          ),
                          Visibility(
                            visible: authState == AuthState.signUp ||
                                authState == AuthState.signIn,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                divider30,
                                UserPassword(
                                  password: password,
                                  function: (text) {
                                    setState(() {
                                      password = text.trim();
                                    });
                                  },
                                ),
                                divider10,
                                Visibility(
                                  child: Text(
                                    passwordErrorText ?? '',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  visible: passwordError,
                                ),
                                Visibility(
                                  visible: authState == AuthState.signUp,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      divider30,
                                      UserName(
                                        name: name,
                                        function: (text) {
                                          setState(() {
                                            name = text.trim();
                                          });
                                        },
                                      ),
                                      divider10,
                                      Visibility(
                                        child: Text(
                                          nameErrorText ?? '',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        visible: nameError,
                                      ),
                                      genderSelector('Nam'),
                                      genderSelector('Nữ'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          divider30,
                          divider10,
                          authState == AuthState.signIn
                              ? Column(
                                  children: [
                                    signInButton(),
                                    forgetPassword(),
                                    Divider(
                                      height: 40,
                                      thickness: 2,
                                    ),
                                    createNewAccountButton(),
                                  ],
                                )
                              : authState == AuthState.signUp
                                  ? Column(
                                      children: [
                                        signUpButton(context),
                                        hadAccount(),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        submitSendNewPasswordButton(context),
                                        hadAccount(name: 'Quay lại đăng nhập'),
                                      ],
                                    ),
                          FlatButton(
                              onPressed: () => print(gender), child: Text('a')),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String button;
  final Function onPressed;

  const Button({Key key, this.button, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: 50,
      minWidth: 300,
      color: Colors.blue[700],
      child: Text(
        button,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
}
