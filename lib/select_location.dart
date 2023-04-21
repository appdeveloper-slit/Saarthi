import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SelectLocation extends StatefulWidget {
  final String?  weightCtrl, heightCtrl, sDietValue;

  const SelectLocation(
      {super.key,
      this.weightCtrl,
      this.heightCtrl,
      this.sDietValue});

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
  String? Lat, Lng,customerID;
  late LocationPermission permission;
  late Position position;
  AwesomeDialog? dialog;
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      customerID = sp.getString('customerId') ?? '';
    });
    print(customerID);
  }
  @override
  void initState() {
    getSession();
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
        child: Column(
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
                        child: Text(
                      Lat != null
                          ? 'Current Location Is Selected'
                          : 'Pick current location',
                      style: Sty().mediumText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w600),
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
                controller: stateCtrl,
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
                  hintText: "State",
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
                controller: cityCtrl,
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
                  hintText: "City",
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().shimmerColor,
                        fontSize: 14,
                      ),
                  counterText: "",
                ),
              ),
            ),
            SizedBox(
              height: Dim().d52,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      OtherDetails();
                    }
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


  // getLocation
  getLocation() async {
    dialog = STM().loadingDialog(ctx, 'Fetch location');
    dialog!.show();
   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() {
        Lat = position.latitude.toString();
        Lng = position.longitude.toString();
        STM().displayToast('Current location is selected');
        dialog!.dismiss();
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
      'latitude': Lat,
      'longitude': Lng,
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
      STM().finishAffinity(ctx, Home());
      STM().displayToast(message);
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }
}
