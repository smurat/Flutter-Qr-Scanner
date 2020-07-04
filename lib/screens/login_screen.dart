import 'package:test_app_login/helpers/form_validators.dart';
import 'package:test_app_login/screens/create_new_account.dart';
import 'package:test_app_login/screens/forgot_password.dart';
import 'package:test_app_login/viewmodel/users_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'active_users_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  UsersViewModel _userViewModel;
  String email, password;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UsersViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        "assets/fuse.png",
                      ),
                    ),
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.montserrat(
                        color: Color(0xFF2236a6),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sign to continue",
                      style: GoogleFonts.montserrat(
                        color: Colors.grey.withAlpha(150),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                          controller: _emailController,
                          maxLines: null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.mail),
                            hintText: 'Type your e-mail adress',
                            labelText: 'EMAIL',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                          validator: emailKontrol,
                          onSaved: (girilen) => email = girilen),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText: 'Type your password',
                          labelText: 'PASSWORD',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        validator: sifreKontrol,
                        onSaved: (girilen) => password = girilen,
                      ),
                      FlatButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => ForgotPassword()));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    color: Color(0xff173db8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _userViewModel.state ==
                              UsersDataState.UsersDataLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        await _userViewModel.getUsersData();
                        _userViewModel
                            .saveUser(email: email, password: password)
                            .then(
                              (sendData) =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => ActiveUsers(),
                                ),
                              ),
                            );
                        // bool value = await _userViewModel.checkLoginDataExist();
                        // print("kayıtlı kullanıcı : $value");
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' create a new account',
                                style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                      builder: (context) => CreateNewAccount(),
                                    ));
                                  })
                          ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
