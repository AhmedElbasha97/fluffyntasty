import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/product.dart';
import 'package:fbTrade/services/cart_services.dart';
import 'package:fbTrade/services/get_products.dart';
import 'package:fbTrade/ui/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductsDetails extends StatefulWidget {
  ProductModel product;
  ProductsDetails({this.product});
  @override
  _ProductsDetailsState createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  int _current = 0;
  String selectedColorId;
  String selectedSizeId;
  String name;
  String token;
  YoutubePlayerController _controller;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  addItemToCart() async {
    CartServices()
        .addToCart(widget.product.id, selectedColorId, selectedSizeId);
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    token = prefs.getString('token') ?? "";
    return prefs;
  }

  @override
  void initState() {
    super.initState();
    if (widget.product.video.isNotEmpty)
      _controller = YoutubePlayerController(
          initialVideoId:
              YoutubePlayer.convertUrlToId("${widget.product.video}"),
          flags: YoutubePlayerFlags(
            autoPlay: true,
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: Center(
          child: Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          if (token == null || token == "") {
            showMysigninDialog(context);
          } else {
            addItemToCart();
            final snackBar = SnackBar(
              content: Text(
                  "${AppLocalizations.of(context).translate('addedToCart')}"),
              action: SnackBarAction(
                label: "${AppLocalizations.of(context).translate('gotoCart')}",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ));
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: mainColor,
        iconTheme: new IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () async {
                String response =
                    await GetProducts().addToFav(widget.product.id);
                final snackBar = SnackBar(content: Text('$response'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(Icons.favorite))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CarouselSlider(
            items: map<Widget>(
              widget.product.images,
              (index, i) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: CachedNetworkImage(
                      imageUrl: i,
                      fit: BoxFit.cover,
                      width: 1000.0,
                      placeholder: (context, url) => SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Localizations.localeOf(context).languageCode == "en"
                  ? "${widget.product.titleEn}"
                  : "${widget.product.titleAr}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Html(
            data: Localizations.localeOf(context).languageCode == "en"
                ? "${widget.product.detailsEn}"
                : "${widget.product.detailsAr}",
          ),
          widget.product.video.isNotEmpty
              ? InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: SizedBox(
                      height: 200,
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        aspectRatio: 16 / 9,
                      )))
              : Container(),
          widget.product.color == null || widget.product.color.isEmpty
              ? Container()
              : Container(
                  width: 100,
                  height: (widget.product.color.length * 70.0),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.product.color.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(
                          Localizations.localeOf(context).languageCode == "en"
                              ? widget.product.color[index].titleen
                              : widget.product.color[index].titlear,
                        ),
                        activeColor: mainColor,
                        checkColor: mainColor,
                        selected: widget.product.color[index].colorId ==
                            selectedColorId,
                        value: widget.product.color[index].colorId ==
                            selectedColorId,
                        onChanged: (bool value) {
                          selectedColorId = widget.product.color[index].colorId;
                        },
                      );
                    },
                  ),
                ),
          widget.product.size == null || widget.product.size.isEmpty
              ? Container()
              : Container(
                  width: 100,
                  height: (widget.product.color.length * 70.0),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.product.size.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(
                          Localizations.localeOf(context).languageCode == "en"
                              ? widget.product.size[index].titleen
                              : widget.product.size[index].titlear,
                        ),
                        activeColor: mainColor,
                        checkColor: mainColor,
                        selected:
                            widget.product.size[index].sizeId == selectedSizeId,
                        value:
                            widget.product.size[index].sizeId == selectedSizeId,
                        onChanged: (bool value) {
                          selectedSizeId = widget.product.size[index].sizeId;
                        },
                      );
                    },
                  ),
                ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
