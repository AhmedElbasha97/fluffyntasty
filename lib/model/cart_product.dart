class CartProductModel {
  String id;
  String titleAr;
  String titleEn;
  String price;
  String quantity;
  int quantityInCart;
  String salePrice;
  String image;
  String categoryAr;
  String categoryEn;

  CartProductModel(
      {this.id,
      this.titleAr,
      this.titleEn,
      this.quantityInCart,
      this.price,
      this.image,
      this.salePrice,
      this.categoryAr,
      this.categoryEn,
      this.quantity});

  factory CartProductModel.fromJson(Map<String, dynamic> parsedJson) {

    return CartProductModel(
      id: parsedJson['product_id'],
      titleAr: parsedJson['titlear'],
      titleEn: parsedJson['titleen'],
      image: parsedJson['image'],
      price: parsedJson['price'],
      salePrice: parsedJson['sale'],
      categoryAr: parsedJson['categoryar'],
      categoryEn: parsedJson['categoryen'],
      quantity: parsedJson['quantity'],
      quantityInCart: parsedJson['in_mycart'],

    );
  }
}

