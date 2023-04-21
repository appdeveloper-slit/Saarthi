import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/strings.dart';
import '../values/styles.dart';
import 'my_address.dart';

class AddNewAddress extends StatefulWidget {

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  late BuildContext ctx;
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController firstnameCtrl = TextEditingController();
  dynamic getuserStatus;
  List<dynamic> cityList = [];
  List<dynamic> statelist = [];
  List<dynamic> pincodeList = [];
  String? stateValue;
  String? cityValue;
  String? pincode;
  final formkey = GlobalKey<FormState>();
   // final _formKey = GlobalKey<FormState>();
  bool again = false;


  String? sUserid;


  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
        // bottomNavigationBar: bottomBarLayout(ctx, 2),
        appBar: AppBar(
          elevation: 2,

          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              STM().back2Previous(ctx);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Clr().black,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Add new address",
            // widget.sType == 'addAddress'?
            // 'Add new address':'Update Address',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: formkey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                SizedBox(
                  height: Dim().d20,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: firstnameCtrl,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                    },
                    decoration: Sty().TextFormFieldUnderlineStyle.copyWith(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                ),

                SizedBox(
                  height: Dim().d20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: TextFormField(
                    controller: mobileCtrl,

                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Mobile field required';
                      }
                      if (value.length != 10) {
                        return 'Mobile Number must be of 10 digit';
                      } else {
                        return null;
                      }
                    },
                    decoration: Sty().TextFormFieldUnderlineStyle.copyWith(
                        counterText: "",
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Clr().black)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                              horizontal: Dim().d14,
                            )),
                            value: stateValue,
                            isExpanded: true,
                            hint: Text(
                              stateValue ?? 'State',
                              style: Sty().mediumText.copyWith(
                                    color: Color(0xff2D2D2D),
                                  ),
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            style: TextStyle(color: Color(0xff2D2D2D)),
                            items: statelist.map((string) {
                              return DropdownMenuItem<String>(
                                value: string['id'].toString(),
                                child: Text(string['name'].toString(),
                                    style: Sty()
                                        .mediumText
                                        .copyWith(color: Clr().black)),
                              );
                            }).toList(),
                            onChanged: (v) {
                              // STM().redirect2page(ctx, Home());
                              setState(() {
                                stateValue = v!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dim().d14,
                                )),
                            isExpanded: true,
                            hint: Text(
                              cityValue ?? 'City',
                              style: Sty().mediumText.copyWith(
                                color: Color(0xff2D2D2D),
                              ),
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            style: TextStyle(color: Color(0xff2D2D2D)),
                            items: cityList.map((string) {
                              return DropdownMenuItem<String>(
                                value: string['id'].toString(),
                                child: Text(string['name'].toString(),
                                    style: Sty()
                                        .mediumText
                                        .copyWith(color: Clr().black)),
                              );
                            }).toList(),
                            onChanged: (v) {
                              // STM().redirect2page(ctx, Home());
                               setState(() {
                                cityValue = v!;
                               });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dim().d14,
                                )),
                            isExpanded: true,
                            hint: Text(
                              pincode ?? 'Pincode',
                              style: Sty().mediumText.copyWith(
                                color: Color(0xff2D2D2D),
                              ),
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            style: TextStyle(color: Color(0xff2D2D2D)),
                            items: pincodeList.map((string) {
                              return DropdownMenuItem<String>(
                                value: string['pincode'].toString(),
                                child: Text(string['pincode'].toString(),
                                    style: Sty()
                                        .mediumText
                                        .copyWith(color: Clr().black)),
                              );
                            }).toList(),
                            onChanged: (v) {
                              pincode = v!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d16,),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(

                        onPressed: () {
                          // STM().redirect2page(ctx, Home());
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
                          if (formkey.currentState!.validate()) {
                            // updateUser();
                            // widget.sType == 'addAddress'? getaddAddress():getUpdateAddress();
                          }
                        },
                        style: ElevatedButton.styleFrom( elevation: 0,
                            backgroundColor: Clr().primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10))),
                        child: Text(
                          'Save location',
                          style: Sty().mediumText.copyWith(
                            color: Clr().white,
                            fontWeight: FontWeight.w600,),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
