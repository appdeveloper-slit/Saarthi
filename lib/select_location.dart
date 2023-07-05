import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
String? sLocation;
var controller1 = StreamController<String?>.broadcast();
class SelectLocation extends StatefulWidget {
  final String?  weightCtrl, heightCtrl, sDietValue;
  final type;
  const SelectLocation(
      {super.key,
      this.weightCtrl,
      this.heightCtrl,
      this.sDietValue,this.type});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController landMarkCtrl = TextEditingController();
  TextEditingController pincodeCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();

  int? cityValue;
  int? stateValue;
  String? _dropdownError;
  String? _dropdownError1;
  List<dynamic> cityList = [];
  List<dynamic> stateList = [];

  String? customerID;
  late LocationPermission permission;
  late Position position;
  AwesomeDialog? dialog;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      customerID = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getCity();
        print(customerID);
      }
    });
    print(customerID);
  }

  @override
  void initState() {
    getSession();
    controller1.stream.listen(
          (event) {
        setState(() {
          sLocation = sLocation;
          sLocation != null ? widget.type == 'home'? STM().finishAffinity(ctx, Home()) : null : null;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: appbarLayout(ctx),
      body: homeLayout(ctx),
    );
  }

  SizedBox box({h, w, child}) {
    return SizedBox(
      height: h,
      width: w,
      child: child,
    );
  }

  // Home Layout
  Widget homeLayout(ctx) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dim().d16),
      child: Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            box(h: Dim().d8),
            InkWell(
              onTap: () {
                permissionHandle();
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Clr().borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d16, vertical: Dim().d16),
                      child: SvgPicture.asset('assets/pick_location.svg'),
                    ),
                    Expanded(
                        child: Text('Pick current location',
                      style: Sty().mediumText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(height: Dim().d12),
            InkWell(
              onTap: () {
                STM().redirect2page(
                    ctx,
                    CustomSearchScaffold('AIzaSyCSs8od16tCpuiMK-QUpMrqRdKfPckrjYI'));
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Clr().borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d16, vertical: Dim().d16),
                      child: SvgPicture.asset('assets/pick_location.svg'),
                    ),
                    Expanded(
                        child: Text(
                          sLocation != null
                              ? '${sLocation.toString()}'
                              : 'Pick location Manually',
                          style: Sty().mediumText.copyWith(
                              color: Clr().primaryColor,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ),
            ),
            box(h: Dim().d32),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Clr().grey.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 12,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                controller: addressCtrl,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Clr().formfieldbg,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Clr().primaryColor, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  // label: Text('Enter Your Number'),
                  hintText: "House No,Building Name",
                  hintStyle: Sty()
                      .mediumText
                      .copyWith(color: Clr().shimmerColor, fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Clr().grey.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 12,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                controller: landMarkCtrl,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Clr().formfieldbg,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Clr().primaryColor, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  // label: Text('Enter Your Number'),
                  hintText: "Add Nearby Famouse Shop/Landmark",
                  hintStyle: Sty()
                      .mediumText
                      .copyWith(color: Clr().shimmerColor, fontSize: 14),
                  counterText: "",
                ),
              ),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Clr().grey.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 12,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                controller: pincodeCtrl,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Clr().formfieldbg,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Clr().primaryColor, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  // label: Text('Enter Your Number'),
                  hintText: "Pincode",
                  hintStyle: Sty()
                      .mediumText
                      .copyWith(color: Clr().shimmerColor, fontSize: 14),
                  counterText: "",
                ),
              ),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  color: Clr().formfieldbg,
                  boxShadow: [
                    BoxShadow(
                      color: Clr().grey.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 12,
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Clr().transparent)),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  value: stateValue,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    'Select State',
                    style: Sty().smallText.copyWith(
                      color: Clr().shimmerColor,
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Clr().grey,
                  ),
                  style: TextStyle(color: Clr().black),
                  items: stateList.map((string) {
                    return DropdownMenuItem(
                      value: string['id'],
                      child: Text(
                        string['name'],
                        style: TextStyle(color: Clr().black, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // STM().redirect2page(ctx, Home());
                    setState(() {
                      stateValue = value as int?;
                      _dropdownError1 = null;
                      int position = int.parse(stateValue.toString());
                      cityList = stateList[position - 1]['city'];
                      cityValue = null;
                    });
                  },
                ),
              ),
            ),
            _dropdownError1 == null
                ? const SizedBox.shrink()
                : Padding(
              padding:
              EdgeInsets.only(left: Dim().d16, top: Dim().d8),
              child: Text(
                _dropdownError1 ?? "",
                style: const TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dim().d16, vertical: Dim().d4),
              decoration: BoxDecoration(
                  color: Clr().formfieldbg,
                  boxShadow: [
                    BoxShadow(
                      color: Clr().grey.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 12,
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Clr().transparent)),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  value: cityValue,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    'Select City',
                    style: Sty().smallText.copyWith(
                      color: Clr().shimmerColor,
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Clr().grey,
                  ),
                  style: TextStyle(color: Clr().black),
                  items: cityList.map((string) {
                    return DropdownMenuItem(
                      value: string['id'],
                      child: Text(
                        string['name'],
                        style: TextStyle(color: Clr().black, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // STM().redirect2page(ctx, Home());
                    setState(() {
                      cityValue = value as int?;
                      _dropdownError = null;
                    });
                  },
                ),
              ),
            ),
            _dropdownError == null
                ? SizedBox.shrink()
                : Padding(
              padding:
              EdgeInsets.only(left: Dim().d16, top: Dim().d8),
              child: Text(
                _dropdownError ?? "",
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              height: Dim().d52,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      _validateForm(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Save location',
                      style: Sty().mediumText.copyWith(
                            color: Clr().white,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // appbar Layout
  AppBar appbarLayout(ctx) {
    return AppBar(
      elevation: 2,
      backgroundColor: Clr().white,
      leading: InkWell(
        onTap: () {
          STM().back2Previous(ctx);
        },
        child: Icon(
          Icons.arrow_back_rounded,
          color: Clr().appbarTextColor,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Select Location',
        style: Sty().largeText.copyWith(
            color: Clr().appbarTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> permissionHandle() async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      getLocation();
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      STM().displayToast('Location permission is required');
      await Geolocator.openAppSettings();
    }
  }

  _validateForm(ctx) {
    bool _isValid = formKey.currentState!.validate();

    if (cityValue == null) {
      setState(() => _dropdownError = "Please select city");
      _isValid = false;
    }
    if (stateValue == null) {
      setState(() {
        _dropdownError1 = "Please select state";
      });
      _isValid = false;
    }
    if (_isValid) {
      OtherDetails();
    }
  }

  // getLocation
  getLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    dialog = STM().loadingDialog(ctx, 'Fetching location');
    dialog!.show();
   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() {
        sp.setString('lat', position.latitude.toString());
        sp.setString('lng', position.longitude.toString());
        STM().displayToast('Current location is selected');
        dialog!.dismiss();
         widget.type == 'home'? STM().finishAffinity(ctx, Home()) : null;
      });
    }).catchError((e){
      dialog!.dismiss();
    });
  }

  //Api Method
  void OtherDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> PhysicalList = [];
    setState(() {
      PhysicalList = sp.getStringList('physicallist') ?? [];
    });
    //Input
    FormData body = FormData.fromMap({
      'customer_id': customerID,
      'weight': PhysicalList.isEmpty ? null :  PhysicalList[3],
      'height_in_feet': '${PhysicalList.isEmpty ? null : PhysicalList[0]}',
      'height_in_inch': '${PhysicalList.isEmpty ? null : PhysicalList[1]}',
      'diet': PhysicalList.isEmpty ? null : PhysicalList[2],
      'latitude': sp.getString('lat'),
      'longitude': sp.getString('lng'),
      'address': addressCtrl.text,
      'landmark': landMarkCtrl.text,
      'pincode': pincodeCtrl.text,
      'state': stateCtrl.text,
      'city': cityCtrl.text,
    });
    //Output
    var result = await STM().postWithToken(ctx, Str().loading, "other_detail", body,customerID,'customer');
    if (!mounted) return;
    var message = result['message'];
    var success = result['success'];
    if (success) {
      sp.setBool('login', true);
      STM().finishAffinity(ctx, Home(Lat: sp.getString('lat'),Lng: sp.getString('lng'),));
      STM().displayToast(message);
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }
  // get state and city

  void getCity() async {
    var result = await STM().getOpen(ctx, Str().loading, 'get_cities');
    var success = result['success'];
    if(success){
      setState(() {
        stateList = result['cities'];
      });
    }
  }
}
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  final String sMapKey;

  CustomSearchScaffold(this.sMapKey, {Key? key})
      : super(
    key: key,
    apiKey: sMapKey,
    sessionToken: const Uuid().v4(),
    language: 'en',
    components: [Component(Component.country, 'in')],
  );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Clr().primaryColor,
        title: AppBarPlacesAutoCompleteTextField(
          cursorColor: Clr().primaryColor,
          textStyle: Sty().mediumText,
          textDecoration: null,
        ),
      ),
      body: PlacesAutocompleteResult(
        logo: null,
        onTap: (p) async {
          SharedPreferences sp = await SharedPreferences.getInstance();
          if (p == null) {
            return;
          }
          final _places = GoogleMapsPlaces(
            apiKey: widget.apiKey,
            apiHeaders: await const GoogleApiHeaders().getHeaders(),
          );
          final detail = await _places.getDetailsByPlaceId(p.placeId!);
          final geometry = detail.result.geometry!;
          setState(() {
            sLocation = p.description;
            sp.setString('lat', geometry.location.lat.toString());
            sp.setString('lng', geometry.location.lng.toString());
            controller1.sink.add('update');
            STM().back2Previous(context);
            STM().displayToast('Location is selected');
          });
        },
      ),
    );
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage ?? 'Unknown error')),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response.predictions.isNotEmpty) {
      setState(() {
        sLocation = response.status;
      });
    }
  }
}
