import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Authenticate/AuthenticateComponent.dart';
import 'package:huy_commerce/Service/UserService.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String oldPassword = '';
  String repeatPassword = '';
  String newPassword = '';
  bool hasError = false;
  String error = 'Fail to change password';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Change password'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: UserPassword(
                  password: '',
                  function: (val) {
                    setState(() {
                      oldPassword = val;
                      hasError = false;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: UserPassword(
                  password: '',
                  function: (val) {
                    setState(() {
                      newPassword = val;
                      hasError = false;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: UserPassword(
                  password: '',
                  function: (val) {
                    setState(() {
                      repeatPassword = val;
                      hasError = false;
                    });
                  },
                ),
              ),
              Visibility(
                visible: hasError,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed:
                    newPassword == repeatPassword && newPassword.isNotEmpty
                        ? () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => Center(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                            await UserService.changePassword(
                              oldPassword,
                              newPassword,
                              errorHandle: (e) {
                                setState(() {
                                  hasError = true;
                                  error = e.message;
                                });
                              },
                            ).then((value) {
                              Navigator.of(context).pop();
                              if (!hasError) Navigator.of(context).pop();
                            });
                          }
                        : null,
                child: Container(
                  child: Text('Submit change'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
