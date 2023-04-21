import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/values/dimens.dart';

import '../manage/static_method.dart';
import '../physical_details.dart';
import '../values/colors.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'values/strings.dart';


class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late BuildContext ctx;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();


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
        String s = STM().dateFormat('dd-MM-yyyy', picked);
        dobCtrl = TextEditingController(text: s);
      });
    }
  }

  String GenderValue = 'Gender';
  List<String> genderList = ['Gender', 'Female'];
  String t = "0";

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return  Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
        appBar: AppBar(
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
            'My Profile',
            style: Sty().largeText.copyWith(
                color: Clr().appbarTextColor, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              SizedBox(
                height:Dim().d20,
              ),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile.png'),
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
                          child: SvgPicture.asset('assets/cam.svg'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mobile Number", style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  // TextFormField(
                  //   // controller: mobileCtrl,
                  //   keyboardType: TextInputType.name,
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //
                  //     fillColor: Clr().lightGrey,
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: BorderSide(color: Clr().transparent)),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Clr().grey, width: 1.0),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     contentPadding:
                  //     EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  //     // label: Text('Enter Your Number'),
                  //     hintText: "Name",
                  //     suffixIcon: InkWell(
                  //       onTap: (){},
                  //       child: Padding(
                  //           padding:  EdgeInsets.only(right: 15,top: 15,bottom: 15),
                  //           child: SvgPicture.asset('assets/editprofile.svg',)
                  //       ),
                  //     ),
                  //     hintStyle: Sty().mediumText.copyWith(
                  //       color: Clr().shimmerColor,
                  //     ),
                  //     counterText: "",
                  //   ),
                  // ),

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
                      // controller: mobileCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Clr().formfieldbg,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Clr().primaryColor, width: 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(18),
                        // label: Text('Enter Your Number'),
                        hintText: "Enter Mobile Number",
                        counterText: "",
                      ),
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'([5-9]{1}[0-9]{9})')
                                .hasMatch(value)) {
                          return Str().invalidMobile;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  SizedBox(
                    height:Dim().d20,
                  ),
                  Text("Email ID", style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),),
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
                          offset: Offset(0, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      // controller: mobileCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Clr().formfieldbg,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Clr().primaryColor, width: 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(18),
                        // label: Text('Enter Your Number'),
                        hintText: "Enter Email ID",
                        counterText: "",
                      ),
                    ),
                  ),

                  SizedBox(
                    height:Dim().d20,
                  ),
                  Text("Gender", style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Clr().grey)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: GenderValue,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 28,
                          color: Clr().grey,
                        ),
                        style: TextStyle(color: Color(0xff787882)),
                        items: genderList.map((String string) {
                          return DropdownMenuItem<String>(
                            value: string,
                            child: Text(
                              string,
                              style:
                              TextStyle(color: Color(0xff787882), fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (t) {
                          // STM().redirect2page(ctx, Home());
                          setState(() {
                            GenderValue = t!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height:Dim().d20,),
                  Text("Date of birth", style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () {
                      datePicker();
                    },
                    controller: dobCtrl,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Pickup date is required';
                      }
                    },
                    // controller: mobileCtrl,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_month),
                      fillColor: Clr().lightGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(

                            color: Clr().grey,width: 0.1),
                      ),enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Clr().grey)
                    ),focusColor: Clr().grey,

                      contentPadding: EdgeInsets.all(18),
                      // label: Text('Enter Your Number'),
                      hintText: "Date of birth*",
                      counterText: "",
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, PhysicalDetails());
                      // if (formKey.currentState!
                      //     .validate()) {
                      //   STM()
                      //       .checkInternet(
                      //       context, widget)
                      //       .then((value) {
                      //     if (value) {
                      //       sendOtp();
                      //     }
                      //   });
                      // }
                    },
                    style: ElevatedButton.styleFrom( elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10))),
                    child: Text(
                      'Update Profile',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,),
                    )),
              ),
              SizedBox(height:Dim().d20,),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      // STM().redirect2page(ctx, SignUp());
                    },
                    style: ElevatedButton.styleFrom( elevation: 0,

                        backgroundColor: Colors.white,
                        side:
                        BorderSide(width: 1, color: Clr().primaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Delete my account',
                      style: Sty().mediumText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w500),
                    )),
              ),
              SizedBox(height:Dim().d20,),

            ],
          ),
        ),
      );

  }
}
