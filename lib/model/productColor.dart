class ProductColor {
  ProductColor({
    this.colorId,
    this.titlear,
    this.titleen,
    this.code,
  });

  String? colorId;
  String? titlear;
  String? titleen;
  String? code;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        colorId: json["color_id"] == null ? null : json["color_id"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        code: json["code"] == null ? null : json["code"],
      );
}
