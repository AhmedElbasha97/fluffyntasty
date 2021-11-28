import 'package:fbTrade/model/Custom/appInfo.dart' as appinfo;
import 'package:fbTrade/services/appInfoService.dart';
import 'package:fbTrade/ui/logIn_screen.dart';
import 'package:fbTrade/ui/signUp_screen.dart';
import 'package:flutter/material.dart';

appinfo.AppInfo appInfo;
Color mainColor = Color(0xFFFa44088);
appinfo.Theme selectedThme;

getAppInfo() async {
  appInfo = await AppInfoService().getAppInfo();
  if (appInfo != null) {
    updateMainColor();
  }
}

updateMainColor() {
  mainColor = appInfo.color.toColor();
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
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                  color: mainColor,
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Center(
                      child: Text('تسجيل الدخول',
                          style: TextStyle(color: Colors.white)))),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Text(
                'قم بتسجيل الدخول لتتمكن من دخول الصفحة.',
                textAlign: TextAlign.center,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: mainColor,
                    child: Text(
                      'تسجيل الدخول',
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
                    child: Text('مستخدم جديد',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpScreen(
                          isCheck: false,
                        ),
                      ));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
