import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saarathi/hcp/hcpMyprofile.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/styles.dart';
import 'hcpprofessional.dart';

class hcp_Personalinfo extends StatefulWidget {
  final pagetype;
  dynamic data;

  hcp_Personalinfo({super.key, this.pagetype, this.data});

  @override
  State<hcp_Personalinfo> createState() => _hcp_PersonalinfoState();
}

class _hcp_PersonalinfoState extends State<hcp_Personalinfo> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();
  List<dynamic> languagelist = [
    'English',
    'Hindi',
    'Marathi',
    'Gujrati',
    'Kannada',
    'Tamil'
  ];
  List<dynamic> addlanguageList = [];
  File? imageFile;
  String? profile,
      gendererror,
      birtherror,
      adharcarderror,
      adharcardbackerror,
      languageerror,
      signatureerror,
      adharPhoto,
      adharbackPhoto,
      signaturePhoto,
      profileImagepath;

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

  String? GenderValue;
  List<String> genderList = ['Male', 'Female'];
  String t = "0";
  String? hcptoken;
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List personalList = sp.getStringList('personalinfo') ?? [];
    setState((){
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    widget.data == null
        ? null
        : setState(() {
            GenderValue = widget.data['gender'];
            dobCtrl =
                TextEditingController(text: widget.data['dob'].toString());
            addlanguageList = widget.data['languages'];
          });
    widget.pagetype == 'edit' ? null : setState(() {
      GenderValue = personalList[0];
      dobCtrl = TextEditingController(text: personalList[1]);
      addlanguageList = jsonDecode(personalList[2]);
      adharPhoto = personalList[3];
      adharbackPhoto = personalList[4];
      signaturePhoto = personalList[5];
      profile = personalList[6];
      imageFile = File(personalList[7].toString()) as File?;
    });
  }

  @override
  void initState() {
    getSession();
    print(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return widget.pagetype == 'edit'
        ? WillPopScope(
            child: homeLayout(ctx),
            onWillPop: () async {
              STM().back2Previous(ctx);
              return false;
            })
        : DoubleBack(
            message: 'Press back again to exit',
            child: homeLayout(ctx),
          );
  }

  // home page
  Widget homeLayout(ctx) {
    return Scaffold(
      appBar: abbbarlayout(ctx),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Step 1 of 3',
                  textAlign: TextAlign.left,
                  style: Sty().largeText.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              PersonalPhotolayout(),
              SizedBox(
                height: Dim().d12,
              ),
              Text(
                'Add Photo',
                style: Sty().mediumText.copyWith(
                    color: Clr().appbarTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Gender',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text: ' *', style: TextStyle(color: Clr().red))
                        ]),
                  ),
                  SizedBox(
                    height: Dim().d8,
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
                      child: DropdownButton(
                        value: GenderValue,
                        hint: Text(
                          GenderValue ?? 'Select Gender',
                          style: Sty()
                              .mediumText
                              .copyWith(color: Clr().shimmerColor),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 28,
                          color: Clr().grey,
                        ),
                        style: TextStyle(color: Clr().black),
                        items: genderList.map((String string) {
                          return DropdownMenuItem(
                            value: string,
                            child: Text(
                              string,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: widget.pagetype == 'edit' ? null :  (t) {
                          setState(() {
                            GenderValue = t as String;
                            gendererror = null;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: Dim().d4),
                  gendererror == null
                      ? const SizedBox.shrink()
                      : Text(gendererror ?? '',
                          style:
                              Sty().mediumText.copyWith(color: Clr().errorRed,fontSize: Dim().d12)),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Date of birth',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text: ' *', style: TextStyle(color: Clr().red))
                        ]),
                  ),
                  SizedBox(
                    height: Dim().d8,
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
                        widget.pagetype == 'edit' ?  null : datePicker();
                        setState(() {
                          birtherror = null;
                        });
                      },
                      controller: dobCtrl,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                        ),
                        fillColor: Clr().formfieldbg,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Clr().transparent)),
                        focusColor: Clr().primaryColor,
                        contentPadding: EdgeInsets.all(18),
                        // label: Text('Enter Your Number'),
                        hintText: "Select your birth date",
                        hintStyle: Sty().smallText.copyWith(color: Clr().grey),
                        counterText: "",
                      ),
                    ),
                  ),
                  SizedBox(height: Dim().d4),
                  birtherror == null
                      ? SizedBox.shrink()
                      : Text(birtherror ?? '',
                          style:
                              Sty().mediumText.copyWith(color: Clr().errorRed,fontSize: Dim().d12)),
                  SizedBox(height: Dim().d20),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (index2) {
                            return MultiSelectDialog(
                              items: languagelist.map((e) {
                                return MultiSelectItem(
                                    e.toString(), e.toString());
                              }).toList(),
                              initialValue: addlanguageList,
                              height: 350,
                              width: 450,
                              title: Text(
                                "Select Languages",
                                style: Sty().mediumText.copyWith(
                                      fontSize: Dim().d14,
                                      color: Clr().hintColor,
                                    ),
                              ),
                              selectedColor: Clr().black,
                              onConfirm: (results) {
                                setState(() {
                                  addlanguageList = results;
                                  languageerror = null;
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
                              offset:
                                  Offset(0, 4), // changes position of shadow
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
                              addlanguageList.isNotEmpty
                                  ? 'Languages Selected'
                                  : 'Select Languages',
                              style: Sty().mediumText.copyWith(
                                  color: addlanguageList.isNotEmpty
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
                  languageerror == null
                      ? const SizedBox.shrink()
                      : Text(languageerror ?? '',
                          style:
                              Sty().mediumText.copyWith(color: Clr().errorRed,fontSize: Dim().d16)),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery, 'aadhar');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: DottedBorder(
                        radius: const Radius.circular(10),
                        color: Clr().dottedColor,
                        //color of dotted/dash line
                        strokeWidth: 1,
                        //thickness of dash/dots
                        dashPattern: [6, 4],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/upload.svg',
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: adharPhoto != null
                                        ? 'Aadhaar Front Photo Is Selected'
                                        : widget.data == null
                                            ? 'Aadhaar Card Front Photo Upload'
                                            : widget.data['aadharfront'] != null
                                                ? 'Aadhaar Front Photo Is Selected'
                                                : 'Aadhaar Card Front Photo Upload',
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: adharPhoto != null
                                            ? Clr().black
                                            : widget.data == null
                                                ? Clr().dottedColor
                                                : widget.data['aadharfront'] !=
                                                        null
                                                    ? Clr().black
                                                    : Clr().dottedColor),
                                    children: [
                                      TextSpan(
                                          text: adharPhoto != null
                                              ? ''
                                              : widget.data == null
                                                  ? ' *'
                                                  : widget.data[
                                                              'aadharfront'] !=
                                                          null
                                                      ? ''
                                                      : ' *',
                                          style: TextStyle(
                                              color: Clr().red,
                                              fontWeight: FontWeight.w400))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                    child: adharPhoto != null
                        ? SizedBox.shrink()
                        : Text(adharcarderror ?? '',
                            style: Sty()
                                .mediumText
                                .copyWith(color: Clr().errorRed,fontSize: Dim().d12)),
                  ),
                  InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery, 'aadharback');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: DottedBorder(
                        radius: const Radius.circular(10),
                        color: Clr().dottedColor,
                        //color of dotted/dash line
                        strokeWidth: 1,
                        //thickness of dash/dots
                        dashPattern: [6, 4],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/upload.svg',
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: adharbackPhoto != null
                                        ? 'Aadhaar Back Photo Is Selected'
                                        : widget.data == null
                                            ? 'Aadhaar Back Photo Upload'
                                            : widget.data['aadharback'] != null
                                                ? 'Aadhaar Back Photo Is Selected'
                                                : 'Aadhaar Back Photo Upload',
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: adharbackPhoto != null
                                            ? Clr().black
                                            : widget.data == null
                                                ? Clr().dottedColor
                                                : widget.data['aadharback'] !=
                                                        null
                                                    ? Clr().black
                                                    : Clr().dottedColor),
                                    children: [
                                      TextSpan(
                                          text: adharbackPhoto != null
                                              ? ''
                                              : widget.data == null
                                                  ? ' *'
                                                  : widget.data['aadharback'] !=
                                                          null
                                                      ? ''
                                                      : ' *',
                                          style: TextStyle(
                                              color: Clr().red,
                                              fontWeight: FontWeight.w400,fontSize: Dim().d16))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                    child: adharbackPhoto != null
                        ? SizedBox.shrink()
                        : Text(adharcardbackerror ?? '',
                            style: Sty()
                                .mediumText
                                .copyWith(color: Clr().errorRed,fontSize: Dim().d12)),
                  ),
                  InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery, 'signature');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: DottedBorder(
                        radius: Radius.circular(10),
                        color: Clr().dottedColor,
                        //color of dotted/dash line
                        strokeWidth: 1,
                        //thickness of dash/dots
                        dashPattern: [6, 4],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/upload.svg',
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: signaturePhoto != null
                                        ? 'Signature Photo is selected'
                                        : widget.data == null
                                            ? 'Signature Photo Upload'
                                            : widget.data['signaturephoto'] !=
                                                    null
                                                ? 'Signature Photo is selected'
                                                : 'Signature Photo Upload',
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: signaturePhoto != null
                                            ? Clr().black
                                            : widget.data == null
                                                ? Clr().dottedColor
                                                : widget.data[
                                                            'signaturephoto'] !=
                                                        null
                                                    ? Clr().black
                                                    : Clr().dottedColor),
                                    children: [
                                      TextSpan(
                                          text: signaturePhoto != null
                                              ? ''
                                              : widget.data == null
                                                  ? ' *'
                                                  : widget.data[
                                                              'signaturephoto'] !=
                                                          null
                                                      ? ''
                                                      : ' *',
                                          style: TextStyle(
                                              color: Clr().red,
                                              fontWeight: FontWeight.w400))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  signaturePhoto != null
                      ? SizedBox.shrink()
                      : Text(signatureerror ?? '',
                          style:
                              Sty().mediumText.copyWith(color: Clr().errorRed,fontSize: Dim().d12)),
                  SizedBox(
                    height: Dim().d40,
                  )
                ],
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                     widget.pagetype == 'edit' ? updatePersonalinfo() : _validateForm(ctx);
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
              SizedBox(
                height: Dim().d40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar abbbarlayout(ctx) {
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
        'Personal Information',
        style: Sty().largeText.copyWith(
            color: Clr().appbarTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  // gallery
  getImage(ImageSource source, type) async {
    final photo = await ImagePicker().pickImage(source: source);
    if (photo != null) {
      CroppedFile? file = await ImageCropper().cropImage(
          sourcePath: photo.path,
          compressFormat: ImageCompressFormat.jpg,
          cropStyle:
              type == 'profile' ? CropStyle.circle : CropStyle.rectangle);
      type == 'profile'
          ? setState(() {
              profileImagepath = file!.path.toString();
              imageFile = File(profileImagepath!);
              var image = imageFile!.readAsBytesSync();
              profile = base64Encode(image);
            })
          : type == 'aadhar'
              ? setState(() {
                  File? imageFile = File(file!.path.toString());
                  var image = imageFile.readAsBytesSync();
                  adharPhoto = base64Encode(image);
                })
              : type == 'aadharback'
                  ? setState(() {
                      File? imageFile = File(file!.path.toString());
                      var image = imageFile.readAsBytesSync();
                      adharbackPhoto = base64Encode(image);
                    })
                  : setState(() {
                      File? imageFile = File(file!.path.toString());
                      var image = imageFile.readAsBytesSync();
                      signaturePhoto = base64Encode(image);
                    });
    }
  }

  // validation funtion
  _validateForm(ctx) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool _isValid = formKey.currentState!.validate();

    if (GenderValue == null) {
      setState(() => gendererror = "Gender is required");
      _isValid = false;
    }
    if (dobCtrl.text.isEmpty) {
      setState(() {
        birtherror = "Birth date is required";
      });
      _isValid = false;
    }
    if (addlanguageList.isEmpty) {
      setState(() {
        languageerror = "Languages is required";
      });
      _isValid = false;
    }
    if (adharPhoto == null) {
      setState(() {
        adharcarderror = "Aadhaar Card Front photo is required";
      });
      _isValid = false;
    }
    if (adharbackPhoto == null) {
      setState(() {
        adharcardbackerror = "Aadhaar Card Back photo is required";
      });
      _isValid = false;
    }
    if (signaturePhoto == null) {
      setState(() {
        signatureerror = "Signature photo is required";
      });
      _isValid = false;
    }
    if(profile == null){
      setState(() {
        STM().displayToast('Profile photo is required');
      });
      _isValid = false;
    }
    if (_isValid) {
      // createAccount();
      setState(() {
        sp.setStringList('personalinfo', [
          GenderValue.toString(),
          dobCtrl.text,
          jsonEncode(addlanguageList),
          adharPhoto.toString(),
          adharbackPhoto.toString(),
          signaturePhoto.toString(),
          profile.toString(),
          profileImagepath.toString(),
        ]);
      });
      sp.setBool('hcp_personalinfo', true);
      STM().redirect2page(ctx, ProfessionalInfo());
    }
  }

  // personal profile
  Widget PersonalPhotolayout() {
    return imageFile == null
        ? widget.data == null
            ? Center(
                child: InkWell(
                onTap: () {
                  getImage(ImageSource.gallery, 'profile');
                },
                child: SizedBox(
                  height: Dim().d160,
                  width: Dim().d160,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'assets/hcp_userpng.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ))
            : widget.data['profile'] != null
                ? Center(
                    child: Stack(
                      children: [
                        Container(
                          height: Dim().d160,
                          width: Dim().d160,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${widget.data['profile'].toString()}'),
                                fit: BoxFit.cover),
                            border: Border.all(
                              color: Clr().grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dim().d100),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 2,
                          child: InkWell(
                            onTap: () {
                              getImage(ImageSource.gallery, 'profile');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/hcp_personalphoto.svg',
                                height: Dim().d32,
                                width: Dim().d32,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Center(
                    child: InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery, 'profile');
                    },
                    child: Container(
                      height: Dim().d160,
                      width: Dim().d160,
                      child: Image.asset(
                        'assets/hcp_userpng.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ))
        : Center(
            child: Stack(
              children: [
                Container(
                  height: Dim().d160,
                  width: Dim().d160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(imageFile!), fit: BoxFit.cover),
                    border: Border.all(
                      color: Clr().grey,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dim().d100),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 2,
                  child: InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery, 'profile');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/hcp_personalphoto.svg',
                        height: Dim().d32,
                        width: Dim().d32,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  void updatePersonalinfo() async {
    FormData body = FormData.fromMap({
      'languages': jsonEncode(addlanguageList),
      'gender': GenderValue,
      'dob': dobCtrl.text,
      'aadhaar_first_page': adharPhoto,
      'aadhaar_second_page': adharbackPhoto,
      'signature': signaturePhoto,
      'profile_pic': profile,
    });
   var result = await STM().postWithToken(ctx, Str().updating, 'update_personal', body, hcptoken, 'hcp');
   var success = result['success'];
   var message = result['message'];
   if(success){
     STM().successDialogWithReplace(ctx, message, MyProfile());
   }else{
     STM().errorDialog(ctx, message);
   }
  }
}
