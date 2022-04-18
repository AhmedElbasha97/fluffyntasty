import 'package:fbTrade/model/Custom/favoratieProduct.dart';
import 'package:flutter/material.dart';
import 'package:fbTrade/global.dart';


class FavorateProductScreen extends StatefulWidget {
  @override
  _FavorateProductScreenState createState() => _FavorateProductScreenState();
}

class _FavorateProductScreenState extends State<FavorateProductScreen> {
  List<FavProduct>? list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    list = await getProducts().getNotification();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                backgroundColor: mainColor,

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                        Localizations.localeOf(context).languageCode == "en"
                            ? "${list![index].titleEn}"
                            : "${list![index].titleAr}"),
                    trailing: list![index].photos!.isEmpty
                        ? Icon(Icons.shop)
                        : Image.network("${list![index].photos!.first}"),
                  ),
                );
              },
            ),
    );
  }
}
