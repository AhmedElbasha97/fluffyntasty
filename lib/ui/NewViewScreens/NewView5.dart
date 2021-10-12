import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:fbTrade/ui/home_screen.dart';
import 'package:fbTrade/ui/productDetails.dart';
import 'package:flutter/material.dart';

class NewViewScreen5 extends StatefulWidget {
  List<HomeCategory> list = [];

  NewViewScreen5({this.list});

  @override
  _NewViewScreen5State createState() => _NewViewScreen5State();
}

class _NewViewScreen5State extends State<NewViewScreen5> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(id: widget.list[index].id),
              ));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl:
                          Localizations.localeOf(context).languageCode == "en"
                              ? "${widget.list[index].picpathEn}"
                              : "${widget.list[index].picpath}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: widget.list[index].products.length,
                    itemBuilder: (BuildContext context, int index2) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductsDetails(
                                  product: widget.list[index].products[index2]),
                            ));
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xFFFa44088),
                                    backgroundImage: NetworkImage(
                                      "${widget.list[index].products[index2].images.isEmpty ? "" : widget.list[index].products[index2].images.first}",
                                    )),
                              ),
                              Text(
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? "${widget.list[index].products[index2].titleEn}"
                                    : "${widget.list[index].products[index2].titleAr}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
