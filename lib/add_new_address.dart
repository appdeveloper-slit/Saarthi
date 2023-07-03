import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/strings.dart';
import '../values/styles.dart';
import 'my_address.dart';

class AddNewAddress extends StatefulWidget {
  final details;

  const AddNewAddress({super.key, this.details});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  late BuildContext ctx;
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController firstnameCtrl = TextEditingController();
  TextEditingController pincodeCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  dynamic getuserStatus;
  List<dynamic> cityList = [];
  List<dynamic> stateList = [];
  List<dynamic> pincodeList = [];
  int? stateValue, cityValue;
  String? usertoken;
  String message = 'Check delivery availability in your pincode';
  var success;
  String? pincode, _dropdownError, _dropdownError1;
  final formkey = GlobalKey<FormState>();

  // final _formKey = GlobalKey<FormState>();
  bool again = false;
  String? sUserid;

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      firstnameCtrl = TextEditingController(
          text: widget.details == null ? '' : widget.details['name']);
      mobileCtrl = TextEditingController(
          text: widget.details == null ? '' : widget.details['mobile']);
      addressCtrl = TextEditingController(
          text: widget.details == null ? '' : widget.details['address']);
      pincodeCtrl = TextEditingController(
          text: widget.details == null ? '' : widget.details['pincode']);

      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getCity();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().replacePage(ctx, MyAddressPage());
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
              STM().replacePage(ctx, MyAddressPage());
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
                        return 'Full name is required';
                      }
                    },
                    decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                        hintText: 'Full Name',
                        hintStyle: TextStyle(color: Clr().hintColor)),
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
                        return 'Mobile number is required';
                      }
                      if (value.length != 10) {
                        return 'Mobile Number must be of 10 digit';
                      } else {
                        return null;
                      }
                    },
                    decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                        counterText: "",
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Clr().hintColor)),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          decoration: Sty().TextFormFieldOutlineDarkStyle,
                          value: stateValue,
                          isExpanded: true,
                          hint: Text(
                            'State',
                            style: Sty().mediumText.copyWith(
                                  color: stateValue == null
                                      ? Clr().hintColor
                                      : Clr().black,
                                ),
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          style: TextStyle(color: Color(0xff2D2D2D)),
                          items: stateList.map((string) {
                            return DropdownMenuItem(
                              value: string['id'],
                              child: Text(string['name'],
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().black)),
                            );
                          }).toList(),
                          onChanged: (v) {
                            // STM().redirect2page(ctx, Home());
                            setState(() {
                              stateValue = v as int?;
                              _dropdownError1 = null;
                              int position = int.parse(stateValue.toString());
                              cityList = stateList[position - 1]['city'];
                              cityValue = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _dropdownError1 == null
                    ? Container()
                    : SizedBox(height: Dim().d12),
                _dropdownError1 == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d32),
                        child: Text('${_dropdownError1}',
                            style: Sty()
                                .mediumText
                                .copyWith(color: Clr().errorRed)),
                      ),
                SizedBox(
                  height: Dim().d20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          decoration: Sty().TextFormFieldOutlineDarkStyle,
                          isExpanded: true,
                          value: cityValue,
                          hint: Text(
                            'City',
                            style: Sty().mediumText.copyWith(
                                  color: cityValue == null
                                      ? Clr().hintColor
                                      : Clr().black,
                                ),
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          style: TextStyle(color: Color(0xff2D2D2D)),
                          items: cityList.map((string) {
                            return DropdownMenuItem(
                              value: string['id'],
                              child: Text(string['name'],
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().black)),
                            );
                          }).toList(),
                          onChanged: (v) {
                            // STM().redirect2page(ctx, Home());
                            setState(() {
                              cityValue = v as int?;
                              _dropdownError = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _dropdownError == null
                    ? Container()
                    : SizedBox(height: Dim().d12),
                _dropdownError == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d32),
                        child: Text('${_dropdownError}',
                            style: Sty()
                                .mediumText
                                .copyWith(color: Clr().errorRed)),
                      ),
                SizedBox(
                  height: Dim().d20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: addressCtrl,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Address is required';
                      }
                    },
                    decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                        hintText: 'Address',
                        hintStyle: TextStyle(color: Clr().hintColor)),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: pincodeCtrl,
                    maxLength: 6,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Pincode is required';
                      }
                      if (value.length != 6) {
                        return 'Pincode must be 6 digits';
                      }
                      return null;
                    },
                    decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                        suffixIcon: InkWell(
                          onTap: () {
                            pincodeCtrl.text.isEmpty
                                ? Fluttertoast.showToast(
                                    msg: 'Enter the pincode',
                                    gravity: ToastGravity.CENTER)
                                : checkAvailbility();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Check',
                                style: TextStyle(
                                    fontSize: Dim().d14,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        hintText: 'Pincode',
                        counterText: '',
                        hintStyle: TextStyle(color: Clr().hintColor)),
                  ),
                ),
                if (message.isNotEmpty)
                  SizedBox(
                    height: Dim().d4,
                  ),
                if (message.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: Dim().d20),
                    child: Text(
                      '${message}',
                      style: Sty().smallText.copyWith(
                          fontSize: 12,
                          color: success == false
                              ? Clr().errorRed
                              : Clr().primaryColor),
                    ),
                  ),
                SizedBox(
                  height: Dim().d20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dim().d16,
                  ),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          _validateForm(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Clr().primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'Save location',
                          style: Sty().mediumText.copyWith(
                                color: Clr().white,
                                fontWeight: FontWeight.w600,
                              ),
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

  _validateForm(ctx) {
    bool _isValid = formkey.currentState!.validate();

    if (cityValue == null) {
      setState(() => _dropdownError = "Please select city");
      _isValid = false;
    }
    if (stateValue == null) {
      setState(() {
        _dropdownError1 = "Please select state";
      });
      _isValid = false;
    }
    if (_isValid) {
      addAddress();
    }
  }

  /// add address
  void addAddress() async {
    FormData body = FormData.fromMap({
      'id': widget.details == null ? '' : widget.details['id'],
      'state_id': stateValue,
      'city_id': cityValue,
      'pincode': pincodeCtrl.text,
      'address': addressCtrl.text,
      'name': firstnameCtrl.text,
      'mobile': mobileCtrl.text,
    });
    var result = await STM().postWithToken(
        ctx,
        Str().processing,
        widget.details == null
            ? 'add_shipping_address'
            : 'update_shipping_address',
        body,
        usertoken,
        'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, MyAddressPage());
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getCity() async {
    var result = await STM().getOpen(ctx, Str().loading, 'get_cities');
    var success = result['success'];
    if (success) {
      setState(() {
        stateList = result['cities'];
        if (widget.details != null) {
          stateValue = widget.details['state_id'];
          int position = int.parse(stateValue.toString());
          cityList = stateList[position - 1]['city'];
          cityValue = widget.details['city_id'];
        }
      });
    }
  }

  void checkAvailbility() async {
    FormData body = FormData.fromMap({
      'pincode': pincodeCtrl.text,
    });
    var result = await STM().postWithToken(ctx, Str().processing,
        'check_availability', body, usertoken, 'customer');
    success = result['success'];
    if (success) {
      setState(() {
        message = result['message'];
      });
    } else {
      setState(() {
        message = result['message'];
      });
    }
  }
}
