import 'package:flutter/material.dart';

class UserEmail extends StatefulWidget {
  final String email;
  final Function(String val) function;

  const UserEmail({Key key, this.function, this.email = ''}) : super(key: key);

  @override
  _UserEmailState createState() => _UserEmailState();
}

class _UserEmailState extends State<UserEmail> {
  var error = false;
  var errorText = 'Mời nhập đúng dạng email';
  var textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.email;
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _color = Theme.of(context).primaryColor;
    var _border = OutlineInputBorder(
      borderSide: BorderSide(color: _color, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
    return Container(
      width: 300,
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          labelText: 'Email',
          border: InputBorder.none,
          focusedBorder: _border,
          enabledBorder: _border,
          disabledBorder: _border,
          errorBorder: _border,
          focusedErrorBorder: _border,
          hintText: 'Email',
          // errorText: errorText
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (text) => widget.function(text),
      ),
    );
  }
}

class UserPassword extends StatefulWidget {
  final Function(String val) function;
  final String password;

  const UserPassword({Key key, this.function, this.password = ''})
      : super(key: key);

  @override
  _UserPasswordState createState() => _UserPasswordState();
}

class _UserPasswordState extends State<UserPassword> {
  var error = false;
  var visible = false;
  var textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.password;
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _color = Theme.of(context).primaryColor;
    var _border = OutlineInputBorder(
      borderSide: BorderSide(color: _color, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
    return Container(
      width: 300,
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          labelText: 'Mật khẩu',
          border: _border,
          focusedBorder: _border,
          enabledBorder: _border,
          disabledBorder: _border,
          suffixIcon: IconButton(
            icon: visible
                ? Icon(Icons.remove_red_eye_rounded)
                : Icon(Icons.remove_red_eye_outlined),
            onPressed: () {
              setState(() {
                visible = !visible;
              });
            },
          ),
          hintText: 'Mật khẩu',
        ),
        keyboardType: TextInputType.text,
        obscureText: !visible,
        onChanged: (text) => widget.function(text),
      ),
    );
  }
}

class UserName extends StatefulWidget {
  final Function(String val) function;
  final String name;
  final bool hasLabelText;

  const UserName({Key key, this.function, this.name, this.hasLabelText = true})
      : super(key: key);

  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  var textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.name;
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _color = Theme.of(context).primaryColor;
    var _border = OutlineInputBorder(
      borderSide: BorderSide(color: _color, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
    return Container(
      width: 300,
      child: TextField(
        style: TextStyle(
          fontSize: 20,
        ),
        controller: textController,
        decoration: InputDecoration(
          labelText: widget.hasLabelText?'Họ và tên':null,
          border: _border,
          focusedBorder: _border,
          enabledBorder: _border,
          disabledBorder: _border,
          hintText: 'Họ và tên',
        ),
        keyboardType: TextInputType.text,
        onChanged: (text) => widget.function(text),
      ),
    );
  }
}
