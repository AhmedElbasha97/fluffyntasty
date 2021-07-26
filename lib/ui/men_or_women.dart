import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fbTrade/services/get_photo_slider.dart';
import 'package:flutter/material.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/model/main_model.dart';
import 'package:fbTrade/services/get_categories.dart';
import 'home_screen.dart';

class MenOrWomen extends StatefulWidget {
  MenOrWomen();
  @override
  _MenOrWomenState createState() => _MenOrWomenState();
}

class _MenOrWomenState extends State<MenOrWomen> {
  List<MainCategory> list = new List();
  List imgList;
  List child;
  int _current = 0;

  getPhotoSlider() async {
    imgList = await GetPhotoSlider().getPhotoSlider();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  photoSlider() async {
    await getPhotoSlider();
    print(imgList.first);
    child = map<Widget>(
      imgList,
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
    ).toList();
  }

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getMainCategories();
  }

  getMainCategories() async {
    list = await GetCategories().getMainCategory();
    await photoSlider();
    isLoading = false;
    setState(() {});
  }

  bool isItMen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFa44088),
        iconTheme: new IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Image.asset(
          "assets/icon/appBarLogo.png",
          scale: 30,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : list.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "${AppLocalizations.of(context).translate('noCats')}"),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CarouselSlider(
                        items: child,
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
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen(id: list[index].mainCategoryId),
                              ));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image.network(
                                  Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? "${list[index].picpathEn}"
                                      : "${list[index].picpath}"),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
    );
  }
}
