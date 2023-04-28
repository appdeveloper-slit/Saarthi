import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarathi/hcp/preview_prescription.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/strings.dart';
import '../values/styles.dart';

class AddPrescription extends StatefulWidget {
  final Map<String, dynamic> data;

  const AddPrescription(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddPrescriptionPage();
  }
}

class AddPrescriptionPage extends State<AddPrescription> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sToken;

  Map<String, dynamic> v = {};

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController symptomsCtrl = TextEditingController();

  List<dynamic> medicineList = [];

  List<dynamic> testList = [];
  List<dynamic> labList = [null];
  List<dynamic> labArray = [];

  TextEditingController reasonCtrl = TextEditingController();

  @override
  void initState() {
    v = widget.data;
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('hcptoken') ?? '';
      isLoaded = true;
      // STM().checkInternet(context, widget).then((value) {
      //   if (value) {
      //     getData();
      //   }
      // });
    });
  }

  //Api method
  getData() async {
    //Output
    var result = await STM().get(ctx, Str().loading, "get_tests");
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      testList = result['tests'];
    });
  }

  //Api method
  void addData() async {
    //Input
    FormData body = FormData.fromMap({
      'appointment_id': v['id'],
      'prescription': symptomsCtrl.text.trim(),
      'symptoms': symptomsCtrl.text.trim(),
      'medicines': jsonEncode(medicineList),
      // 'test_ids': jsonEncode(labArray),
      'hospitalization': reasonCtrl.text.trim(),
    });
    //Output
    var result = await STM().postWithToken(
        ctx, Str().loading, "add_prescription", body, sToken, 'hcp');
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      STM().successDialogWithAffinity(
          ctx, message, Preview(result['prescription']));
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Clr().white,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Add Prescription',
          style: Sty().largeText.copyWith(
            color: Clr().black,
          ),
        ),
      ),
      body: Visibility(
        visible: isLoaded,
        child: bodyLayout(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Symptoms',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            TextFormField(
              controller: symptomsCtrl,
              cursorColor: Clr().primaryColor,
              style: Sty().mediumText,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              decoration: Sty().textFieldWhiteStyle.copyWith(
                filled: true,
                fillColor: const Color(0xFFFBFBFB),
                hintStyle: Sty().mediumText.copyWith(
                  color: Clr().lightGrey,
                ),
                hintText: "Enter Symptoms",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return Str().invalidEmpty;
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Text(
              "Add Medicine",
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: medicineList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: Dim().d4,
                  ),
                  padding: EdgeInsets.all(
                    Dim().d12,
                  ),
                  decoration: Sty().outlineWhiteBoxStyle.copyWith(
                    color: const Color(0xFFFBFBFB),
                  ),
                  child: Text(
                    'Name : ${medicineList[index]['name']}\nDosage : ${medicineList[index]['dosage']}',
                    style: Sty().mediumText,
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: SvgPicture.asset(
                  "assets/plus.svg",
                ),
                onPressed: () {
                  AwesomeDialog dialog = STM().modalDialog(
                    ctx,
                    medicineDialog(),
                    Clr().white,
                  );
                  dialog.show();
                },
                label: Text(
                  "Add more",
                  style: Sty().smallText.copyWith(
                    color: Clr().primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
            if(false)
              Text(
                "Add Lab Test",
                style: Sty().largeText,
              ),
            if(false)
              SizedBox(
                height: Dim().d4,
              ),
            if(false)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: labList.length,
                itemBuilder: (context, index) {
                  var v = labList[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: Dim().d4,
                    ),
                    decoration: BoxDecoration(
                      color: Clr().white,
                      border: Border.all(
                        color: Clr().lightGrey,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dim().d4,
                      ),
                    ),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          onTap: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          hint: Text(
                            v ?? 'Select Test',
                            style: Sty().mediumText.copyWith(
                              color: Clr().lightGrey,
                            ),
                          ),
                          value: v,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: Sty().mediumText,
                          onChanged: (value) {
                            setState(() {
                              labList[index] = value;
                            });
                          },
                          items: testList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value['id'].toString(),
                              child: Text(
                                value['name'],
                                style: Sty().mediumText,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            if(false)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: SvgPicture.asset(
                    "assets/plus.svg",
                  ),
                  onPressed: () {
                    setState(() {
                      labList.add(null);
                    });
                  },
                  label: Text(
                    "Add more",
                    style: Sty().smallText.copyWith(
                      color: Clr().primaryColor,
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: Dim().d12,
            ),
            Text(
              'Hospitalization',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dim().d12,
                vertical: Dim().d4,
              ),
              decoration: Sty().outlineWhiteBoxStyle.copyWith(
                color: const Color(0xFFFBFBFB),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reason :',
                    style: Sty().smallText,
                  ),
                  TextFormField(
                    controller: reasonCtrl,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: "Enter Reason",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () {
                  setState(() {
                    for (var e in labList) {
                      if (e != null) {
                        labArray.add(e);
                      }
                    }
                  });
                  if (formKey.currentState!.validate()) {
                    STM().checkInternet(context, widget).then((value) {
                      if (value) {
                        if (medicineList.isNotEmpty) {
                          addData();
                        } else {
                          STM().displayToast('Please add medicine');
                        }
                      }
                    });
                  }
                },
                child: Text(
                  'Preview',
                  style: Sty().largeText.copyWith(
                    color: Clr().white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget medicineDialog() {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController dosageCtrl = TextEditingController();
    return StatefulBuilder(builder: (context, setState2) {
      return Padding(
        padding: EdgeInsets.all(Dim().d12),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Add Medicine',
                  style: Sty().largeText.copyWith(
                    color: Clr().primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d32,
              ),
              Text(
                "Name",
                style: Sty().mediumText,
              ),
              SizedBox(
                height: Dim().d4,
              ),
              TextFormField(
                cursorColor: Clr().primaryColor,
                controller: nameCtrl,
                style: Sty().mediumText,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: Sty().textFieldWhiteStyle.copyWith(
                  filled: true,
                  fillColor: const Color(0xFFFBFBFB),
                  hintStyle: Sty().mediumText.copyWith(
                    color: Clr().lightGrey,
                  ),
                  counterText: "",
                  hintText: "Enter Name",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Str().invalidEmpty;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Text(
                'Dosage',
                style: Sty().mediumText,
              ),
              SizedBox(
                height: Dim().d4,
              ),
              TextFormField(
                controller: dosageCtrl,
                cursorColor: Clr().primaryColor,
                style: Sty().mediumText,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                decoration: Sty().textFieldWhiteStyle.copyWith(
                  filled: true,
                  fillColor: const Color(0xFFFBFBFB),
                  hintStyle: Sty().mediumText.copyWith(
                    color: Clr().lightGrey,
                  ),
                  hintText: "Enter Dosage",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Str().invalidEmpty;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: Dim().d32,
              ),
              Center(
                child: SizedBox(
                  width: Dim().d200,
                  child: ElevatedButton(
                    style: Sty().primaryButton,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          medicineList.add({
                            'name': nameCtrl.text.trim(),
                            'dosage': dosageCtrl.text.trim()
                          });
                          STM().back2Previous(context);
                        });
                      }
                    },
                    child: Text(
                      'Add',
                      style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}