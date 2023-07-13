import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saarathi/dr_name.dart';
import 'package:saarathi/payment_summary.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class AddNewPatient extends StatefulWidget {
  final dynamic doctorDetails;
  final stype;

  const AddNewPatient({super.key, this.doctorDetails, this.stype});

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
  TextEditingController nameCtrl = TextEditingController();

  int? RelationValue;
  List<Map<String, dynamic>> RelationList = [
    {"id": 1, "name": "Father"},
    {"id": 2, "name": "Mother"},
    {"id": 3, "name": "Brother"},
    {"id": 4, "name": "Sister"},
    {"id": 5, "name": "Husband"},
    {"id": 6, "name": "Wife"},
    {"id": 7, "name": "Daughter"},
    {"id": 8, "name": "Son"},
    {"id": 9, "name": "Other"}
  ];

  String? GenderValue;
  List<String> GenderList = [
    'Male',
    'Female',
  ];
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        print(usertoken);
      }
    });
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
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: Dim().d8,
              ),
              TextFormField(
                controller: nameCtrl,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Full name is required';
                  }
                },
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
                height: Dim().d20,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  value: RelationValue,
                  isExpanded: true,
                  hint: Text(
                    'Select Relation',
                    style: Sty().smallText.copyWith(
                          color: Clr().shimmerColor,
                        ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Clr().grey,
                  ),
                  validator: (v) {
                    if (v == null) {
                      return 'Relation is required';
                    }
                  },
                  decoration: Sty().TextFormFieldOutlineDarkStyle,
                  style: TextStyle(color: Clr().black),
                  items: RelationList.map((string) {
                    return DropdownMenuItem(
                      value: string['id'],
                      child: Text(
                        string['name'],
                        style: TextStyle(color: Clr().black, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (t) {
                    // STM().redirect2page(ctx, Home());
                    setState(() {
                      RelationValue = t as int?;
                    });
                  },
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  hint: Text(
                    GenderValue ?? 'Select Gender',
                    style: Sty().smallText.copyWith(
                          color: Clr().black,
                        ),
                  ),
                  isExpanded: true,
                  decoration: Sty().TextFormFieldOutlineDarkStyle,
                  validator: (v){
                    if(v == null){
                      return 'Gender is required';
                    }
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Clr().grey,
                  ),
                  style: TextStyle(color: Color(0xff787882)),
                  items: GenderList.map((string) {
                    return DropdownMenuItem(
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
                      GenderValue = t as String;
                    });
                  },
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
                    return 'Date of birth is required';
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
                      if(formKey.currentState!.validate()){
                        addPatient();
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
      ),
    );
  }

  // add patient

  void addPatient() async {
    FormData body = FormData.fromMap({
      'full_name': nameCtrl.text,
      'relation_id': RelationValue,
      'gender': GenderValue,
      'dob': dobCtrl.text,
    });
    var result = await STM().postWithToken(
        ctx, Str().processing, 'add_patient', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.stype == 'lab') {
        STM().back2Previous(ctx);
        PaymentSummarypage.controller2.sink.add('update');
      } else if (widget.stype == 'edit') {
        STM().back2Previous(ctx);
        DrNamepage.controller1.sink.add('update');
      } else {
        STM().successDialogWithReplace(ctx, message, DrName(doctorDetails: widget.doctorDetails));
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
