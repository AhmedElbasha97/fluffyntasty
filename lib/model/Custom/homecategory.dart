import 'package:fbTrade/model/product.dart';

class HomeCategory {
  HomeCategory({
    this.mainCategoryId,
    this.sub,
    this.products,
    this.slider,
    this.titlear,
    this.titleen,
    this.picpath,
    this.picpathEn,
  });

  String mainCategoryId;
  List<Sub> sub;
  List<ProductModel> products;
  List<String> slider;
  String titlear;
  String titleen;
  String picpath;
  String picpathEn;

  factory HomeCategory.fromJson(Map<String, dynamic> json) => HomeCategory(
        mainCategoryId:
            json["main_category_id"] == null ? null : json["main_category_id"],
        sub: json["sub"] == null
            ? null
            : List<Sub>.from(json["sub"].map((x) => Sub.fromJson(x))),
        products: json["products"] == null
            ? null
            : List<ProductModel>.from(
                json["products"].map((x) => ProductModel.fromJson(x))),
        slider: json["slider"] == null
            ? null
            : List<String>.from(json["slider"].map((x) => x)),
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        picpath: json["picpath"] == null ? null : json["picpath"],
        picpathEn: json["picpath_en"] == null ? null : json["picpath_en"],
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
