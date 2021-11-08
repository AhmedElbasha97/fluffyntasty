class ProductSize {
  ProductSize({
    this.sizeId,
    this.titlear,
    this.titleen,
  });

  String sizeId;
  String titlear;
  String titleen;

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
        sizeId: json["size_id"] == null ? null : json["size_id"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
      );
}
