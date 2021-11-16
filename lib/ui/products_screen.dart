import 'dart:async';
import 'dart:ui';

import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:fbTrade/I10n/AppLanguage.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/model/cart_product.dart';
import 'package:fbTrade/model/product.dart';
import 'package:fbTrade/services/cart_services.dart';
import 'package:fbTrade/services/get_products.dart';
import 'package:fbTrade/ui/logIn_screen.dart';
import 'package:fbTrade/ui/payment_screen.dart';
import 'package:fbTrade/ui/signUp_screen.dart';
import 'package:fbTrade/widgets/GridProductCard.dart';
import 'package:fbTrade/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:map_launcher/map_launcher.dart';

import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  String categoryId;
  String categoryName;
  List<Sub> subCategory;
  String lang;
  String lat;
  String long;
  List<WrokHours> shifts;
  ProductsScreen(this.categoryId, this.categoryName, this.subCategory,
      this.lang, this.shifts, this.lat, this.long);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  List imgList;
  List child;
  int _current = 0;
  int totalPrice = 0;
  bool isAllCheck;
  bool isLoading = true;
  bool isLoadingMoreData = false;
  bool isLoadingAllData = false;
  bool isSearchClicked = false;
  bool cartError = false;
  bool isLinear = true;
  bool certainCategorySelected = false;
  List<ProductModel> productModelList = List<ProductModel>();
  ScrollController _loadMoreDataController;
  int apiPage = 1;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List<String> cart = List<String>();
  List<CartProductModel> cartProductModelList = List<CartProductModel>();
  int totalProductsInCart = 0;
  bool errorSearch = false;
  bool searchFound = false;
  bool isHighestPriceFilterSelected = false;
  bool isLowestPriceFilterSelected = false;
  bool isDiscountFilterSelected = false;
  bool isNewFilterSelected = false;
  bool isLoadingFilter = false;

  TabController tabController;

  openMap() async {
    var availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
        coords: Coords(
          double.parse(widget.lat),
          double.parse(widget.long),
        ),
        title: "${widget.categoryName}");
  }

  getCartProducts() async {
    var productModelList = await CartServices().viewCart(false);
    productModelList.forEach((element) {
      cart.add(element.id);
    });
  }

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  photoSlider() {
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

  Widget popUp() {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: new Text('اللغه'),
      message: new Text('اختر اللغه'),
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
          child: new Text('Arabic'),
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

  getMoreData() async {
    print(apiPage);
    if (apiPage != 0) {
      isLoadingMoreData = true;
      setState(() {});
      print(apiPage);
      apiPage++;
      print(apiPage);
      List<ProductModel> productModelList = List<ProductModel>();
      productModelList =
          await GetProducts().getProducts(widget.categoryId, apiPage);
      if (productModelList.isNotEmpty) {
        this.productModelList.addAll(productModelList);
      } else
        apiPage--;
      isLoadingMoreData = false;
      setState(() {});
    }
  }

  getMoreDataFromCertainCategory() async {
    print(apiPage);
    if (apiPage != 0) {
      isLoadingMoreData = true;
      setState(() {});
      print(apiPage);
      apiPage++;
      print(apiPage);
      List<ProductModel> productModelList = List<ProductModel>();
      productModelList = await GetProducts()
          .getSubCategoryProducts(widget.categoryId, apiPage);
      if (productModelList.isNotEmpty) {
        this.productModelList.addAll(productModelList);
      } else
        apiPage--;
      isLoadingMoreData = false;
      setState(() {});
    }
  }

  getProducts({bool isSwitch = false}) async {
    if (isSwitch) {
      var productModelList =
          await GetProducts().getProducts(widget.categoryId, apiPage);
      print(this.productModelList.length);
      this.productModelList.clear();
      print(this.productModelList.length);
      this.productModelList.addAll(productModelList);
      print(this.productModelList.length);
    } else {
      productModelList =
          await GetProducts().getProducts(widget.categoryId, apiPage);
    }
    print('---------------------');
    print(productModelList.length);
    print('---------------------');
    isLoading = false;
    setState(() {});
  }

  getProductsFromCertainCategory({String subCategory}) async {
    var productModelList =
        await GetProducts().getSubCategoryProducts(subCategory, apiPage);
    print(this.productModelList.length);
    this.productModelList.clear();
    print(this.productModelList.length);
    this.productModelList.addAll(productModelList);
    print(this.productModelList.length);
    print('---------------------');
    print(productModelList.length);
    print('---------------------');
    isLoading = false;
    setState(() {});
  }

  getData() async {
    await getProducts();
    imgList = GetProducts.categoryPhotos ?? List();
    if (imgList != null && imgList.isNotEmpty) photoSlider();
    isLoading = false;
    setState(() {});
  }

  String token;

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    print(token);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${AppLocalizations.of(context).translate('signIn')}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    '${AppLocalizations.of(context).translate('signInErrorMsg')}'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: FlatButton(
                child: Text(
                  '${AppLocalizations.of(context).translate('newUser')}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                      isCheck: true,
                    ),
                  ))
                      .then((value) {
                    checkToken();
                    setState(() {});
                  });
                },
              ),
            ),
            Center(
              child: FlatButton(
                child: Text(
                    '${AppLocalizations.of(context).translate('signIn')}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => LogInScreen(
                      isCheck: true,
                    ),
                  ))
                      .then((value) {
                    checkToken();
                    setState(() {});
                  });
                },
              ),
            ),
            Center(
              child: FlatButton(
                child: Text('${AppLocalizations.of(context).translate('back')}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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

  getCartItems() async {
    cartProductModelList = await CartServices().viewCart(false);
    print('*****************');
    print(cartProductModelList.length);
    print('*****************');
    totalProductsInCart = CartServices.totalQuantity ?? 0;
    totalPrice = CartServices.totalPrice;

    print('********************************');
    print(totalPrice);
    print('********************************');
    setState(() {});
  }

  getSeachedItems() async {
    Response response = await Dio().post(
        "https://fluffyandtasty.com/api/search",
        data: {"keyword": "${searchController.text}"});
    isLoading = true;
    setState(() {});
    if (response.data['status'] == true) {
      searchFound = true;
      productModelList.clear();
      List data = response.data['data'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } else {
      errorSearch = true;
      setState(() {});
    }
    isLoading = false;
    setState(() {});
  }

  getFilterItems(
      {bool isHighestPriceFilterSelected,
      bool isLowestPriceFilterSelected,
      bool isDiscountFilterSelected,
      bool isNewFilterSelected}) async {
    String highestPriceFilter;
    String lowestPriceFilter;
    String discountFilter;
    String newFilter;

    isHighestPriceFilterSelected
        ? highestPriceFilter = "high_price"
        : highestPriceFilter = "";
    isLowestPriceFilterSelected
        ? lowestPriceFilter = "low_price"
        : lowestPriceFilter = "";
    isDiscountFilterSelected
        ? discountFilter = "discount"
        : discountFilter = "";
    isNewFilterSelected ? newFilter = "new" : newFilter = "";

    Response response =
        await Dio().post("https://fluffyandtasty.com/api/search", data: {
      "filter1": "$highestPriceFilter",
      "filter2": "$lowestPriceFilter",
      "filter3": "$discountFilter",
      "filter4": "$newFilter",
    });
    isLoading = true;
    setState(() {});
    if (response.data['status'] == true) {
      searchFound = true;
      productModelList.clear();
      List data = response.data['data'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } else {
      errorSearch = true;
      setState(() {});
    }
    isLoading = false;
    setState(() {});
  }

  Future<void> filterDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('فلتر'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        isHighestPriceFilterSelected =
                            !isHighestPriceFilterSelected;
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color: isHighestPriceFilterSelected
                              ? Colors.blue
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "اعلى سعر",
                          style: TextStyle(
                              color: isHighestPriceFilterSelected
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        isHighestPriceFilterSelected = false;
                        isLowestPriceFilterSelected =
                            !isLowestPriceFilterSelected;
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color: isLowestPriceFilterSelected
                              ? Colors.blue
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "اقل سعر",
                          style: TextStyle(
                              color: isLowestPriceFilterSelected
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        isDiscountFilterSelected = !isDiscountFilterSelected;
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color: isDiscountFilterSelected
                              ? Colors.blue
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "الخصومات",
                          style: TextStyle(
                              color: isDiscountFilterSelected
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        isNewFilterSelected = !isNewFilterSelected;
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color:
                              isNewFilterSelected ? Colors.blue : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "المنتجات الجديده",
                          style: TextStyle(
                              color: isNewFilterSelected
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                isLoadingFilter
                    ? FlatButton(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        onPressed: null,
                      )
                    : FlatButton(
                        child: Text('موافق'),
                        onPressed: () async {
                          isLoadingFilter = true;
                          setState(() {});
                          if (isDiscountFilterSelected ||
                              isHighestPriceFilterSelected ||
                              isLowestPriceFilterSelected ||
                              isNewFilterSelected)
                            await getFilterItems(
                              isDiscountFilterSelected:
                                  isDiscountFilterSelected,
                              isHighestPriceFilterSelected:
                                  isHighestPriceFilterSelected,
                              isLowestPriceFilterSelected:
                                  isLowestPriceFilterSelected,
                              isNewFilterSelected: isNewFilterSelected,
                            );
                          else
                            await getProducts();
                          tabController.animateTo(0);
                          isLoadingFilter = false;
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                FlatButton(
                  child:
                      Text('${AppLocalizations.of(context).translate('back')}'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> tabsList = List();
  String golabalSubCategory;

  initListOfTabs() {
    tabsList.add(InkWell(
      onTap: () async {
        tabController.animateTo(0);
        certainCategorySelected = false;
        apiPage = 1;
        await getProducts(isSwitch: true);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.category,
              color: Colors.white,
            ),
          ),
          Text(
            "${widget.lang == "en" ? "all categories" : "كل الاقسام"}",
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    ));

    for (int i = 0; i < widget.subCategory.length; i++) {
      tabsList.add(InkWell(
        onTap: () async {
          tabController.animateTo(i + 1);
          certainCategorySelected = true;
          apiPage = 1;
          golabalSubCategory = widget.subCategory[i].id;
          await getProductsFromCertainCategory(subCategory: golabalSubCategory);
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("${widget.subCategory[i].picpath}"),
            ),
            Text(
              "${widget.lang == "en" ? widget.subCategory[i].titleen : widget.subCategory[i].titlear}",
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: (widget.subCategory.length + 1), vsync: this);
    getCartItems();
    initListOfTabs();
    _loadMoreDataController = new ScrollController();
    _loadMoreDataController.addListener(() async {
      if (_loadMoreDataController.position.pixels ==
              _loadMoreDataController.position.maxScrollExtent &&
          isAllCheck == false) {
        certainCategorySelected
            ? getMoreDataFromCertainCategory()
            : getMoreData();
      }
    });
    getData();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(
            "${widget.categoryName}",
            style: TextStyle(color: Colors.black, fontFamily: 'tajawal'),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            InkWell(
              onTap: () {
                if (token.isEmpty)
                  _showMyDialog();
                else {
                  isAllCheck = null;
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => CartScreen(
                              shifts: widget.shifts,
                              id: widget.categoryId,
                              name: widget.categoryName)))
                      .whenComplete(() async {
                    isLoadingAllData = true;
                    productModelList.clear();
                    setState(() {});
                    await getCartItems();
                    await getProducts(isSwitch: true);
                    isLoadingAllData = false;
                    setState(() {});
                  });
                }
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 13,
                    child: Text(
                      "$totalProductsInCart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                ],
              ),
            )
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: () => searchFocusNode.unfocus(),
                child: SingleChildScrollView(
                  controller: _loadMoreDataController,
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      child != null && child.isNotEmpty
                          ? CarouselSlider(
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
                            )
                          : Container(),
                      DefaultTabController(
                        length: tabsList.length,
                        child: PreferredSize(
                          preferredSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height * 0.15),
                          child: TabBar(
                            isScrollable: true,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black,
                            controller: tabController,
                            tabs: tabsList,
                          ),
                        ),
                      ),
                      child != null && child.isNotEmpty
                          ? Row(
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
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      // Text(
                      //     "${AppLocalizations.of(context).translate('shifts')}"),
                      // Center(
                      //   child: Container(
                      //     height: 30,
                      //     width: MediaQuery.of(context).size.width,
                      //     child: Center(
                      //       child: ListView.builder(
                      //           primary: false,
                      //           shrinkWrap: true,
                      //           scrollDirection: Axis.horizontal,
                      //           physics: NeverScrollableScrollPhysics(),
                      //           itemCount: widget.shifts.length,
                      //           itemBuilder: (context, index) {
                      //             return Text("${widget.shifts[index].hours}  ",
                      //                 style: TextStyle(fontSize: 15));
                      //           }),
                      //     ),
                      //   ),
                      // ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.black,
                                size: 30,
                              ),
                              onPressed: () {
                                openMap();
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.view_module,
                                color: Colors.black,
                                size: 30,
                              ),
                              onPressed: () async {
                                isLoadingAllData = true;
                                setState(() {});
                                apiPage = 1;
                                certainCategorySelected
                                    ? await getProductsFromCertainCategory(
                                        subCategory: golabalSubCategory)
                                    : await getProducts(isSwitch: true);
                                isLinear = false;
                                isLoadingAllData = false;
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.format_list_bulleted,
                                color: Colors.black,
                                size: 30,
                              ),
                              onPressed: () async {
                                // isLoading=true;
                                // setState(() {});
                                isLoadingAllData = true;
                                setState(() {});
                                apiPage = 1;
                                certainCategorySelected
                                    ? await getProductsFromCertainCategory(
                                        subCategory: golabalSubCategory)
                                    : await getProducts(isSwitch: true);
                                isLinear = true;
                                isLoadingAllData = false;
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.search,
                                color: isSearchClicked
                                    ? Colors.green
                                    : Colors.black,
                                size: 30,
                              ),
                              onPressed: () {
                                isSearchClicked = !isSearchClicked;
                                if (isSearchClicked == false)
                                  errorSearch = false;
                                if (searchFound == true) {
                                  searchFound = false;
                                  productModelList.clear();
                                  getCartItems();
                                  getData();
                                }
                                tabController.animateTo(0);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      errorSearch
                          ? Center(
                              child: Text("no item found"),
                            )
                          : Container(),
                      isSearchClicked
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextField(
                                controller: searchController,
                                focusNode: searchFocusNode,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  getSeachedItems();
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        getSeachedItems();
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        color: searchFocusNode.hasFocus
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    ),
                                    hintText: "search...",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 1)),
                              ),
                            )
                          : Container(),
                      isLoadingAllData
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              50)),
                                  Text(
                                    "جارى التحميل",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 30)),
                                  CircularProgressIndicator(),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              50)),
                                ],
                              ),
                            )
                          : productModelList == null || productModelList.isEmpty
                              ? Center(
                                  child: Text("ليس هناك منتجات متاحه الأن"),
                                )
                              : isLinear
                                  ? ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: productModelList.length,
                                      itemBuilder: (context, index) {
                                        print(token);
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: LinearProductCard(
                                            id: productModelList[index].id,
                                            titleEn:
                                                productModelList[index].titleEn,
                                            titleAr:
                                                productModelList[index].titleAr,
                                            detailsEn: productModelList[index]
                                                .detailsEn,
                                            detailsAr: productModelList[index]
                                                .detailsAr,
                                            price:
                                                productModelList[index].price,
                                            video:
                                                productModelList[index].video ??
                                                    "",
                                            salePrice: productModelList[index]
                                                .salePrice,
                                            isAllChecked: isAllCheck,
                                            totalAmountInCart:
                                                productModelList[index]
                                                    .quantity,
                                            addItemToCart: () {
                                              totalProductsInCart++;
                                              setState(() {});
                                            },
                                            removeItemFromCart: () {
                                              totalProductsInCart--;
                                              setState(() {});
                                              Future.delayed(
                                                  Duration(seconds: 1),
                                                  () async {
                                                await getCartItems();
                                                print(
                                                    '7aaaaaaaaaaaaaaaaaaaaaaaaaa');
                                                setState(() {});
                                              });
                                            },
                                            imgList:
                                                productModelList[index].images,
                                          ),
                                        );
                                      },
                                    )
                                  : GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          1.7)),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: productModelList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: GridProductCard(
                                            id: productModelList[index].id,
                                            titleEn:
                                                productModelList[index].titleEn,
                                            titleAr:
                                                productModelList[index].titleAr,
                                            detailsEn: productModelList[index]
                                                .detailsEn,
                                            detailsAr: productModelList[index]
                                                .detailsAr,
                                            price:
                                                productModelList[index].price,
                                            video:
                                                productModelList[index].video ??
                                                    "",
                                            isAllChecked: isAllCheck,
                                            totalAmount: productModelList[index]
                                                .quantity,
                                            addItemToCart: () {
                                              totalProductsInCart++;
                                              setState(() {});
                                            },
                                            removeItemFromCart: () {
                                              totalProductsInCart--;
                                              setState(() {});
                                            },
                                            imgList:
                                                productModelList[index].images,
                                          ),
                                        );
                                      },
                                    ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      productModelList == null || productModelList.isEmpty
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.black,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${"${AppLocalizations.of(context).translate('totalPrice')}"} : ${totalPrice ?? 0}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      productModelList == null || productModelList.isEmpty
                          ? Container()
                          : GetProducts.offerDialogAr.isEmpty
                              ? Container()
                              : Padding(padding: EdgeInsets.only(top: 20)),
                      productModelList == null || productModelList.isEmpty
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                await checkToken();
                                if (token.isNotEmpty) {
                                  await getCartProducts();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                      shifts: widget.shifts,
                                      id: widget.categoryId,
                                      name: widget.categoryName,
                                    ),
                                  ));
                                } else {
                                  _showMyDialog();
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: mainColor,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${AppLocalizations.of(context).translate('buy')}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      cartError
                          ? Text(
                              "من فضلك اضف منج الى السله",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      isLoadingMoreData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 40)),
                    ],
                  ),
                ),
              ));
  }
}
