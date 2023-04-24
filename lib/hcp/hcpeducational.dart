import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:saarathi/hcp/hcpMyprofile.dart';
import 'package:saarathi/hcp/hcpprofessional.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/strings.dart';
import '../values/styles.dart';
import 'hcpappointmentavailability.dart';

class EducationalInfo extends StatefulWidget {
  final pagetype;
  dynamic data;
  dynamic professionaldata;
   EducationalInfo({super.key, this.pagetype,this.data,this.professionaldata});
  @override
  State<EducationalInfo> createState() => _EducationalInfoState();
}

class _EducationalInfoState extends State<EducationalInfo> {
  late BuildContext ctx;
  String? specialityValue;
  TextEditingController registerCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<File> imagelist = [];
  List<String> certificateList = [];
  List<dynamic> adddegreeList = [];
  String? degreeerror,
      dregreecertificateerror,
      registrationcertificateerror,
      registrationcertificate;
  List<String> dregreecertificat = [];
  List<dynamic> specialList = [];
  String v = "0";

  String? hcptoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    widget.data == null ? null : setState((){
      adddegreeList = widget.data['degree_name'];
      registerCtrl = TextEditingController(text: widget.professionaldata['registration_number'].toString());

    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getDegree();
        print(hcptoken);
      }
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
    return WillPopScope(
      onWillPop: () async {
        widget.pagetype =='edit'? STM().back2Previous(ctx) : STM().replacePage(ctx, ProfessionalInfo());
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              widget.pagetype =='edit'? STM().back2Previous(ctx) : STM().replacePage(ctx, ProfessionalInfo());
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Clr().appbarTextColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Educational Information',
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
                      'Step 3 of 3',
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
                        text: 'Degree',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text: ' *', style: TextStyle(color: Clr().red))
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
                                    e['name'].toString(), e['name'].toString());
                              }).toList(),
                              initialValue: adddegreeList,
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
                                  adddegreeList = results;
                                  degreeerror = null;
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
                                  Offset(0, 8), // changes position of shadow
                            ),
                          ],
                          color: Clr().formfieldbg,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              adddegreeList.isNotEmpty
                                  ? 'Degrees Selected'
                                  : 'Select Degree',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: adddegreeList.isNotEmpty ? Clr().black : const Color(0xff787882)),
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
                  degreeerror == null
                      ? SizedBox.shrink()
                      : Text(
                          degreeerror ?? '',
                          style:
                              Sty().mediumText.copyWith(color: Clr().errorRed),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      multiplefilepicker();
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
                                    text: certificateList.isNotEmpty
                                        ? '${certificateList.length} Degrees Certificates Selected'
                                        : widget.data == null ? 'Degree Certificates' : widget.data['degree_certi'] != null ? 'Degrees Certificates Selected'  : 'Degree Certificates',
                                    style: Sty().mediumText.copyWith(color: certificateList.isNotEmpty ? Clr().black : widget.data == null ? Clr().dottedColor : widget.data['degree_certi'] != null ? Clr().black : Clr().dottedColor, fontWeight: FontWeight.w600, fontSize: Dim().d14),
                                    children: [
                                      TextSpan(
                                          text: certificateList.isNotEmpty ? '' :  widget.data == null ? ' *' : widget.data['degree_certi'] != null ? '' : ' *',
                                          style: TextStyle(color: Clr().red))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  dregreecertificat != null
                      ? SizedBox.shrink()
                      : Text(dregreecertificateerror ?? '',
                          style:
                              Sty().mediumText.copyWith(color: Clr().errorRed)),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Registration Number',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text: ' *', style: TextStyle(color: Clr().red))
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
                      controller: registerCtrl,
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
                        hintText: "Enter Registration Number",
                        hintStyle: Sty().mediumText.copyWith(
                              color: Clr().shimmerColor,
                            ),
                        counterText: "",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Registration number is required';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery, 'registration');
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
                                width: 20,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: registrationcertificate != null
                                        ? 'Registration Certificate Selected'
                                        :  widget.professionaldata == null ? 'Registration Certificate'  :widget.professionaldata['registration_certi'] != null ? 'Registration Certificate Selected' : 'Registration Certificate',
                                    style: Sty().mediumText.copyWith(
                                        color:  registrationcertificate != null ? Clr().black : widget.professionaldata == null ? Clr().dottedColor :  widget.professionaldata['registration_certi'] != null ? Clr().black : Clr().dottedColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Dim().d14),
                                    children: [
                                      TextSpan(
                                          text:  registrationcertificate != null ? '' : widget.professionaldata == null ? ' *' : widget.professionaldata['registration_certi'] != null ? '' : ' *',
                                          style: TextStyle(color: Clr().red))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  registrationcertificate == null
                      ? SizedBox.shrink()
                      : Text(registrationcertificateerror ?? '',
                          style:
                              Sty().mediumText.copyWith(color: Clr().errorRed)),
                  SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                          onPressed: () async{
                            SharedPreferences sp = await SharedPreferences.getInstance();
                            if (formKey.currentState!.validate()) {
                              widget.pagetype == 'edit'?  updateProffessionalinfo() : _validateForm(ctx);
                            }
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
                ],
              ),
            )),
      ),
    );
  }

  // validation funtion
  _validateForm(ctx) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool _isValid = formKey.currentState!.validate();
    if (adddegreeList.isEmpty) {
      setState(() => degreeerror = "Degree is required");
      _isValid = false;
    }
    if (certificateList.isEmpty) {
      setState(() {
        dregreecertificateerror = "Degree certificate is required";
      });
      _isValid = false;
    }
    if (registrationcertificate == null) {
      setState(() {
        registrationcertificateerror = "Registration certificate is required";
      });
      _isValid = false;
    }
    if (_isValid) {
      hcpAdd();
    }
  }

  // gallery
  getImage(ImageSource source, type) async {
    final photo = await ImagePicker().pickImage(source: source);
    if (photo != null) {
      CroppedFile? file = await ImageCropper().cropImage(
          sourcePath: photo.path, compressFormat: ImageCompressFormat.jpg);
      type == 'certificate'
          ? setState(() {
              File? imageFile = File(file!.path.toString());
              var image = imageFile.readAsBytesSync();
              dregreecertificat = base64Encode(image) as List<String>;
            })
          : setState(() {
              File? imageFile = File(file!.path.toString());
              var image = imageFile.readAsBytesSync();
              registrationcertificate = base64Encode(image);
            });
    }
  }

  // allows multiple image picker
  void multiplefilepicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      imagelist = result.paths.map((path) => File(path!)).toList();
      var image;
      for (var a = 0; a < imagelist.length; a++) {
        setState(() {
          image = imagelist[a].readAsBytesSync();
          certificateList.add(base64Encode(image).toString());
        });
      }
      print(certificateList.length);
    }
  }

  // hcp add
  void hcpAdd() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List professionalist = sp.getStringList('professionallist') ?? [];
    List personalList = sp.getStringList('personalinfo') ?? [];
    FormData body = FormData.fromMap({
      "languages": personalList[2],
      "gender": personalList[0],
      "dob": personalList[1],
      "aadhaar_first_page": personalList[3],
      "aadhaar_second_page": personalList[4],
      "signature": personalList[5],
      "profile_pic": personalList[6],
      "category_ids": professionalist[0],
      "speciality_ids": professionalist[1],
      "contact_no": professionalist[2],
      "address": professionalist[3],
      "experience": professionalist[4],
      "latitude": professionalist[5],
      "longitude": professionalist[6],
      "map_address": professionalist[7],
      "registration_number": registerCtrl.text,
      "registration_certi": registrationcertificate,
      "degree_name": jsonEncode(adddegreeList),
      "degree_certi": jsonEncode(certificateList),
      "user_type": "1"
    });
    var result = await STM().postWithToken(ctx, Str().processing, 'hcpAdd', body, hcptoken, 'hcp');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithAffinity(ctx, message, ApptAvailability());
      sp.setBool('hcp_educationalinfo', true);
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void updateProffessionalinfo() async {
    FormData body = FormData.fromMap({
    'degree_name': jsonEncode(adddegreeList),
    'registration_number':registerCtrl.text,
    'registration_certi': registrationcertificate,
    'degree_certi': jsonEncode(certificateList),
    });
    var result = await STM().postWithToken(ctx, Str().updating, 'update_education', body, hcptoken, 'hcp');
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().successDialogWithReplace(ctx, message, MyProfile());
    }else{
      STM().errorDialog(ctx, message);
    }
  }

  void getDegree() async {
    var result = await STM().getOpen(ctx, Str().loading, 'get_degree');
    var success = result['success'];
    if (success) {
      setState(() {
        specialList = result['get_degree'];
      });
    }
  }

}
