import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manage/static_method.dart';
import 'physical_details.dart';
import 'select_location.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class PersonalDetails extends StatefulWidget {
  final String smobileCtrl;

  const PersonalDetails({super.key, required this.smobileCtrl});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  late BuildContext ctx;
  File? imageFile;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController programCtrl = TextEditingController();
  String? sGenderValue,profile;
  List<String> genderList = ['Male', 'Female'];
  String t = "0";

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        appBar: appbarLayout(ctx),
        body: homeLayout(ctx),
      ),
    );
  }

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
        'Personal Details',
        style: Sty().largeText.copyWith(
            color: Clr().appbarTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget homeLayout(ctx) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dim().d16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(
              height: Dim().d20,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    height: Dim().d140,
                    width: Dim().d140,
                    decoration: BoxDecoration(
                      color: Clr().lightGrey,
                      border: Border.all(
                        color: Clr().grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dim().d100),
                      ),
                    ),
                    child: ClipOval(
                      child: imageFile == null
                          ? Image.asset(
                        'assets/pro.png',
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 2,
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Clr().primaryColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: (){
                              _getFromCamera();
                            },
                            child: SvgPicture.asset('assets/cam.svg')),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Clr().grey.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 12,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                controller: nameCtrl,
                keyboardType: TextInputType.name,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Name is required';
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
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Dim().d20, vertical: Dim().d16),
                  // label: Text('Enter Your Number'),
                  hintText: "Name",
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
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Clr().grey.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 12,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email Id is required';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
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
                  contentPadding: EdgeInsets.symmetric(horizontal: Dim().d20, vertical: Dim().d16),
                  // label: Text('Enter Your Number'),
                  hintText: "Email ID",
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
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: sGenderValue,
                decoration: Sty().TextFormFieldWithoutStyle.copyWith(
                  border: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Clr().lightGrey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Clr().primaryColor,
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Clr().errorRed,
                    ),
                  ),
                  fillColor: Clr().white,
                  filled: true,
                ),
                isExpanded: true,
                validator: (value){
                  if(value == null){
                    return 'Gender is required';
                  }
                },
                hint: Text('Select Gender',
                    style:
                    Sty().mediumText.copyWith(color: Clr().shimmerColor)),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 28,
                  color: Clr().grey,
                ),
                style: TextStyle(color: Clr().black),
                items: genderList.map((String string) {
                  return DropdownMenuItem<String>(
                    value: string,
                    child: Text(
                      string,
                      style:
                      TextStyle(color: Clr().black, fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (t) {
                  // STM().redirect2page(ctx, Home());
                  setState(() {
                    sGenderValue = t!;
                  });
                },
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
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                readOnly: true,
                onTap: () {
                  datePicker();
                },
                controller: dobCtrl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Birth date is required';
                  }
                },
                // controller: mobileCtrl,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: const Icon(Icons.calendar_month),
                  fillColor: Clr().formfieldbg,
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Clr().transparent)),
                  focusColor: Clr().primaryColor,
                  contentPadding: EdgeInsets.all(18),
                  // label: Text('Enter Your Number'),
                  hintText: "Date of birth",
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
                      offset: Offset(0, 4) // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                controller: programCtrl,
                maxLength: 6,
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
                  contentPadding: EdgeInsets.symmetric(horizontal: Dim().d20, vertical: Dim().d16),
                  // label: Text('Enter Your Number'),
                  hintText: "Enter program code here",
                  hintStyle: Sty().mediumText.copyWith(
                    color: Clr().shimmerColor,
                  ),
                  counterText: "",
                ),
              ),
            ),
            SizedBox(
              height: Dim().d40,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    if(formKey.currentState!.validate()){
                      profile == null ?  STM().displayToast('Profile picture is required') : register();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Submit',
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


  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        dobCtrl = TextEditingController(text: s);
      });
    }
  }

  //Api Method
  void register() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Input
    FormData body = FormData.fromMap({
      'name': nameCtrl.text,
      'mobile': widget.smobileCtrl,
      'email': emailCtrl.text,
      'gender': sGenderValue,
      'dob': dobCtrl.text,
      'program_code': programCtrl.text,
      'profile_image': profile,
      'user_type': 2,
    });
    //Output
    var result = await STM().postOpen(ctx, Str().loading, "register", body);
    if (!mounted) return;
    var message = result['message'];
    var success = result['success'];
    if (success) {
      sp.setBool('personal', true);
      sp.setString('customerid', result['customer_id'].toString());
      sp.setString('customerId', result['customer_token']);
      STM().finishAffinity(ctx, PhysicalDetails(),);
      STM().displayToast(message);
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        var image = imageFile!.readAsBytesSync();
        profile = base64Encode(image);
      });
    }
  }

}
