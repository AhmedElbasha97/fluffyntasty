import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/services/registration.dart';
import 'package:fbTrade/ui/men_or_women.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SignUpScreen extends StatefulWidget {
  bool isCheck;

  SignUpScreen({this.isCheck = false});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController selectedPlaceController = TextEditingController();

  DateTime dateTime = DateTime.now();
  bool nameError = false;
  bool emailError = false;
  bool phoneError = false;
  bool passwordError = false;
  bool dateError = false;
  PickResult selectedPlace;
  TextEditingController addressController = TextEditingController();
  Position position;

  getLocation() async {
    position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  validate(BuildContext context) async {
    if (nameController.text.isEmpty)
      nameError = true;
    else
      nameError = false;
    if (emailController.text.isEmpty)
      emailError = true;
    else
      emailError = false;

    if (phoneController.text.isEmpty)
      phoneError = true;
    else
      phoneError = false;
    if (passwordController.text.isEmpty)
      passwordError = true;
    else
      passwordError = false;

    setState(() {});
    if (!nameError &&
        !emailError &&
        !phoneError &&
        !passwordError &&
        !dateError) {
      String response = await RegistrationService().registrationService(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        gender: "male",
        address: addressController.text,
        birthdayDate: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
        lat: position == null ? 0.0 : position.latitude,
        long: position == null ? 0.0 : position.longitude,
      );
      if (response == 'success') {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MenOrWomen(),
        ));
      } else {
        final snackBar = SnackBar(content: Text('$response'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "${AppLocalizations.of(context).translate('signUp')}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20)),
                appInfo.logo == null || appInfo.logo == ""
                    ? Image.asset(
                        "assets/icon/logo.png",
                        scale: 3,
                      )
                    : CachedNetworkImage(
                        imageUrl: "${appInfo.logo}",
                        fit: BoxFit.scaleDown,
                      ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20)),
                Container(
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.green)),
                        hintText:
                            "${AppLocalizations.of(context).translate('name')}"),
                  ),
                ),
                nameError
                    ? Text(
                        "please enter your name",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: emailController,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.green)),
                        hintText:
                            "${AppLocalizations.of(context).translate('email')}"),
                  ),
                ),
                emailError
                    ? Text(
                        "please enter your email",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.green)),
                        hintText:
                            "${AppLocalizations.of(context).translate('phoneNumber')}"),
                  ),
                ),
                phoneError
                    ? Text(
                        "please enter your phone number",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.green)),
                        hintText:
                            "${AppLocalizations.of(context).translate('password')}"),
                  ),
                ),
                passwordError
                    ? Text(
                        "please enter your password",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                Padding(padding: EdgeInsets.only(top: 10)),
                Padding(padding: EdgeInsets.only(top: 10)),
                RaisedButton(
                  child: Text("select address"),
                  onPressed: () async {
                    await getLocation();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            selectInitialPosition: true,
                            apiKey: "AIzaSyCCz1qSCW7Q8fiV8cbhro0OqtW-9Z-U-CM",
                            initialPosition:
                                LatLng(position.latitude, position.longitude),
                            useCurrentLocation: true,
                            onPlacePicked: (result) {
                              try {
                                selectedPlace = result;
                                addressController.text =
                                    selectedPlace.formattedAddress;
                                Navigator.of(context).pop();
                                setState(() {});
                              } catch (e) {}
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.green)),
                        hintText: "your address to deliver our products to it",
                        hintStyle: TextStyle(fontSize: 16)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 25)),
                InkWell(
                  onTap: () {
                    validate(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: mainColor,
                    ),
                    child: Text(
                      "${AppLocalizations.of(context).translate('login')}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20))
              ],
            ),
          );
        },
      ),
    );
  }
}
