// import 'dart:async';
// import 'dart:ui';

// import 'package:fbTrade/global.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dio/dio.dart';
// import 'package:fbTrade/I10n/app_localizations.dart';
// import 'package:fbTrade/model/Custom/homecategory.dart' as home;
// import 'package:fbTrade/model/cart_product.dart';
// import 'package:fbTrade/model/product.dart';
// import 'package:fbTrade/services/cart_services.dart';
// import 'package:fbTrade/services/get_products.dart';
// import 'package:fbTrade/ui/logIn_screen.dart';
// import 'package:fbTrade/ui/payment_screen.dart';
// import 'package:fbTrade/ui/signUp_screen.dart';
// import 'package:fbTrade/widgets/GridProductCard.dart';
// import 'package:fbTrade/widgets/product_card.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:map_launcher/map_launcher.dart';

// import 'cart_screen.dart';

// class ProductsScreen extends StatefulWidget {

//   @override
//   _ProductsScreenState createState() => _ProductsScreenState();
// }

// class _ProductsScreenState extends State<ProductsScreen>
//     with SingleTickerProviderStateMixin {
 
//   int _current = 0;
//   int totalPrice = 0;
//   bool isAllCheck;
//   bool isLoading = true;
//   bool isLoadingMoreData = false;
//   bool isLoadingAllData = false;
//   bool isSearchClicked = false;
//   bool cartError = false;
//   bool isLinear = true;
//   ScrollController _loadMoreDataController;

//   TextEditingController searchController = TextEditingController();
//   FocusNode searchFocusNode = FocusNode();
//   List<String> cart = List<String>();
//   List<CartProductModel> cartProductModelList = List<CartProductModel>();
//   int totalProductsInCart = 0;
//   bool errorSearch = false;
//   bool searchFound = false;
//   bool isHighestPriceFilterSelected = false;
//   bool isLowestPriceFilterSelected = false;
//   bool isDiscountFilterSelected = false;
//   bool isNewFilterSelected = false;
//   bool isLoadingFilter = false;

//   TabController tabController;



//   getCartProducts() async {
//     var productModelList = await CartServices().viewCart(false);
//     productModelList.forEach((element) {
//       cart.add(element.id);
//     });
//   }

//   static List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }

//     return result;
//   }







  

//   getSeachedItems() async {
//     Response response = await Dio().post(
//         "https://fluffyandtasty.com/api/search",
//         data: {"keyword": "${searchController.text}"});
//     isLoading = true;
//     setState(() {});
//     if (response.data['status'] == true) {
//       searchFound = true;
//       widget.productModelList.clear();
//       List data = response.data['data'];
//       data.forEach((element) {
//         widget.productModelList.add(ProductModel.fromJson(element));
//       });
//     } else {
//       errorSearch = true;
//       setState(() {});
//     }
//     isLoading = false;
//     setState(() {});
//   }

 
  
 


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
        
//         body:  GestureDetector(
//                 onTap: () => searchFocusNode.unfocus(),
//                 child: SingleChildScrollView(
//                   controller: _loadMoreDataController,
//                   child: Column(
//                     children: <Widget>[

 
//                       Padding(padding: EdgeInsets.only(top: 20)),
            

//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         color: Colors.grey[300],
//                         padding: EdgeInsets.symmetric(vertical: 5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             IconButton(
//                               icon: Icon(
//                                 Icons.location_on,
//                                 color: mainColor,
//                                 size: 30,
//                               ),
//                               onPressed: () {
//                                 openMap();
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 Icons.view_module,
//                                 color: mainColor,
//                                 size: 30,
//                               ),
//                               onPressed: () async {
//                                 isLoadingAllData = true;
//                                 setState(() {});
//                                 apiPage = 1;
//                                 certainCategorySelected
//                                     ? await getProductsFromCertainCategory(
//                                         subCategory: golabalSubCategory)
//                                     : await getProducts(isSwitch: true);
//                                 isLinear = false;
//                                 isLoadingAllData = false;
//                                 setState(() {});
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 Icons.format_list_bulleted,
//                                 color: mainColor,
//                                 size: 30,
//                               ),
//                               onPressed: () async {
//                                 // isLoading=true;
//                                 // setState(() {});
//                                 isLoadingAllData = true;
//                                 setState(() {});
//                                 apiPage = 1;
//                                 certainCategorySelected
//                                     ? await getProductsFromCertainCategory(
//                                         subCategory: golabalSubCategory)
//                                     : await getProducts(isSwitch: true);
//                                 isLinear = true;
//                                 isLoadingAllData = false;
//                                 setState(() {});
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 Icons.search,
//                                 color: mainColor,
//                                 size: 30,
//                               ),
//                               onPressed: () {
//                                 isSearchClicked = !isSearchClicked;
//                                 if (isSearchClicked == false)
//                                   errorSearch = false;
//                                 if (searchFound == true) {
//                                   searchFound = false;
//                                   widget.productModelList.clear();
//                                   getCartItems();
//                                 }
//                                 tabController.animateTo(0);
//                                 setState(() {});
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(padding: EdgeInsets.only(top: 20)),
//                       errorSearch
//                           ? Center(
//                               child: Text("no item found"),
//                             )
//                           : Container(),
//                       isSearchClicked
//                           ? SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.8,
//                               child: TextField(
//                                 controller: searchController,
//                                 focusNode: searchFocusNode,
//                                 textInputAction: TextInputAction.search,
//                                 onSubmitted: (value) {
//                                   getSeachedItems();
//                                 },
//                                 decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20)),
//                                         borderSide:
//                                             BorderSide(color: Colors.grey)),
//                                     disabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20)),
//                                         borderSide:
//                                             BorderSide(color: Colors.grey)),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20)),
//                                         borderSide:
//                                             BorderSide(color: Colors.black)),
//                                     suffixIcon: IconButton(
//                                       onPressed: () {
//                                         getSeachedItems();
//                                       },
//                                       icon: Icon(
//                                         Icons.search,
//                                         color: searchFocusNode.hasFocus
//                                             ? Colors.blue
//                                             : Colors.grey,
//                                       ),
//                                     ),
//                                     hintText: "search...",
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 20, vertical: 1)),
//                               ),
//                             )
//                           : Container(),
//                       isLoadingAllData
//                           ? Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Padding(
//                                       padding: EdgeInsets.only(
//                                           top: MediaQuery.of(context)
//                                                   .padding
//                                                   .top +
//                                               50)),
//                                   Text(
//                                     "جارى التحميل",
//                                     style: TextStyle(fontSize: 20),
//                                   ),
//                                   Padding(padding: EdgeInsets.only(top: 30)),
//                                   CircularProgressIndicator(),
//                                   Padding(
//                                       padding: EdgeInsets.only(
//                                           top: MediaQuery.of(context)
//                                                   .padding
//                                                   .top +
//                                               50)),
//                                 ],
//                               ),
//                             )
//                           : widget.productModelList == null ||
//                                   widget.productModelList.isEmpty
//                               ? Center(
//                                   child: Text("ليس هناك منتجات متاحه الأن"),
//                                 )
//                               : isLinear
//                                   ? ListView.builder(
//                                       primary: false,
//                                       shrinkWrap: true,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemCount: widget.productModelList.length,
//                                       itemBuilder: (context, index) {
//                                         print(token);
//                                         return Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 5, horizontal: 5),
//                                           child: LinearProductCard(
//                                             id: widget
//                                                 .productModelList[index].id,
//                                             titleEn: widget
//                                                 .productModelList[index]
//                                                 .titleEn,
//                                             titleAr: widget
//                                                 .productModelList[index]
//                                                 .titleAr,
//                                             detailsEn: widget
//                                                 .productModelList[index]
//                                                 .detailsEn,
//                                             detailsAr: widget
//                                                 .productModelList[index]
//                                                 .detailsAr,
//                                             price: widget
//                                                 .productModelList[index].price,
//                                             video: widget
//                                                     .productModelList[index]
//                                                     .video ??
//                                                 "",
//                                             salePrice: widget
//                                                 .productModelList[index]
//                                                 .salePrice,
//                                             isAllChecked: isAllCheck,
//                                             totalAmountInCart: widget
//                                                 .productModelList[index]
//                                                 .quantity ?? 0,
//                                             addItemToCart: () {
//                                               totalProductsInCart++;
//                                               setState(() {});
//                                             },
//                                             removeItemFromCart: () {
//                                               totalProductsInCart--;
//                                               setState(() {});
//                                               Future.delayed(
//                                                   Duration(seconds: 1),
//                                                   () async {
//                                                 await getCartItems();
//                                                 print(
//                                                     '7aaaaaaaaaaaaaaaaaaaaaaaaaa');
//                                                 setState(() {});
//                                               });
//                                             },
//                                             imgList: widget
//                                                 .productModelList[index].images,
//                                           ),
//                                         );
//                                       },
//                                     )
//                                   : GridView.builder(
//                                       primary: false,
//                                       shrinkWrap: true,
//                                       gridDelegate:
//                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 2,
//                                               childAspectRatio:
//                                                   MediaQuery.of(context)
//                                                           .size
//                                                           .width /
//                                                       (MediaQuery.of(context)
//                                                               .size
//                                                               .height /
//                                                           1.7)),
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 5),
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemCount: widget.productModelList.length,
//                                       itemBuilder: (context, index) {
//                                         return Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 5, horizontal: 5),
//                                           child: GridProductCard(
//                                             id: widget
//                                                 .productModelList[index].id,
//                                             titleEn: widget
//                                                 .productModelList[index]
//                                                 .titleEn,
//                                             titleAr: widget
//                                                 .productModelList[index]
//                                                 .titleAr,
//                                             detailsEn: widget
//                                                 .productModelList[index]
//                                                 .detailsEn,
//                                             detailsAr: widget
//                                                 .productModelList[index]
//                                                 .detailsAr,
//                                             price: widget
//                                                 .productModelList[index].price,
//                                             video: widget
//                                                     .productModelList[index]
//                                                     .video ??
//                                                 "",
//                                             isAllChecked: isAllCheck,
//                                             totalAmount: widget
//                                                 .productModelList[index]
//                                                 .quantity,
//                                             addItemToCart: () {
//                                               totalProductsInCart++;
//                                               setState(() {});
//                                             },
//                                             removeItemFromCart: () {
//                                               totalProductsInCart--;
//                                               setState(() {});
//                                             },
//                                             imgList: widget
//                                                 .productModelList[index].images,
//                                           ),
//                                         );
//                                       },
//                                     ),
//                       Padding(padding: EdgeInsets.only(top: 20)),
//                       widget.productModelList == null ||
//                               widget.productModelList.isEmpty
//                           ? Container()
//                           : Container(
//                               width: MediaQuery.of(context).size.width * 0.5,
//                               padding: EdgeInsets.symmetric(vertical: 10),
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20)),
//                                 color: Colors.black,
//                               ),
//                               alignment: Alignment.center,
//                               child: Text(
//                                 "${"${AppLocalizations.of(context).translate('totalPrice')}"} : ${totalPrice ?? 0}",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                       Padding(padding: EdgeInsets.only(top: 20)),
//                       widget.productModelList == null ||
//                               widget.productModelList.isEmpty
//                           ? Container()
//                           : GetProducts.offerDialogAr.isEmpty
//                               ? Container()
//                               : Padding(padding: EdgeInsets.only(top: 20)),
//                       widget.productModelList == null ||
//                               widget.productModelList.isEmpty
//                           ? Container()
//                           : InkWell(
//                               onTap: () async {
//                                 await checkToken();
//                                 if (token.isNotEmpty) {
//                                   await getCartProducts();
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => CartScreen(
//                                       shifts: [],
//                                       id: widget.categoryId,
//                                       name: widget.categoryName,
//                                     ),
//                                   ));
//                                 } else {
//                                   _showMyDialog();
//                                 }
//                               },
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width * 0.5,
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 decoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20)),
//                                   color: mainColor,
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   "${AppLocalizations.of(context).translate('buy')}",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                       Padding(padding: EdgeInsets.only(top: 20)),
//                       cartError
//                           ? Text(
//                               "من فضلك اضف منج الى السله",
//                               style: TextStyle(color: Colors.red),
//                             )
//                           : Container(),
//                       isLoadingMoreData
//                           ? Center(
//                               child: CircularProgressIndicator(),
//                             )
//                           : Container(),
//                       Padding(padding: EdgeInsets.only(top: 40)),
//                     ],
//                   ),
//                 ),
//               ));
//   }
// }
