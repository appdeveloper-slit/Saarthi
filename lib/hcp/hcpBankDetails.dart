import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saarathi/hcp/hcpMyprofile.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/styles.dart';

class AddBankDetails extends StatefulWidget {
  @override
  State<AddBankDetails> createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  late BuildContext ctx;
  TextEditingController banknameCtrl = TextEditingController();
  TextEditingController accountnumberCtrl = TextEditingController();
  TextEditingController linkednumCtrl = TextEditingController();
  TextEditingController ifsccodeCtrl = TextEditingController();
  TextEditingController branchnameCtrl = TextEditingController();
  TextEditingController accountholdderCtrl = TextEditingController();
  String? hcptoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getBankdetails();
        print(hcptoken);
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

    return WillPopScope(onWillPop: () async{
      STM().back2Previous(ctx);
      return false;
    },
      child: Scaffold(
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
            'Add Bank Details',
            style: Sty().largeText.copyWith(color: Clr().black),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 12,),
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
                child: Container(
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
                    controller: banknameCtrl,
                    keyboardType: TextInputType.text,
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
                      hintText: "Bank Name",
                      hintStyle: TextStyle(
                        color: Clr().dottedColor,
                        fontSize: 14,
                      ),
                      counterText: "",
                    ),
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
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
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
                    controller: accountnumberCtrl,
                    keyboardType: TextInputType.number, maxLength: 18,
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
                      hintText: "Account Number",
                      hintStyle: TextStyle(
                        color: Clr().dottedColor,
                        fontSize: 14,
                      ),
                      counterText: "",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                child: Container(
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
                    controller: linkednumCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
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
                      hintText: "Linked Mobile Number",
                      hintStyle: TextStyle(
                        color: Clr().dottedColor,
                        fontSize: 14,
                      ),
                      counterText: "",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                child: Container(
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
                    controller: ifsccodeCtrl,
                    keyboardType: TextInputType.text,
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
                      hintText: "IFSC Code",
                      hintStyle: TextStyle(
                        color: Clr().dottedColor,
                        fontSize: 14,
                      ),
                      counterText: "",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                child: Container(
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
                    controller: branchnameCtrl,
                    keyboardType: TextInputType.text,
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
                      hintText: "Branch Name",
                      hintStyle: TextStyle(
                        color: Clr().dottedColor,
                        fontSize: 14,
                      ),
                      counterText: "",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                child: Container(
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
                    controller: accountholdderCtrl,
                    keyboardType: TextInputType.text,
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
                      hintText: "Account holder name",
                      hintStyle: TextStyle(
                        color: Clr().dottedColor,
                        fontSize: 14,
                      ),
                      counterText: "",
                    ),
                  ),
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
                      addBankdetails();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Save Details',
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

  void addBankdetails() async {
    FormData body = FormData.fromMap({
    'bank_name': banknameCtrl.text,
    'account_number': accountnumberCtrl.text,
    'mobile': linkednumCtrl.text,
    'ifsc_code': ifsccodeCtrl.text,
    'branch_name': branchnameCtrl.text,
    'account_holder_name':accountholdderCtrl.text,
    });
    var result = await STM().postWithToken(ctx, Str().processing, 'add_bank', body, hcptoken, 'hcp');
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().successDialogWithReplace(ctx, message, MyProfile());
    }else{
      STM().errorDialog(ctx, message);
    }
  }

  void getBankdetails() async {
    var result = await STM().getWithTokenUrl(ctx, Str().loading, 'get_bank', hcptoken, 'hcp');
    var success = result['success'];
    if(success){
      setState(() {
        banknameCtrl = TextEditingController(text: result['bank']['bank_name'].toString());
        accountnumberCtrl = TextEditingController(text: result['bank']['account_number'].toString());
        linkednumCtrl = TextEditingController(text: result['bank']['mobile'].toString());
        ifsccodeCtrl = TextEditingController(text: result['bank']['ifsc_code'].toString());
        branchnameCtrl = TextEditingController(text: result['bank']['branch_name'].toString());
        accountholdderCtrl = TextEditingController(text: result['bank']['account_holder_name'].toString());

      });
    }
  }

}
