import 'package:fbTrade/model/Custom/appInfo.dart' as appinfo;
import 'package:fbTrade/services/appInfoService.dart';
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
