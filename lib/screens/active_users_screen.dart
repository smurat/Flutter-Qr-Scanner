import 'package:flutter/cupertino.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:test_app_login/models/users_model.dart';
import 'package:test_app_login/screens/login_screen.dart';
import 'package:test_app_login/viewmodel/barcode_scan.dart';
import 'package:test_app_login/viewmodel/users_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'barcode_scan_camera/scan_camera_dialog.dart';

class ActiveUsers extends StatefulWidget {
  Map<String, dynamic> loginFormData;
  ActiveUsers({this.loginFormData});

  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  List<UsersDataModel> userInfos;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.loginFormData != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        print("Login Datası var");
        UsersViewModel _usersViewModel = context.read<UsersViewModel>();
        _usersViewModel.getUsersData().then((value) => userInfos = value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Consumer2<UsersViewModel, BarcodeScan>(
          builder: (context, viewModel, barcode, child) {
        print("Build context çalıştı");
        print("State Durumu:" + viewModel.state.toString());
        userInfos = viewModel.usersData;

        _displaySnackBar(BuildContext context) {
          final snackBar = SnackBar(
            content: Text(
              'Barcode bulunamadı',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Active Users List"),
            leading: null,
            actions: [
              IconButton(
                icon: !viewModel.sortList
                    ? Icon(Icons.sort_by_alpha)
                    : Transform(
                        transform: Matrix4.rotationY(math.pi),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.sort_by_alpha,
                        ),
                      ),
                onPressed: () {
                  viewModel.sortUsers();
                  // viewModel.sortList = !viewModel.sortList;
                  print(viewModel.usersData[0].name);
                },
              ),
              SizedBox(
                width: 8,
              ),
              IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: () {
                  viewModel.deleteUserData().then((value) =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen())));
                },
              ),
            ],
          ),
          body: HawkFabMenu(
            blur: 2.5,
            items: [
              HawkFabMenuItem(
                label: 'Scan with Camera',
                ontap: () async {
                  final res = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RScanCameraDialog()));
                  if (res != null) {
                    barcodeDialog(context, barcode);
                  }
                },
                icon: Icon(Icons.camera_alt),
              ),
              HawkFabMenuItem(
                label: 'Scan From Gallery',
                ontap: () {
                  barcode.imgPickAndScan().then((value) {
                    if (barcode?.result != null) {
                      barcodeDialog(context, barcode);
                    } else if (barcode.result == null && barcode.imgPicked) {
                      _displaySnackBar(context);
                    }
                  });
                },
                icon: Icon(Icons.image),
              ),
            ],
            body: (viewModel.state == UsersDataState.UsersDataLoading ||
                    viewModel.state == UsersDataState.InitialState)
                ? Center(child: CircularProgressIndicator())
                : (viewModel.state == UsersDataState.UsersDataLoaded)
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 125),
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.all(6.0),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 16.0),
                                            child: Icon(Icons.account_circle),
                                          ),
                                          Text(
                                            "User Details",
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(
                                                  "Name : ${userInfos[index].name}"),
                                              Text(
                                                  "Phone : ${userInfos[index].phone}"),
                                              Text(
                                                  "Age : ${userInfos[index].age}"),
                                              Text(
                                                  "Adress : ${userInfos[index].address}"),
                                              Text(
                                                  "Company : ${userInfos[index].company}"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          child: Text('CLOSE'),
                                          onPressed: Navigator.of(context).pop,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
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
                      ),
          ),
        );
      }),
    );
  }

  Future barcodeDialog(BuildContext context, BarcodeScan barcode) {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 125),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(6.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.code),
                ),
                Text(
                  "Barcode Scan Result",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("Barcode : ${barcode.result.message} "),
                  ],
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text('CLOSE'),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          ),
        );
      },
    );
  }
}
