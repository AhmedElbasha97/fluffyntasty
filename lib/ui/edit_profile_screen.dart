import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/ui/men_or_women.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'map_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? token;
  String? userAddress;
  DateTime dateTime = DateTime.now();
  String? birthDate = "";
   late LatLng selectedPlace;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = true;

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    selectedPlace =result;
    List<Placemark> i =
    await placemarkFromCoordinates(result.latitude, result.longitude);
    Placemark placeMark = i.first;
    userAddress="${placeMark.street},${placeMark.subAdministrativeArea},${placeMark.subLocality},${placeMark.country}";
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("${placeMark.street},${placeMark.subAdministrativeArea},${placeMark.subLocality},${placeMark.country}")));
  }
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    Response response = await Dio().post("https://fluffyandtasty.com/api/info",
        options: Options(headers: {"token": "$token"}));

    nameController.text = response.data['data'][0]['name'];
    emailController.text = response.data['data'][0]['email'];
    mobileController.text = response.data['data'][0]['mobile'];
    birthDate = response.data['data'][0]['birth_date'];
    userAddress = response.data['data'][0]['address'];
    isLoading = false;
    setState(() {});

    print(response.data);
  }

  updateInfo() async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      response = await Dio().post(
        "https://fluffyandtasty.com/api/editinfo",
        data: passwordController.text.isEmpty
            ? {
                "name": "${nameController.text}",
                "mobile": "${mobileController.text}",
                "email": "${emailController.text}",
                "address": "$userAddress",
                "gender": "male",
                "birth_date": "$birthDate",
              }
            : {
                "name": "${nameController.text}",
                "mobile": "${mobileController.text}",
                "email": "${emailController.text}",
                "password": "${passwordController.text}",
                "address": "$userAddress",
                "gender": "male",
                "birth_date": "$birthDate",
              },
        options: Options(headers: {"token": "$token"}),
      );
      print(response.data);

      prefs.setString("name", nameController.text);
      prefs.setString("phone", mobileController.text);
      prefs.setString("email", emailController.text);
      prefs.setString("address", userAddress!);
      prefs.setString("gender", "male");
      prefs.setString("birthdayDate", birthDate!);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MenOrWomen(),
      ));
    } on DioError catch (e) {
      print('error in edit profile => ${e.response}');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "${AppLocalizations.of(context)!.translate('editProfile')}",
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: appInfo!.logo == null || appInfo!.logo == ""
                        ? Image.asset(
                            "assets/icon/logo.png",
                            scale: 7,
                          )
                        : CachedNetworkImage(imageUrl: "${appInfo!.logo}"),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 20)),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            filled: true,
                            focusColor: Color(0xFFF3F3F3),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                                "${AppLocalizations.of(context)!.translate('name')}"),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      TextField(
                        controller: mobileController,
                        decoration: InputDecoration(
                            filled: true,
                            focusColor: Color(0xFFF3F3F3),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                                "${AppLocalizations.of(context)!.translate('phoneNumber')}"),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            filled: true,
                            focusColor: Color(0xFFF3F3F3),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                                "${AppLocalizations.of(context)!.translate('email')}"),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            filled: true,
                            focusColor: Color(0xFFF3F3F3),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                                "${AppLocalizations.of(context)!.translate('password')}"),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      RaisedButton(
                        child: Text("Selcet Location"),
                        onPressed: () {
                          _navigateAndDisplaySelection(context);
                        },
                      ),
                      Text("${userAddress == null ? "" : userAddress}"),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      InkWell(
                        onTap: () => updateInfo(),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.green),
                          child: Text(
                              "${AppLocalizations.of(context)!.translate('edit')}",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 20))
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
