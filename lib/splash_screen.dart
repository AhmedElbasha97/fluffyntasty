import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/ui/men_or_women.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'I10n/AppLanguage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: appInfo == null ||
                            appInfo.logo == null ||
                            appInfo.logo == ""
                        ? AssetImage("assets/icon/logo.png")
                        : CachedNetworkImageProvider("${appInfo.logo}"),
                    fit: BoxFit.scaleDown,
                  ),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    appLanguage.changeLanguage(Locale("en"));
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MenOrWomen(),
                    ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: mainColor),
                        color: mainColor),
                    child: Text("English",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  )),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  appLanguage.changeLanguage(Locale("ar"));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MenOrWomen(),
                  ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: mainColor),
                      color: mainColor),
                  child: Text("عربي",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ));
  }
}
