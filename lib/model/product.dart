import 'package:fbTrade/model/productColor.dart';
import 'package:fbTrade/model/productSize.dart';

class ProductModel {
  String id;
  String titleAr;
  String titleEn;
  String price;
  String salePrice;
  String video;
  List images;
  String detailsAr;
  String detailsEn;
  int quantity;
  List<ProductColor> color;
  List<ProductSize> size;

  ProductModel(
      {this.id,
      this.quantity,
      this.titleAr,
      this.titleEn,
      this.price,
      this.images,
      this.video,
      this.salePrice,
      this.detailsAr,
      this.detailsEn,
      this.color,
      this.size});

  factory ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    return ProductModel(
        id: parsedJson['id'],
        titleAr: parsedJson['title_ar'],
        titleEn: parsedJson['title_en'],
        images: parsedJson['photos'],
        price: parsedJson['price'],
        video: parsedJson['youtube1'].contains("http")
            ? parsedJson['youtube1']
            : "",
        salePrice: parsedJson['sale'],
        detailsAr: parsedJson['details_ar'],
        detailsEn: parsedJson['details_en'],
        quantity: parsedJson['in_mycart'],
        color: parsedJson["colors"] == null
            ? null
            : List<ProductColor>.from(
                parsedJson["colors"].map((x) => ProductColor.fromJson(x))),
        size: parsedJson["sizes"] == null
            ? null
            : List<ProductSize>.from(
                parsedJson["sizes"].map((x) => ProductSize.fromJson(x))));
  }
}
