import 'package:dio/dio.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {

  String term="";

  getTermTxt() async{
    Response response = await Dio().get("https://fluffyandtasty.com/api/settings");
    term = response.data['terms'];
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
        backgroundColor: Colors.black,
        title: Text(
          "${AppLocalizations.of(context).translate('terms')}",
          style: TextStyle(color: Colors.white),
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
