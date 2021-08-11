import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fbTrade/I10n/AppLanguage.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/model/category.dart';
import 'package:fbTrade/model/product.dart';
import 'package:fbTrade/services/cart_services.dart';
import 'package:fbTrade/services/get_all_products.dart';
import 'package:fbTrade/services/get_categories.dart';
import 'package:fbTrade/services/get_photo_slider.dart';
import 'package:fbTrade/ui/products_screen.dart';
import 'package:fbTrade/ui/signUp_screen.dart';
import 'package:fbTrade/ui/terms_screen.dart';
import 'package:fbTrade/ui/welcome_screen.dart';
import 'package:fbTrade/widgets/home_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../splash_screen.dart';
import 'about_app_screen.dart';
import 'contact_us_screen.dart';
import 'edit_profile_screen.dart';
import 'logIn_screen.dart';
import 'myProducts_screen.dart';

class HomeScreen extends StatefulWidget {
  String id;
  HomeScreen({this.id});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isLoadingMoreData = false;
  bool isSearchClicked = false;

  int _current = 0;
  int apiPage = 1;
  int totalProductsInCart = 0;

  List imgList;
  List child;
  List photoSliderList;
  List<CategoryModel> categoryModelList = List<CategoryModel>();
  List<ProductModel> productModelList = List<ProductModel>();
  List<String> cart = List<String>();
  Position position;

  String name;
  String token;
  String facebookUrl;
  String whatsappUrl;
  String instagramUrl;
  String youtubeUrl;
  String twitterUrl;

  ScrollController _loadMoreDataController;
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
    position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await getCategoriesByLocation(position.latitude, position.longitude);
  }

  Widget changeLangPopUp() {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: new Text('${AppLocalizations.of(context).translate('language')}'),
      message: new Text(
          '${AppLocalizations.of(context).translate('changeLanguage')}'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: new Text('English'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("en"));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: new Text('عربى'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("ar"));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text('رجوع'),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }

  getCategories() async {
    categoryModelList = await GetCategories().getCategory(widget.id);
    print(categoryModelList.length);
    isLoading = false;
    setState(() {});
  }

  searchCategories() async {
    isLoading = true;
    setState(() {});
    categoryModelList =
        await GetCategories().searchCategory(searchController.text);
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
      List<ProductModel> productModelList = List<ProductModel>();
      productModelList = await GetAllProducts().getAllProducts(apiPage, token);
      if (productModelList.isNotEmpty) {
        this.productModelList.addAll(productModelList);
      } else
        apiPage--;
      isLoadingMoreData = false;
      setState(() {});
    }
  }

  getSocialMediaLinks() async {
    Response response = await Dio().get("https://fluffyandtasty.com/api/settings");
    facebookUrl = response.data['facebook'];
    twitterUrl = response.data['twitter'];
    youtubeUrl = response.data['youtube'];
    whatsappUrl = response.data['whatsapp'];
    instagramUrl = response.data['instagram'];
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ??
        "${AppLocalizations.of(context).translate('newUser')}";
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
    _loadMoreDataController.addListener(() async {
      if (_loadMoreDataController.position.pixels ==
          _loadMoreDataController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    photoSlider();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
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
    await getCategories();
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
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
            SizedBox(
              height: 150,
              child: Container(
                child: Image.asset(
                  "assets/icon/logo.png",
                  scale: 3,
                ),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
            token == null || token.isEmpty
                ? ListTile(
                    title: Text(
                      "$name",
                      style: TextStyle(
                          color: Color(0xFFFa44088),
                          fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () {
                      if (token.isEmpty)
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                    })
                : Container(),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            token == null || token.isEmpty
                ? ListTile(
                    title: Text(
                      "${AppLocalizations.of(context).translate('login')}",
                      style: TextStyle(
                          color: Color(0xFFFa44088),
                          fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LogInScreen(),
                      ));
                    },
                  )
                : ListTile(
                    title: Text(
                        "${AppLocalizations.of(context).translate('editProfile')}",
                        style: TextStyle(
                            color: Color(0xFFFa44088),
                            fontWeight: FontWeight.bold)),
                    leading: Icon(
                      Icons.edit,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () async {
                      bool done =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ));
                      getUserData();
                    },
                  ),
            token == null || token.isEmpty
                ? Container()
                : Divider(
                    height: 1,
                    thickness: 2,
                    endIndent: 30,
                    indent: 30,
                  ),
            token == null || token.isEmpty
                ? Container()
                : ListTile(
                    title: Text(
                        "${AppLocalizations.of(context).translate('myProducts')}",
                        style: TextStyle(
                            color: Color(0xFFFa44088),
                            fontWeight: FontWeight.bold)),
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () async {
                      bool done =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyProductsScreen(),
                      ));
                      getUserData();
                    },
                  ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('home')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.home,
                color: Color(0xFFFa44088),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ));
              },
            ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text(
                  "${AppLocalizations.of(context).translate('changeLang')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.language,
                color: Color(0xFFFa44088),
              ),
              onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => changeLangPopUp()),
            ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('terms')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.description,
                color: Color(0xFFFa44088),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TermsScreen(),
              )),
            ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text(
                  "${AppLocalizations.of(context).translate('whoAreWe')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.category,
                color: Color(0xFFFa44088),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutAppScreen(),
              )),
            ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            token == null || token.isEmpty
                ? Container()
                : ListTile(
                    title: Text(
                        "${AppLocalizations.of(context).translate('signOut')}",
                        style: TextStyle(
                            color: Color(0xFFFa44088),
                            fontWeight: FontWeight.bold)),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SplashScreen(),
                      ));
                    },
                  ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('callUs')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.phone,
                color: Color(0xFFFa44088),
              ),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactUsScreen(),
                ));
              },
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                InkWell(
                  onTap: () => _launchURL("$facebookUrl"),
                  child: Image.asset(
                    "assets/icon/facebook.png",
                    scale: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () => _launchURL("$instagramUrl"),
                  child: Image.asset(
                    "assets/icon/instagram.png",
                    scale: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () => _launchURL("$twitterUrl"),
                  child: Image.asset(
                    "assets/icon/twitter.png",
                    scale: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () => _launchURL("$youtubeUrl"),
                  child: Image.asset(
                    "assets/icon/snapchat.png",
                    scale: 1.5,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${AppLocalizations.of(context).translate('policy1')}",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text("${AppLocalizations.of(context).translate('policy2')}",
                      style: TextStyle(fontSize: 16)),
                  InkWell(
                    onTap: () => _launchURL("https://www.syncqatar.com/"),
                    child: Text(
                      "سينك",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFFa44088),
        iconTheme: new IconThemeData(color: Colors.white),
        title: Image.asset(
          "assets/icon/appBarLogo.png",
          scale: 30,
        ),
        actions: [
          InkWell(
            onTap: () => _launchURL("$whatsappUrl"),
            child: Image.asset(
              "assets/icon/whatsapp.png",
              scale: 2.0,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: isSearchClicked ? Colors.green : Colors.white,
              size: 30,
            ),
            onPressed: () {
              isSearchClicked = !isSearchClicked;
              setState(() {});
            },
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
                  isSearchClicked
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              searchCategories();
                            },
                            onChanged: (value) {
                              if (searchController.text.isEmpty) {
                                isLoading = true;
                                setState(() {});
                                getCategories();
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    searchCategories();
                                  },
                                  icon: Icon(Icons.search, color: Colors.black),
                                ),
                                hintText: "search...",
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 1)),
                          ),
                        )
                      : Container(),
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
                    ),
                  ),
                  categoryModelList.isEmpty
                      ? Center(
                          child: Text(
                              "${AppLocalizations.of(context).translate('noCats')}"),
                        )
                      : GridView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: categoryModelList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => ProductsScreen(
                                        categoryModelList[index].id,
                                        Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? categoryModelList[index].titleEn
                                            : categoryModelList[index].titleAr,
                                        categoryModelList[index].sub,
                                        Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? "en"
                                            : "ar",
                                        categoryModelList[index].wrokHours,
                                        categoryModelList[index].lat,
                                        categoryModelList[index].long),
                                  ))
                                      .whenComplete(() async {
                                    await getTotalNumberProductsInCart();
                                  }),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: HomeCard(
                                        subCategory:
                                            categoryModelList[index].sub,
                                        title: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? categoryModelList[index].titleEn
                                            : categoryModelList[index].titleAr,
                                        image: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? categoryModelList[index].picpathEn
                                            : categoryModelList[index].picpath,
                                        facebookUrl:
                                            categoryModelList[index].facebook,
                                        instagramUrl:
                                            categoryModelList[index].insgram,
                                        whatsappUrl:
                                            categoryModelList[index].whatsapp,
                                        snapChatUrl:
                                            categoryModelList[index].snapchat,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                    "${Localizations.localeOf(context).languageCode == 'en' ? categoryModelList[index].titleEn : categoryModelList[index].titleAr}")
                              ],
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.7)),
                        )
                ],
              ),
            ),
    );
  }
}
