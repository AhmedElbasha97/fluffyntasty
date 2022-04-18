import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:fbTrade/global.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String? term = "";

  getTermTxt() async {
    Response response =
        await Dio().get("https://fluffyandtasty.com/api/settings");
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
        backgroundColor: mainColor,
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(
          "${AppLocalizations.of(context)!.translate('aboutApp')}",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Html(data: "$term"),
      ),
    );
  }
}
