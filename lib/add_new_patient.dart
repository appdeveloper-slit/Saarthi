import 'package:flutter/material.dart';
import 'package:saarathi/values/dimens.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'review_apt_ol.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class AddNewPatient extends StatefulWidget {
  @override
  State<AddNewPatient> createState() => _AddNewPatientState();
}

class _AddNewPatientState extends State<AddNewPatient> {
  late BuildContext ctx;

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

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();

  String RelationValue = 'Relation';
  List<String> RelationList = [
    'Relation',
    'Mother',
    'Father',
    'Sister',
    'Brother',
  ];
  String t = "0";

  String GenderValue = 'Gender';
  List<String> GenderList = [
    'Gender',
    'Male',
    'Female',
  ];
  String v = "0";

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      backgroundColor: Clr().white,
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
          'Add new patient',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            TextFormField(
              // controller: mobileCtrl,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                fillColor: Clr().grey,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Clr().grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Clr().grey, width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                contentPadding: EdgeInsets.all(16),
                // label: Text('Enter Your Number'),
                hintText: "Full name",
                hintStyle: Sty().mediumText.copyWith(
                      color: Clr().shimmerColor,
                    ),
                counterText: "",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Clr().grey, width: 0.7)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: RelationValue,
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Clr().grey,
                  ),
                  style: TextStyle(color: Color(0xff787882)),
                  items: RelationList.map((String string) {
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
                      RelationValue = t!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Clr().grey, width: 0.7)),
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
                  items: GenderList.map((String string) {
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
                      GenderValue = v!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
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
                fillColor: Clr().transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Clr().grey, width: 0.1),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Clr().grey)),
                focusColor: Clr().grey,
                contentPadding: EdgeInsets.all(18),
                // label: Text('Enter Your Number'),
                hintText: "Date of birth*",
                counterText: "",
              ),
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    STM().redirect2page(ctx, OnlineConsultation());
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
}
