import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fbTrade/model/product.dart';
import 'package:flutter/material.dart';
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
  YoutubePlayerController _controller;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
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
        backgroundColor: Color(0xFFFa44088),
        child: Center(
          child: Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
          ),
        ),
        onPressed: () {},
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFFa44088),
        iconTheme: new IconThemeData(color: Colors.white),
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
              : Container()
        ],
      ),
    );
  }
}
