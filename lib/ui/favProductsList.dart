import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/Custom/favoratieProduct.dart';
import 'package:fbTrade/services/get_products.dart';
import 'package:flutter/material.dart';

class FavProductsScreen extends StatefulWidget {
  @override
  _FavProductsScreenState createState() => _FavProductsScreenState();
}

class _FavProductsScreenState extends State<FavProductsScreen> {
  List<FavProduct> products = [];
  bool isLoading = true;

  getFav() async {
    products = await GetProducts().getFavProducts();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text(
              Localizations.localeOf(context).languageCode == "en"
                  ? products[index].titleEn
                  : products[index].titleAr,
            ),
            trailing: Container(
              height: 50,
              width: 50,
              child: Image.network(products[index].photos.isEmpty
                  ? ""
                  : products[index].photos.first),
            ),
          );
        },
      ),
    );
  }
}
