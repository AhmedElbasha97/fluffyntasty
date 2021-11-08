import 'package:fbTrade/model/productColor.dart';

import '../product.dart';

class HomeCategory {
  HomeCategory(
      {this.id,
      this.mainCategory,
      this.sub,
      this.wrokHours,
      this.products,
      this.titleAr,
      this.titleEn,
      this.lat,
      this.long,
      this.facebook,
      this.insgram,
      this.youtube,
      this.whatsapp,
      this.snapchat,
      this.detailsAr,
      this.detailsEn,
      this.refmainCategory,
      this.picpath,
      this.picpathEn,});

  String id;
  List<MainCategory> mainCategory;
  List<Sub> sub;
  List<WrokHour> wrokHours;
  List<ProductModel> products;
  String titleAr;
  String titleEn;
  String lat;
  String long;
  String facebook;
  String insgram;
  String youtube;
  String whatsapp;
  String snapchat;
  String detailsAr;
  String detailsEn;
  String refmainCategory;
  String picpath;
  String picpathEn;

  factory HomeCategory.fromJson(Map<String, dynamic> json) => HomeCategory(
      id: json["id"] == null ? null : json["id"],
      mainCategory: json["main_category"] == null
          ? null
          : List<MainCategory>.from(
              json["main_category"].map((x) => MainCategory.fromJson(x))),
      sub: json["sub"] == null
          ? null
          : List<Sub>.from(json["sub"].map((x) => Sub.fromJson(x))),
      wrokHours: json["wrok_hours"] == null
          ? null
          : List<WrokHour>.from(
              json["wrok_hours"].map((x) => WrokHour.fromJson(x))),
      products: json["products"] == null
          ? null
          : List<ProductModel>.from(
              json["products"].map((x) => ProductModel.fromJson(x))),
      titleAr: json["title_ar"] == null ? null : json["title_ar"],
      titleEn: json["title_en"] == null ? null : json["title_en"],
      lat: json["lat"] == null ? null : json["lat"],
      long: json["long"] == null ? null : json["long"],
      facebook: json["facebook"] == null ? null : json["facebook"],
      insgram: json["insgram"] == null ? null : json["insgram"],
      youtube: json["youtube"] == null ? null : json["youtube"],
      whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
      snapchat: json["snapchat"] == null ? null : json["snapchat"],
      detailsAr: json["details_ar"] == null ? null : json["details_ar"],
      detailsEn: json["details_en"] == null ? null : json["details_en"],
      refmainCategory:
          json["refmain_category"] == null ? null : json["refmain_category"],
      picpath: json["picpath"] == null ? null : json["picpath"],
      picpathEn: json["picpath_en"] == null ? null : json["picpath_en"],
     );
              
}

class MainCategory {
  MainCategory({
    this.titlear,
    this.titleen,
  });

  String titlear;
  String titleen;

  factory MainCategory.fromJson(Map<String, dynamic> json) => MainCategory(
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
      );
}

class Sub {
  Sub({
    this.id,
    this.titlear,
    this.titleen,
    this.picpath,
  });

  String id;
  String titlear;
  String titleen;
  String picpath;

  factory Sub.fromJson(Map<String, dynamic> json) => Sub(
        id: json["id"] == null ? null : json["id"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        picpath: json["picpath"] == null ? null : json["picpath"],
      );
}

class WrokHour {
  WrokHour({
    this.workHoursId,
    this.titlear,
    this.titleen,
    this.hours,
  });

  String workHoursId;
  String titlear;
  String titleen;
  String hours;

  factory WrokHour.fromJson(Map<String, dynamic> json) => WrokHour(
        workHoursId:
            json["work_hours_id"] == null ? null : json["work_hours_id"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        hours: json["hours"] == null ? null : json["hours"],
      );
}
