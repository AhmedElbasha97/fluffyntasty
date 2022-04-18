import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/model/Custom/appInfo.dart' as appinfo;
import 'package:fbTrade/services/appInfoService.dart';
import 'package:fbTrade/ui/logIn_screen.dart';
import 'package:fbTrade/ui/signUp_screen.dart';
import 'package:flutter/material.dart';

appinfo.AppInfo? appInfo;
Color mainColor = Color(0xFFFa44088);
Color secondColor = Colors.pink;
appinfo.Theme? selectedThme;

getAppInfo() async {
  appInfo = await AppInfoService().getAppInfo();
  if (appInfo != null) {
    updateMainColor();
  }
}

updateMainColor() {
  mainColor = appInfo!.color!.toColor();
  secondColor = appInfo!.secondColor!.toColor();
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

Future<void> showMysigninDialog(context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                        color: secondColor,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "${AppLocalizations.of(context)!.translate('alret')}",
                              style: TextStyle(color: Colors.white)),
                        ))),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                  "${AppLocalizations.of(context)!.translate('signinMsg')}",
                  textAlign: TextAlign.center,
                )),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(
                      color: mainColor,
                      child: Text(
                        "${AppLocalizations.of(context)!.translate('login')}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LogInScreen(
                            isCheck: false,
                          ),
                        ));
                      },
                    ),
                    FlatButton(
                      color: mainColor,
                      child: Text(
                          "${AppLocalizations.of(context)!.translate('newUser')}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen(
                            isCheck: false,
                          ),
                        ));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
