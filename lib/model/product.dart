class ProductModel{
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

  ProductModel(
      {this.id, this.quantity, this.titleAr, this.titleEn, this.price, this.images, this.video, this.salePrice, this.detailsAr, this.detailsEn,});

  factory ProductModel.fromJson(Map<String, dynamic> parsedJson) {

    return ProductModel(
      id: parsedJson['id'],
      titleAr: parsedJson['title_ar'],
      titleEn: parsedJson['title_en'],
      images: parsedJson['photos'],
      price: parsedJson['price'],
      video:  parsedJson['youtube1'].contains("http")? parsedJson['youtube1']:"",
      salePrice: parsedJson['sale'],
      detailsAr: parsedJson['details_ar'],
      detailsEn: parsedJson['details_en'],
      quantity: parsedJson['in_mycart'],
      //subCategory: subCategoryList
    );
  }
}
