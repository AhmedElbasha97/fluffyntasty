class FavProduct {
  FavProduct({
    this.productId,
    this.photos,
    this.inMycart,
    this.colors,
    this.sizes,
    this.titleAr,
    this.titleEn,
    this.price,
    this.sale,
    this.youtube1,
    this.category,
    this.refcategory,
    this.detailsAr,
    this.detailsEn,
  });

  String? productId;
  List<String>? photos;
  int? inMycart;
  List<Color>? colors;
  List<dynamic>? sizes;
  String? titleAr;
  String? titleEn;
  String? price;
  String? sale;
  String? youtube1;
  String? category;
  String? refcategory;
  String? detailsAr;
  String? detailsEn;

  factory FavProduct.fromJson(Map<String, dynamic> json) => FavProduct(
        productId: json["product_id"] == null ? null : json["product_id"],
        photos: json["photos"] == null
            ? null
            : List<String>.from(json["photos"].map((x) => x)),
        inMycart: json["in_mycart"] == null ? null : json["in_mycart"],
        colors: json["colors"] == null
            ? null
            : List<Color>.from(json["colors"].map((x) => Color.fromJson(x))),
        sizes: json["sizes"] == null
            ? null
            : List<dynamic>.from(json["sizes"].map((x) => x)),
        titleAr: json["title_ar"] == null ? null : json["title_ar"],
        titleEn: json["title_en"] == null ? null : json["title_en"],
        price: json["price"] == null ? null : json["price"],
        sale: json["sale"] == null ? null : json["sale"],
        youtube1: json["youtube1"] == null ? null : json["youtube1"],
        category: json["category"] == null ? null : json["category"],
        refcategory: json["refcategory"] == null ? null : json["refcategory"],
        detailsAr: json["details_ar"] == null ? null : json["details_ar"],
        detailsEn: json["details_en"] == null ? null : json["details_en"],
      );
}

class Color {
  Color({
    this.colorId,
    this.titlear,
    this.titleen,
    this.code,
  });

  String? colorId;
  String? titlear;
  String? titleen;
  String? code;

  factory Color.fromJson(Map<String, dynamic> json) => Color(
        colorId: json["color_id"] == null ? null : json["color_id"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        code: json["code"] == null ? null : json["code"],
      );
}


