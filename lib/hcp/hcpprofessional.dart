import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:saarathi/hcp/hcpMyprofile.dart';
import 'package:saarathi/hcp/hcppersonalinfo.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/strings.dart';
import '../values/styles.dart';
import 'hcpeducational.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

String? sLocation, sLatitude, sLongitude;
var controller = StreamController<String?>.broadcast();

class ProfessionalInfo extends StatefulWidget {
  final pagetype;
  dynamic data;

  ProfessionalInfo({super.key, this.pagetype, this.data});

  @override
  State<ProfessionalInfo> createState() => _ProfessionalInfoState();
}

class _ProfessionalInfoState extends State<ProfessionalInfo> {
  late BuildContext ctx;
  String? categoryValue;
  List<Map<String, dynamic>> categoryList = [
    {'id': 1, 'name': 'Nurse'},
    {'id': 2, 'name': 'Doctor'},
    {'id': 3, 'name': 'Physiotherapist'}
  ];
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController opdaddress = TextEditingController();
  TextEditingController experinceCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String t = "0";
  List addspecialityList = [];
  List<Map<String, dynamic>> specialList = [
    {"id": 1, "name": 'Speciality 1 '},
    {"id": 2, "name": 'Speciality 2'}
  ];
  String v = "0";
  String? categoryerror, specialitieserror, mapaddress,hcptoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List professionalist = sp.getStringList('professionallist') ?? [];
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    widget.data == null
        ? null
        : setState(() {
            int position = categoryList.indexWhere((element) =>
                element['id'].toString() ==
                widget.data['category_id'].toString());
            categoryValue = categoryList[position]['name'];
            addspecialityList = widget.data['speciality_id'];
            mobileCtrl = TextEditingController(text: widget.data['contact_no'].toString());
            opdaddress = TextEditingController(text: widget.data['address'].toString());
            experinceCtrl = TextEditingController(
                text: widget.data['experience'].toString());
            sLatitude = widget.data['latitude'].toString();
            sLongitude = widget.data['longitude'].toString();
            sLocation = widget.data['map_address'].toString();
          });
    setState(() {
      int position = categoryList.indexWhere((element) =>
      element['id'].toString() == professionalist[0].toString());
      categoryValue = categoryList[position]['name'];
      addspecialityList = jsonDecode(professionalist[1]);
      mobileCtrl = TextEditingController(text: professionalist[2]);
      opdaddress = TextEditingController(text: professionalist[3]);
      experinceCtrl = TextEditingController(text: professionalist[4]);
      sLatitude = professionalist[5];
      sLongitude = professionalist[6];
      sLocation = professionalist[7];
    });
    print(professionalist[1]);
  }

  @override
  void initState() {
    getSession();
    controller.stream.listen(
      (event) {
        setState(() {
          sLocation = null;
          sLocation = sLocation;
        });
      },
    );
    print(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(onWillPop: ()async{
     widget.pagetype =='edit'? STM().back2Previous(ctx) : STM().replacePage(ctx, hcp_Personalinfo());
      return false;
    },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              widget.pagetype =='edit'? STM().back2Previous(ctx) : STM().replacePage(ctx, hcp_Personalinfo());
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Clr().appbarTextColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Professional Information',
            style: Sty().largeText.copyWith(
                color: Clr().appbarTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Step 2 of 3',
                    textAlign: TextAlign.left,
                    style: Sty().largeText.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Select Category',
                      style:
                          Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: ' *', style: TextStyle(color: Clr().red))
                      ]),
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                    child: DropdownButton(
                      hint: Text(
                        categoryValue ?? 'Select Category',
                        style: Sty().mediumText.copyWith(
                            color: categoryValue != null
                                ? Clr().black
                                : Clr().shimmerColor),
                      ),
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 28,
                        color: Clr().grey,
                      ),
                      style: TextStyle(color: Color(0xff787882)),
                      items: categoryList.map((string) {
                        return DropdownMenuItem(
                          value: string['name'],
                          child: Text(
                            string['name'],
                            style:
                                TextStyle(color: Color(0xff787882), fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (t) {
                        // STM().redirect2page(ctx, Home());
                        setState(() {
                          categoryValue = t.toString();
                          categoryerror = null;
                        });
                      },
                    ),
                  ),
                ),
                categoryerror == null
                    ? SizedBox.shrink()
                    : Text(categoryerror ?? '',
                        style: Sty().mediumText.copyWith(color: Clr().errorRed,fontSize: Dim().d16)),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Specialities',
                      style:
                          Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: ' *', style: TextStyle(color: Clr().red))
                      ]),
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (index2) {
                          return MultiSelectDialog(
                            items: specialList.map((e) {
                              return MultiSelectItem(
                                  e['id'].toString(), e['name'].toString());
                            }).toList(),
                            initialValue: addspecialityList,
                            height: 350,
                            width: 450,
                            title: Text(
                              "Select Speciality",
                              style: Sty().mediumText.copyWith(
                                    fontSize: Dim().d14,
                                    color: Clr().hintColor,
                                  ),
                            ),
                            selectedColor: Clr().black,
                            onConfirm: (results) {
                              setState(() {
                                addspecialityList = results;
                                specialitieserror = null;
                              });
                            },
                          );
                        });
                  },
                  child: Container(
                    height: Dim().d52,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Clr().grey.withOpacity(0.1),
                            spreadRadius: 0.5,
                            blurRadius: 12,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        color: Clr().white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Clr().borderColor)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            addspecialityList.isNotEmpty
                                ? 'Specialities Selected'
                                : 'Select Speciality',
                            style: Sty().mediumText.copyWith(
                                color: addspecialityList.isNotEmpty
                                    ? Clr().black
                                    : const Color(0xff787882)),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                specialitieserror == null
                    ? SizedBox.shrink()
                    : Text(specialitieserror ?? '',
                        style: Sty().mediumText.copyWith(color: Clr().errorRed,fontSize: Dim().d16)),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Official Contact No',
                      style:
                          Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: ' *', style: TextStyle(color: Clr().red))
                      ]),
                ),
                SizedBox(
                  height: Dim().d12,
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
                    controller: mobileCtrl,
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
                      contentPadding: EdgeInsets.all(18),
                      // label: Text('Enter Your Number'),
                      hintText: "Mobile Number",
                      hintStyle: Sty().mediumText.copyWith(
                            color: Clr().shimmerColor,
                          ),
                      counterText: "",
                    ),
                    maxLength: 10,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'([5-9]{1}[0-9]{9})').hasMatch(value)) {
                        return Str().invalidMobile;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "OPD Address (if any)",
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Dim().d12,
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
                    controller: opdaddress,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        mapaddress = null;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Clr().formfieldbg,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Clr().primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      // label: Text('Enter Your Number'),
                      hintText: "Enter Clinic Address",
                      hintStyle: Sty().mediumText.copyWith(
                            color: Clr().shimmerColor,
                          ),
                      counterText: "",
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                InkWell(
                  onTap: () {
                    STM().redirect2page(
                        ctx,
                        CustomSearchScaffold('AIzaSyCSs8od16tCpuiMK-QUpMrqRdKfPckrjYI'));
                    setState(() {
                      mapaddress = null;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Clr().formfieldbg,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Clr().grey.withOpacity(0.1),
                          spreadRadius: 0.5,
                          blurRadius: 12,
                          offset: Offset(0, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12, vertical: Dim().d20),
                      child: Text(
                        sLocation == null
                            ? "Select Map Opd Address"
                            : sLocation.toString(),
                        style: Sty().mediumText.copyWith(
                              color: sLocation == null
                                  ? Clr().shimmerColor
                                  : Clr().black,
                            ),
                      ),
                    ),
                  ),
                ),
                mapaddress == null
                    ? const SizedBox.shrink()
                    : Text(mapaddress ?? '',
                        style: Sty().mediumText.copyWith(color: Clr().errorRed,fontSize: Dim().d16)),
                SizedBox(height: Dim().d20),
                RichText(
                  text: TextSpan(
                      text: 'Experience (In Years)',
                      style:
                          Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: ' *', style: TextStyle(color: Clr().red))
                      ]),
                ),
                SizedBox(
                  height: Dim().d12,
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
                    controller: experinceCtrl,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Your experience is required';
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Clr().formfieldbg,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Clr().primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      // label: Text('Enter Your Number'),
                      hintText: "",
                      hintStyle: Sty().mediumText.copyWith(
                            color: Clr().shimmerColor,
                          ),
                      counterText: "",
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () {
                         widget.pagetype == 'edit' ? updateProffessionalinfo() : _validateForm(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Clr().primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          widget.pagetype == 'edit' ? 'Update' : 'Next',
                          style: Sty().mediumText.copyWith(
                                color: Clr().white,
                                fontWeight: FontWeight.w600,
                              ),
                        )),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // validation funtion
  _validateForm(ctx) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool _isValid = formKey.currentState!.validate();
    if (categoryValue == null) {
      setState(() => categoryerror = "Your Professional field is required");
      _isValid = false;
    }
    if (addspecialityList.isEmpty) {
      setState(() {
        specialitieserror = "Your speciality is required";
      });
      _isValid = false;
    }
    if (opdaddress.text.isNotEmpty) {
      if (sLocation == null) {
        setState(() {
          mapaddress = "Map Location is required";
        });
        _isValid = false;
      }
    }
    if (_isValid) {
      int position = categoryList.indexWhere(
          (element) => element['name'].toString() == categoryValue.toString());
      setState(() {
        sp.setStringList('professionallist', [
          categoryList[position]['id'].toString(),
          jsonEncode(addspecialityList),
          mobileCtrl.text,
          opdaddress.text,
          experinceCtrl.text,
          sLatitude.toString(),
          sLongitude.toString(),
          sLocation.toString(),
        ]);
        print(sLocation);
        print(sLatitude);
        print(sLongitude);
      });
      sp.setBool('hcp_professionalinfo', true);
      STM().redirect2page(ctx, EducationalInfo());
    }
  }
  void updateProffessionalinfo() async {
    int position = categoryList.indexWhere((element) => element['name'].toString() == categoryValue.toString());
    FormData body = FormData.fromMap({
    'category_id':  categoryList[position]['id'].toString(),
    'speciality_ids': jsonEncode(addspecialityList),
    'contact_no':  mobileCtrl.text,
    'address': opdaddress.text,
    'experience': experinceCtrl.text,
    'latitude': sLatitude.toString(),
    'longitude': sLongitude.toString(),
    'map_address':sLocation.toString(),
    });
    var result = await STM().postWithToken(ctx, Str().updating, 'update_professional', body, hcptoken, 'hcp');
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().successDialogWithReplace(ctx, message, MyProfile());
    }else{
      STM().errorDialog(ctx, message);
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
            sLatitude = geometry.location.lat.toString();
            sLongitude = geometry.location.lng.toString();
            controller.sink.add('update');
            STM().back2Previous(context);
            STM().displayToast('Location is selected');
          });
          print(sLocation);
          print(sLatitude);
          print(sLongitude);
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
