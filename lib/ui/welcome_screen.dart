import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/ui/home_screen.dart';
import 'package:fbTrade/ui/signUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logIn_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String welcomeText = "";
  bool isLoading = true;

  getWelcomeTxt() async {
    Response response =
        await Dio().get("https://fluffyandtasty.com/api/settings");
    welcomeText = response.data['welcome'];
    setState(() {});
  }

  String token;
  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    if (token.isNotEmpty) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    }
    isLoading = false;
    setState(() {});
  }

  getData() async {
    await getWelcomeTxt();
    await checkToken();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(),
            )),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.topRight,
              child: Text(
                "${AppLocalizations.of(context).translate('skip')}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: <Widget>[
                  appInfo.logo == null || appInfo.logo == ""
                      ? Image.asset(
                          "assets/icon/logo.png",
                          scale: 2,
                        )
                      : CachedNetworkImage(
                          imageUrl: "${appInfo.logo}",
                          fit: BoxFit.scaleDown,
                        ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    child: Text("$welcomeText"),
                  )
                ],
              )),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LogInScreen(),
                      )),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Colors.white),
                            color: Colors.white),
                        child: Text(
                          "${AppLocalizations.of(context).translate('login')}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen())),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Colors.white),
                            color: Colors.white),
                        child: Text(
                            "${AppLocalizations.of(context).translate('signUp')}",
                            style: TextStyle(color: Colors.black)),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}
