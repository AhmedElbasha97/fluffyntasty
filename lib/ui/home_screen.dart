import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/widgets/product_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/model/category.dart';
import 'package:fbTrade/model/product.dart';
import 'package:fbTrade/services/cart_services.dart';
import 'package:fbTrade/services/get_all_products.dart';
import 'package:fbTrade/services/get_categories.dart';
import 'package:fbTrade/services/get_photo_slider.dart';
import 'package:fbTrade/ui/signUp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'logIn_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? id;
  HomeScreen({this.id});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isLoadingMoreData = false;

  int _current = 0;
  int apiPage = 1;
  int totalProductsInCart = 0;

  late List imgList;
  List? child;
  List? photoSliderList;
  List<CategoryModel> categoryModelList = [];
  List<ProductModel> productModelList = [];
  List<String> cart = [];
  late Position position;

  String? name;
  String? token;
  String? whatsappUrl;

  ScrollController? _loadMoreDataController;
  bool isLocationActive = false;
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();

  getTotalNumberProductsInCart() async {
    await CartServices().viewCart(false);
    totalProductsInCart = CartServices.totalQuantity ?? 0;
    if (mounted) setState(() {});
  }

  getCategoriesByLocation(double lat, double long) async {
    categoryModelList.clear();
    categoryModelList =
        await GetCategories().getCategoryByLocation(lat, long, widget.id);
    isLoading = false;
    setState(() {});
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await getCategoriesByLocation(position.latitude, position.longitude);
  }

  getAllProducts() async {
    isLoading = true;
    setState(() {});
    productModelList.clear();
    productModelList =
        await (GetAllProducts().getProductsbyCategory(apiPage, token, widget.id) as FutureOr<List<ProductModel>>);
    print('******************************************');
    print(token);
    print('---');
    for (int i = 0; i < productModelList.length; i++) {
      print(i);
      print(productModelList[i].quantity);
      print('--------');
    }
    print('******************************************');
    isLoading = false;
    setState(() {});
  }

  getMoreData() async {
    print(apiPage);
    if (apiPage != 0) {
      isLoadingMoreData = true;
      setState(() {});
      print(apiPage);
      apiPage++;
      print(apiPage);
      List<ProductModel> productModelList = [];
      productModelList = await (GetAllProducts().getAllProducts(apiPage, token!) as FutureOr<List<ProductModel>>);
      if (productModelList.isNotEmpty) {
        this.productModelList.addAll(productModelList);
      } else
        apiPage--;
      isLoadingMoreData = false;
      setState(() {});
    }
  }

  getSocialMediaLinks() async {
    Response response =
        await Dio().get("https://fluffyandtasty.com/api/settings");

    whatsappUrl = response.data['whatsapp'];
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ??
        "${AppLocalizations.of(context)!.translate('newUser')}";
    token = prefs.getString('token') ?? "";
    return prefs;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تسجيل الدخول'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('قم بتسجيل الدخول لتتمكن من إتمام عملية الشراء.'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: FlatButton(
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LogInScreen(
                      isCheck: false,
                    ),
                  ));
                },
              ),
            ),
            Center(
              child: FlatButton(
                child: Text('مستخدم جديد',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                      isCheck: false,
                    ),
                  ));
                },
              ),
            ),
            Center(
              child: FlatButton(
                child:
                    Text('رجوع', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getSocialMediaLinks();
    getTotalNumberProductsInCart();
    _loadMoreDataController = new ScrollController();
    _loadMoreDataController!.addListener(() async {
      if (_loadMoreDataController!.position.pixels ==
          _loadMoreDataController!.position.maxScrollExtent) {
        getMoreData();
      }
    });
    photoSlider();
  }

  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  getPhotoSlider() async {
    imgList = await GetPhotoSlider().getPhotoSlider();
  }

  photoSlider() async {
    await getPhotoSlider();
    await getUserData();
    await getAllProducts();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: mainColor,
        iconTheme: new IconThemeData(color: Colors.white),
        title: appInfo!.logo == null || appInfo!.logo == ""
            ? Image.asset(
                "assets/icon/appBarLogo.png",
                scale: 30,
              )
            : Container(
                color: Colors.white,
                height: 50,
                width: 50,
                child: CachedNetworkImage(
                  imageUrl: "${appInfo!.logo}",
                  fit: BoxFit.scaleDown,
                ),
              ),
        actions: [
          InkWell(
            onTap: () => _launchURL("$whatsappUrl"),
            child: Image.asset(
              "assets/icon/whatsapp.png",
              scale: 2.0,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: _loadMoreDataController,
              child: Column(
                children: <Widget>[
                  CarouselSlider(
                    items: child as List<Widget>?,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(
                      imgList,
                      (index, url) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Color(0xFF0D986A)
                                  : Color(0xFFD8D8D8)),
                        );
                      },
                    ) as List<Widget>,
                  ),
                  productModelList.isEmpty
                      ? Center(
                          child: Text(
                              "${AppLocalizations.of(context)!.translate('noProducts')}"),
                        )
                      : ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: productModelList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: LinearProductCard(
                                id: productModelList[index].id,
                                titleEn: productModelList[index].titleEn,
                                titleAr: productModelList[index].titleAr,
                                detailsEn: productModelList[index].detailsEn,
                                detailsAr: productModelList[index].detailsAr,
                                price: productModelList[index].price,
                                video: productModelList[index].video ?? "",
                                totalAmountInCart:
                                    productModelList[index].quantity,
                                salePrice: productModelList[index].salePrice,
                                addItemToCart: () async {
                                  if (token == "") {
                                    _showMyDialog();
                                  } else {
                                    totalProductsInCart++;
                                    setState(() {});
                                  }
                                },
                                removeItemFromCart: () async {
                                  if (token == "") {
                                    _showMyDialog();
                                  } else {
                                    totalProductsInCart--;
                                    setState(() {});
                                  }
                                },
                                imgList: productModelList[index].images,
                                image: productModelList[index].images!.isEmpty
                                    ? ""
                                    : productModelList[index].images!.first,
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
