import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/services/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  bool isCheck;

  LogInScreen({this.isCheck = false});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool phoneError = false;
  bool passwordError = false;
  bool isServerLoading = false;

  validation(BuildContext context) async {
    if (phoneController.text.isEmpty)
      phoneError = true;
    else
      phoneError = false;
    if (passwordController.text.isEmpty)
      passwordError = true;
    else
      passwordError = false;

    setState(() {});

    if (!phoneError && !passwordError) {
      isServerLoading = true;
      setState(() {});
      String response = await LoginService().loginService(
        phone: phoneController.text,
        password: passwordController.text,
      );
      if (response == 'success') {
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
      } else {
        final snackBar = SnackBar(content: Text('$response'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
        Scaffold.of(context).showSnackBar(snackBar);
      }
      isServerLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          title: Text(
            "${AppLocalizations.of(context).translate('login')}",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 100)),
                  appInfo.logo == null || appInfo.logo == ""
                      ? Image.asset(
                          "assets/icon/logo.png",
                          scale: 3,
                        )
                      : CachedNetworkImage(
                          imageUrl: "${appInfo.logo}",
                          fit: BoxFit.scaleDown,
                        ),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 100)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText:
                                  "${AppLocalizations.of(context).translate('phoneNumber')}"),
                        ),
                      ),
                      phoneError
                          ? Text(
                              "please enter your phone",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText:
                                  "${AppLocalizations.of(context).translate('password')}"),
                        ),
                      ),
                      passwordError
                          ? Text(
                              "please enter your password",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      isServerLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : InkWell(
                              onTap: () => validation(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.green),
                                child: Text(
                                    "${AppLocalizations.of(context).translate('login')}",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
