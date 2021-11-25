import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fbTrade/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/services/cart_services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LinearProductCard extends StatefulWidget {
  String id;
  Function addItemToCart;
  Function removeItemFromCart;
  List imgList;
  String image;
  String detailsEn;
  String detailsAr;
  bool isAllChecked;
  String titleAr;
  String titleEn;
  String price;
  String salePrice;
  String video;
  int totalAmountInCart;
  String totalAmount;

  LinearProductCard(
      {this.id,
      this.image = "",
      this.salePrice,
      this.totalAmount,
      this.totalAmountInCart,
      this.removeItemFromCart,
      this.addItemToCart,
      this.imgList,
      this.isAllChecked,
      this.titleEn,
      this.titleAr,
      this.price,
      this.video,
      this.detailsEn,
      this.detailsAr});

  @override
  _LinearProductCardState createState() => _LinearProductCardState();
}

class _LinearProductCardState extends State<LinearProductCard> {
  int totalAmount;
  List child;
  int _current = 0;
  bool checkBoxValue;
  YoutubePlayerController _controller;
  bool isLoadingVideo = false;

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  photoSlider() {
    child = map<Widget>(
      widget.imgList,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Image.network(
              i,
              fit: BoxFit.fitHeight,
              width: 1000.0,
              height: 450,
            ),
          ),
        );
      },
    ).toList();
  }

  moreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      if (widget.video.isNotEmpty) _controller.pause();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ),
                child.isNotEmpty
                    ? CarouselSlider(
                        items: child,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                              print('in the slider $_current');
                            });
                          },
                        ),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                widget.video.isNotEmpty
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
                          ),
                        ),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  "${Localizations.localeOf(context).languageCode == "en" ? widget.titleEn : widget.titleAr}",
                  style:
                      TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.topRight,
                    child: Html(
                      data:
                          "${Localizations.localeOf(context).languageCode == "en" ? widget.detailsEn : widget.detailsAr}",
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  photoViewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: 300,
          height: 400,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.imgList.isEmpty
                      ? widget.image
                      : widget.imgList.first,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  addItemToCart() async {
    CartServices().addToCart(widget.id);
  }

  decreaseItemFromCart(int newQuantity) async {
    await CartServices().decreaseFromCart(widget.id, newQuantity);
  }

  removeItemFromCart() async {
    await CartServices().removeFromCart(widget.id);
  }

  @override
  void initState() {
    super.initState();
    if (widget.video.isNotEmpty)
      _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId("${widget.video}"),
          flags: YoutubePlayerFlags(
            autoPlay: true,
          ));

    if (widget.imgList.isNotEmpty) photoSlider();

    if (widget.totalAmount == null || widget.totalAmount.isEmpty) {
      totalAmount = widget.totalAmountInCart;
    } else {
      totalAmount = int.parse(widget.totalAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.19,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      "${Localizations.localeOf(context).languageCode == "en" ? widget.titleEn : widget.titleAr}",
                      style: TextStyle(
                          fontSize: 18,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.black)),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: totalAmount == 0
                                ? InkWell(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String token =
                                          prefs.getString('token') ?? "";

                                      if (token == "") {
                                        showMysigninDialog(context);
                                      } else {
                                        widget.addItemToCart();
                                        addItemToCart();
                                        totalAmount++;
                                        setState(() {});
                                      }
                                    },
                                    child: Text(
                                      "Add +",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          widget.addItemToCart();
                                          addItemToCart();
                                          totalAmount++;
                                          print(widget.totalAmount);
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "+",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        color: mainColor,
                                        child: Text(
                                          "${totalAmount ?? 0}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (totalAmount > 0) {
                                            widget.removeItemFromCart();
                                            totalAmount--;
                                            decreaseItemFromCart(totalAmount);
                                            if (totalAmount == 0) {
                                              removeItemFromCart();
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          alignment: Alignment.center,
                                          child: Text("-",
                                              style: TextStyle(fontSize: 25)),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.black)),
                              child: double.parse(widget.salePrice) == 0
                                  ? Text(
                                      "${widget.price} .Qr",
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          fontSize: 14, color: mainColor),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(" Qr.",
                                              style: TextStyle(fontSize: 13)),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Text(
                                                "${widget.price}",
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                              Positioned(
                                                bottom: 3,
                                                child: Text(
                                                  "_____________",
                                                  style: TextStyle(
                                                      color: mainColor),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            "${widget.salePrice} ",
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    )),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            "assets/icon/cart.png",
                            scale: 19,
                            color: Colors.black,
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          InkWell(
                            onTap: () {
                              if (_controller == null) {
                                isLoadingVideo = true;
                                setState(() {});
                                Future.delayed(Duration(seconds: 2), () {
                                  isLoadingVideo = false;
                                  setState(() {});
                                  moreDialog();
                                });
                              } else {
                                moreDialog();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.black)),
                              child: Text(
                                  "${AppLocalizations.of(context).translate('more')}",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => photoViewDialog(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.145,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.black)),
                margin: EdgeInsets.only(left: 10),
                child: CachedNetworkImage(
                  imageUrl: widget.image.isEmpty
                      ? "${widget.imgList.first}"
                      : "${widget.image}",
                  placeholder: (context, url) => SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
