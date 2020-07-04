import 'package:test_app_login/models/users_model.dart';
import 'package:test_app_login/screens/login_screen.dart';
import 'package:test_app_login/viewmodel/users_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ActiveUsers extends StatefulWidget {
  Map<String, dynamic> loginFormData;

  ActiveUsers({this.loginFormData});

  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  UsersViewModel _usersViewModel;
  List<UsersDataModel> userInfos;
  bool sortAZ = false;

  @override
  void initState() {
    super.initState();
    if (widget.loginFormData != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        print("Login Datası var");
        UsersViewModel _usersViewModel = context.read<UsersViewModel>();
        _usersViewModel.getUsersData().then((value) => userInfos);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build context çalıştı");
    _usersViewModel = Provider.of<UsersViewModel>(context);
    print("State Durumu:" + _usersViewModel.state.toString());

    userInfos = _usersViewModel.usersData;

    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Active Users List"),
            leading: null,
            actions: [
              IconButton(
                icon: !sortAZ
                    ? Icon(Icons.sort_by_alpha)
                    : Transform(
                        transform: Matrix4.rotationY(math.pi),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.sort_by_alpha,
                        ),
                      ),
                onPressed: () {
                  setState(() {
                    sortAZ = !sortAZ;
                    sortAZ
                        ? _usersViewModel.usersData
                            .sort((a, b) => a.name.compareTo(b.name))
                        : _usersViewModel.usersData =
                            _usersViewModel.usersData.reversed.toList();
                  });
                  print(_usersViewModel.usersData[0].name);
                },
              ),
              SizedBox(
                width: 8,
              ),
              IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: () {
                  _usersViewModel.deleteUserData().then((value) =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen())));
                },
              ),
            ],
          ),
          body: (_usersViewModel.state == UsersDataState.UsersDataLoading ||
                  _usersViewModel.state == UsersDataState.InitialState)
              ? Center(child: CircularProgressIndicator())
              : (_usersViewModel.state == UsersDataState.UsersDataLoaded)
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(userInfos[index].name),
                          subtitle: Text(userInfos[index].email),
                          leading: Icon(Icons.verified_user),
                        );
                      },
                      itemCount: userInfos.length,
                    )
                  : Center(
                      child: Text(
                        "An Error Occured",
                        style: TextStyle(fontSize: 24),
                      ),
                    )),
    );
  }
}