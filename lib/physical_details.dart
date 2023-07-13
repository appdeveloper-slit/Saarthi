import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/select_location.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manage/static_method.dart';
import 'upload_documents.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class PhysicalDetails extends StatefulWidget {
  final String? customerID;
  final String? sType;

  const PhysicalDetails({super.key, this.customerID, this.sType});

  @override
  State<PhysicalDetails> createState() => _PhysicalDetailsState();
}

class _PhysicalDetailsState extends State<PhysicalDetails> {
  late BuildContext ctx;
  String? sDietValue;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController weightCtrl = TextEditingController();
  TextEditingController heightCtrl = TextEditingController();
  List<String> dietList = ['Veg', 'Non-Veg'];
  String t = "0";
  String? selectedValue;
  List<String> arrayList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
  String? selectedValue2;
  List<String> arrayList2 = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];

  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        widget.sType == 'home' ? showCustomerEdit() : null;
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
      appBar: appbarLayout(ctx),
      body: widget.sType == 'home'
          ? WillPopScope(
              child: homeLayout(ctx),
              onWillPop: () async {
                STM().back2Previous(ctx);
                return false;
              })
          : DoubleBack(
              message: 'Press back again to exit', child: homeLayout(ctx)),
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
                controller: weightCtrl,
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
                  hintText: "Body Weight",
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
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: selectedValue,
                    hint: Text(selectedValue ?? 'Height_ft'),
                    isExpanded: true,
                    decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: Dim().d16, horizontal: Dim().d12),
                        filled: true,
                        fillColor: Clr().white),
                    icon: const Icon(Icons.arrow_drop_down_rounded,
                        color: Colors.grey),
                    // icon: SvgPicture.asset( "assets/dropdown.svg",height:6,width:10),
                    style: const TextStyle(color: Color(0xff2D2D2D)),
                    validator: (value) {
                      if (value == null) {
                        return 'This field is required';
                      }
                    },
                    items: arrayList.map((String string) {
                      return DropdownMenuItem<String>(
                        value: string,
                        child: Text(
                          string,
                          style: const TextStyle(
                              color: Color(0xff2D2D2D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    }).toList(),
                    onChanged: (t) {
                      // STM().redirect2page(ctx, Home());
                      setState(() {
                        selectedValue = t!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: Dim().d16,
                ),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: selectedValue2,
                    hint: Text(selectedValue2 ?? 'Height_in'),
                    isExpanded: true,
                    decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: Dim().d16, horizontal: Dim().d12),
                        filled: true,
                        fillColor: Clr().white),
                    icon: const Icon(Icons.arrow_drop_down_rounded,
                        color: Colors.grey),
                    // icon: SvgPicture.asset( "assets/dropdown.svg",height:6,width:10),
                    style: const TextStyle(color: Color(0xff2D2D2D)),
                    validator: (value) {
                      if (value == null) {
                        return 'This field is required';
                      }
                    },
                    items: arrayList2.map((String string) {
                      return DropdownMenuItem<String>(
                        value: string,
                        child: Text(
                          string,
                          style: const TextStyle(
                              color: Color(0xff2D2D2D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    }).toList(),
                    onChanged: (t) {
                      // STM().redirect2page(ctx, Home());
                      setState(() {
                        selectedValue2 = t!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dim().d20,
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
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Clr().transparent)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sDietValue,
                  isExpanded: true,
                  hint: Text(
                    'Select Diet',
                    style: Sty().mediumText.copyWith(color: Clr().shimmerColor),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Clr().grey,
                  ),
                  style: const TextStyle(color: Color(0xff787882)),
                  items: dietList.map((String string) {
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
                      sDietValue = t!;
                    });
                  },
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
                  onPressed: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        sp.setBool('physical', true);
                        sp.setStringList('physicallist', [
                          selectedValue!,
                          selectedValue2!,
                          sDietValue.toString(),
                          weightCtrl.text
                        ]);
                      });
                      widget.sType == 'home'
                          ? editCustomer()
                          : STM().redirect2page(
                              ctx,
                              SelectLocation(
                                heightCtrl: heightCtrl.text,
                                sDietValue: sDietValue,
                                weightCtrl: weightCtrl.text,
                              ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    widget.sType == 'home' ? 'Update' : 'Submit',
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

  AppBar appbarLayout(ctx) {
    return AppBar(
      elevation: 2,
      backgroundColor: Clr().white,
      leading: widget.sType == 'home'
          ? InkWell(
              onTap: () {
                STM().back2Previous(ctx);
              },
              child: Icon(
                Icons.arrow_back_rounded,
                color: Clr().appbarTextColor,
              ),
            )
          : Container(),
      centerTitle: true,
      title: Text(
        'Physical Details',
        style: Sty().largeText.copyWith(
            color: Clr().appbarTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  void showCustomerEdit() async {
    var result = await STM()
        .getWithToken(ctx, Str().loading, 'showCustomerEdit', usertoken);
    setState(() {
      weightCtrl = TextEditingController(text: result['data']['weight']);
      selectedValue = result['data']['height_in_feet'];
      selectedValue2 = result['data']['height_in_inch'];
      sDietValue = result['data']['diet'];
    });
  }

  void editCustomer() async {
    FormData body = FormData.fromMap({
      'weight': weightCtrl.text,
      'height_in_feet': selectedValue,
      'height_in_inch': selectedValue2,
      'diet': sDietValue,
    });
    var result = await STM().postWithToken(ctx, Str().updating, 'customerEdit', body, usertoken,'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithAffinity(ctx, message, Home());
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
