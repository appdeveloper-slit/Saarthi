import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/hcp/hcpappointmentavailability.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

class OlConsSlots extends StatefulWidget {
  final type;
  final stypename;
  final pageType;
  final dynamic appoinmentdetails;
  const OlConsSlots({super.key, this.type, this.stypename,this.pageType,this.appoinmentdetails});

  @override
  State<OlConsSlots> createState() => _OlConsSlotsState();
}

class _OlConsSlotsState extends State<OlConsSlots> {
  late BuildContext ctx;
  int selected = -1;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController dobCtrl1 = TextEditingController();
  TextEditingController servicechargesCtrl = TextEditingController();

  List<dynamic> slotList = [];
  List<dynamic> selectedSlotList = [];

  List<Map<String, dynamic>> OnlineSelectionList = [
    {
      'day': null,
      'slots': [],
    }
  ];
  bool slotcheck = false;
  var day;
  List<dynamic> dayList = [
    {"id": "1", "name": "Monday"},
    {"id": "2", "name": "Tuesday"},
    {"id": "3", "name": "Wednesday"},
    {"id": "4", "name": "Thursday"},
    {"id": "5", "name": "Friday"},
    {"id": "6", "name": "Saturday"},
    {"id": "7", "name": "Sunday"},
  ];

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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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

  Future datePicker1() async {
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('dd-MM-yyyy', picked);
        dobCtrl1 = TextEditingController(text: s);
      });
    }
  }

  bool _switchValue = true;
  String? hcptoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    widget.appoinmentdetails == null ? null : setState(() {
      _switchValue = widget.appoinmentdetails['is_enabled'] == 1 ? true : false;
      servicechargesCtrl = TextEditingController(text: widget.appoinmentdetails['charge'].toString());
      dobCtrl = TextEditingController(text: widget.appoinmentdetails['from_date']);
      dobCtrl1 = TextEditingController(text: widget.appoinmentdetails['to_date']);
      OnlineSelectionList.clear();
      for(int a = 0; a < widget.appoinmentdetails['slots'].length; a++){
        OnlineSelectionList.add({
          'day': widget.appoinmentdetails['slots'][a]['day'],
          'slots': widget.appoinmentdetails['slots'][a]['slots'],
        });
      }
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getSlots();
        print(hcptoken);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
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
          '${widget.stypename} Consultation Slots',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Are you willing to take ${widget.stypename} Consultation?',
                    style: Sty().mediumText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                CupertinoSwitch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                    print(_switchValue);
                  },
                ),
              ],
            ),
            SizedBox(
              height: Dim().d12,
            ),
            const Divider(),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'Service Charge (30 mins)',
              style: Sty().mediumText,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(
              height: Dim().d12,
            ),
            TextFormField(
              controller: servicechargesCtrl,
              cursorColor: Clr().primaryColor,
              style: Sty().mediumText,
              keyboardType: TextInputType.number,
              decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle:
                        Sty().mediumText.copyWith(color: Clr().lightGrey),
                    prefix: Text(
                      '₹',
                      style: Sty().mediumText.copyWith(
                            color: Color(0xffB7B7B7),
                            fontSize: 18,
                          ),
                    ),
                  ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Unavailable Dates',
              style: Sty().mediumText,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Clr().borderColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(Dim().d12),
                          child: SvgPicture.asset('assets/calender.svg'),
                        ),
                        fillColor: Clr().formfieldbg,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Clr().transparent)),
                        focusColor: Clr().primaryColor,
                        contentPadding: EdgeInsets.all(18),
                        // label: Text('Enter Your Number'),
                        hintText: "dd-mm-yy",
                        counterText: "",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dim().d12,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Clr().borderColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        datePicker1();
                      },
                      controller: dobCtrl1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Pickup date is required';
                        }
                      },
                      // controller: mobileCtrl,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(Dim().d12),
                          child: SvgPicture.asset('assets/calender.svg'),
                        ),
                        fillColor: Clr().formfieldbg,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Clr().transparent)),
                        focusColor: Clr().primaryColor,
                        contentPadding: EdgeInsets.all(18),
                        // label: Text('Enter Your Number'),
                        hintText: "dd-mm-yy",
                        counterText: "",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dim().d20,
            ),
            Text(
              'Select Slots',
              style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(
              height: Dim().d8,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: OnlineSelectionList.length > 7
                    ? 7
                    : OnlineSelectionList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Dim().d300,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dim().d16, vertical: Dim().d2),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 0.8,
                                    blurRadius: 2,
                                    offset: Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                                color: Clr().formColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Clr().borderColor)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: OnlineSelectionList[index]['day'],
                                hint: Text(
                                  OnlineSelectionList[index]['day'] != null
                                      ? OnlineSelectionList[index]['day']
                                      : 'Select Day',
                                  style: Sty().mediumText.copyWith(
                                        fontSize: Dim().d16,
                                        color: Clr().hintColor,
                                      ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 28,
                                ),
                                style: TextStyle(color: Color(0xff787882)),
                                onChanged: (t) {
                                  // STM().redirect2page(ctx, Home());
                                  if (OnlineSelectionList.map((e) => e['day'])
                                      .contains(t)) {
                                    STM().displayToast(
                                        "This day is already selected");
                                    print(OnlineSelectionList[index]['day']);
                                  } else {
                                    setState(() {
                                      OnlineSelectionList[index]['day'] = t;
                                      day = t;
                                    });
                                  }
                                  setState(() {
                                    slotcheck = false;
                                  });
                                },
                                items: dayList.map((string) {
                                  return DropdownMenuItem(
                                    value: string['id'],
                                    child: Text(
                                      string['name'],
                                      style: TextStyle(
                                          color: Color(0xff787882),
                                          fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          OnlineSelectionList[0]['day'] == null
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    if (OnlineSelectionList.length != 1) {
                                      setState(() {
                                        OnlineSelectionList.removeAt(index);
                                      });
                                    } else {
                                      setState(() {
                                        OnlineSelectionList[0]['day'] = null;
                                        OnlineSelectionList[0]['slots'] = [];
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Clr().primaryColor,
                                  ),
                                )
                        ],
                      ),
                      SizedBox(height: Dim().d20),
                      OnlineSelectionList[0]['day'] == null
                          ? Container()
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent: 50,
                              ),
                              itemCount: slotList.length,
                              itemBuilder: (context, index2) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: OnlineSelectionList[index]['slots'].contains(slotList[index2]['id']
                                                    .toString())
                                            ? Clr().primaryColor
                                            : Clr().transparent,
                                        borderRadius:
                                            BorderRadius.circular(Dim().d8),
                                        border: Border.all(
                                            color: Clr().primaryColor)),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (OnlineSelectionList[index]['slots']
                                              .contains(slotList[index2]['id']
                                                  .toString())) {
                                            OnlineSelectionList[index]['slots']
                                                .remove(slotList[index2]['id']
                                                    .toString());
                                          } else {
                                            OnlineSelectionList[index]['slots']
                                                .add(slotList[index2]['id']
                                                    .toString());
                                          }
                                        });
                                      },
                                      child: Center(
                                        child: Text(
                                          '${DateFormat.jm().format(DateTime.parse('${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${slotList[index2]['slot']}'))}',
                                          style: Sty().smallText.copyWith(
                                              color: OnlineSelectionList[index]
                                                          ['slots']
                                                      .contains(slotList[index2]
                                                              ['id']
                                                          .toString())
                                                  ? Clr().white
                                                  : Clr().primaryColor,
                                              fontWeight: FontWeight.w600),
                                          // categoryList[index]['name'].toString(),
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      OnlineSelectionList[0]['day'] == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OnlineSelectionList.length == 7
                                    ? Container()
                                    : OnlineSelectionList[0]['day'] == '8'
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton.icon(
                                              icon: SvgPicture.asset(
                                                "assets/plus.svg",
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  OnlineSelectionList.add({
                                                    'day': null,
                                                    'slots': [],
                                                  });
                                                });
                                                print(OnlineSelectionList);
                                              },
                                              label: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  'Add more',
                                                  style: Sty()
                                                      .smallText
                                                      .copyWith(
                                                          color: Clr()
                                                              .primaryDarkColor),
                                                ),
                                              ),
                                            ),
                                          ),
                              ],
                            )
                    ],
                  );
                }),
            SizedBox(
              height: Dim().d32,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      addOnlineConsulationSlot();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Save Information',
                      style: Sty().mediumText.copyWith(
                            color: Clr().white,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
              ),
            ),
            SizedBox(
              height: Dim().d20,
            )
          ],
        ),
      ),
    );
  }

  // getslots
  void getSlots() async {
    var result = await STM().getOpen(ctx, Str().loading, 'get_slots');
    var success = result['success'];
    if (success) {
      setState(() {
        slotList = result['slots'];
      });
    }
  }

  // add onlineConsulationslot

  void addOnlineConsulationSlot() async {
    FormData body = FormData.fromMap({
      'type': widget.type,
      'is_enabled': _switchValue == true ? 1 : 0,
      'charges': servicechargesCtrl.text,
      'unaviable_date_from': dobCtrl.text,
      'unaviable_date_to': dobCtrl1.text,
      'appointment_slots': jsonEncode(OnlineSelectionList),
    });
    var result = await STM().postWithToken(ctx, Str().processing,
        'add_appointment_details', body, hcptoken, 'hcp');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        STM().successDialog(ctx, message, ApptAvailability(type: widget.type,pagetype: widget.pageType));
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
