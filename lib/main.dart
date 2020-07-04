import 'package:test_app_login/screens/active_users_screen.dart';
import 'package:test_app_login/screens/login_screen.dart';
import 'package:test_app_login/viewmodel/users_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/locator.dart';

void main() {
  setupLocator();
  runApp(ChangeNotifierProvider(
    create: (context) => locator<UsersViewModel>(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  UsersViewModel _userViewModel;

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UsersViewModel>(context, listen: false);
    // print(_userViewModel.alreadyLogin);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
          future: _userViewModel.getLoginData(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) =>
              (snapshot.hasData && snapshot.data.isNotEmpty)
                  ? ActiveUsers(loginFormData: snapshot.data)
                  : (snapshot.hasData && snapshot.data.isEmpty)
                      ? LoginScreen()
                      : Scaffold()),
      //Login durumunu kontrol için aşağıdaki Futurbuilder da sorunsuz çalışıyor
      //Yukarıda ise sharedprefte map olarak saklanan loginDatası ActiveUsers
      //sayfasına dio isteğinde kullanılabilmesi için
/*         FutureBuilder(
        future: _userViewModel.checkLoginDataExist(),
        builder: (context, AsyncSnapshot<bool> snapshot) =>
            (snapshot.hasData && snapshot.data == true)
                ? ActiveUsers()
                : (snapshot.hasData && snapshot.data == false)
                    ? LoginScreen()
                    : Scaffold(),
      ), */
    );
  }
}
