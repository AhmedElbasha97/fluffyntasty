class OrdersModel{
  String? id;
  String? orderNumber;
  String? status;
  String? date;
  String? photo;
  String? name;
  String? totalPrice;
  List<ProductsModel>? products;

  OrdersModel({this.status, this.date, this.photo, this.name, this.id, this.orderNumber, this.products, this.totalPrice});


  factory OrdersModel.fromJson(Map<String,dynamic> parsedJson){

    var list = parsedJson['products'] as List;
    List<ProductsModel> productsModelList = list.map((value) => ProductsModel.fromJson(value)).toList();

    return OrdersModel(
      name: parsedJson['category_title_ar'],
      photo: parsedJson['image_category'],
      date: parsedJson['created'],
      status: parsedJson['status'],
      orderNumber: parsedJson['no'],
      totalPrice: parsedJson['total'],
      products: productsModelList,
    );
  }
}

class ProductsModel{
  String? id;
  String? price;
  String? titleAr;
  String? titleEn;
  String? photo;

  ProductsModel({this.id, this.price, this.titleAr, this.titleEn, this.photo});

  factory ProductsModel.fromJson(Map<String,dynamic> parsedJson){
    return ProductsModel(
      id: parsedJson['id'],
      price: parsedJson['price'],
      titleAr: parsedJson['title_ar'],
      titleEn: parsedJson['title_en'],
      photo: parsedJson['image'],
    );
  }

}