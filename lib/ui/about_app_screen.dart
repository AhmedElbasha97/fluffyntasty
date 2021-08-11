import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {

  String term="";

  getTermTxt() async{
    Response response = await Dio().get("https://fluffyandtasty.com/api/settings");
    term = response.data['about_app'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTermTxt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(
          "${AppLocalizations.of(context).translate('aboutApp')}",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$term"),
          ),
        ),
      ),
    );
  }
}
