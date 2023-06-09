import 'dart:async';
import 'package:calender_picker/calender_picker.dart';
import 'package:calender_picker/extra/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/review_apt_call.dart';
import 'package:saarathi/review_apt_home_visit.dart';
import 'package:saarathi/review_apt_ol.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_new_patient.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class DrName extends StatefulWidget {
  final dynamic doctorDetails;
  final int? id;
  final String? reshedule;

  const DrName({super.key, this.doctorDetails, this.id, this.reshedule});

  @override
  State<StatefulWidget> createState() {
    return DrNamepage();
  }
}

class DrNamepage extends State<DrName> {
  late BuildContext ctx;
  static StreamController<String?> controller1 =
      StreamController<String?>.broadcast();
  int? selected;
  String? slottime;
  bool isChecked = false;
  List idSelectedList = [];
  List<Map<String, dynamic>> patientDetailsList = [];
  TextEditingController complainCtrl = TextEditingController();
  String AppointmentValue = 'Online Appointment';
  List<String> AppointmentList = [
    'Online Appointment',
    'Opd',
    'Home Visit',
  ];
  List<dynamic> dayList = [
    {"id": "0", "name": "Sunday"},
    {"id": "1", "name": "Monday"},
    {"id": "2", "name": "Tuesday"},
    {"id": "3", "name": "Wednesday"},
    {"id": "4", "name": "Thursday"},
    {"id": "5", "name": "Friday"},
    {"id": "6", "name": "Saturday"},
  ];

  String t = "0";
  DateTime? dayno;
  List<dynamic> dateList = [];
  String? usertoken;
  List<dynamic> patientlist = [];
  List<dynamic> slotlist = [];
  int? total, charges, gst;
  var day;

  // for all datA FROM reshedule
  reshedulelist() {
    if (widget.reshedule == 'yes') {
      setState(() {
        dayno = DateTime.parse(
            '${widget.doctorDetails['booking_date']} ${widget.doctorDetails['slot']['slot']}');
        AppointmentValue = widget.doctorDetails['appointment_type'] == "1"
            ? 'Online Appointment'
            : widget.doctorDetails['appointment_type'] == "2"
                ? 'Opd'
                : 'Home Visit';
        patientDetailsList.add({
          'id': widget.doctorDetails['patient']['id'],
          'name': widget.doctorDetails['patient']['full_name'],
          'age': widget.doctorDetails['patient']['age'],
        });
        complainCtrl = TextEditingController(
            text: widget.doctorDetails['complain']);
      });
    } else {
      setState(() {
        dayno = DateTime.now();
      });
    }
  }

  apiCallForSlot() {
    if (widget.reshedule == 'yes'){
      setState(() {
        dayno = DateTime.parse(
            '${widget.doctorDetails['booking_date']} ${widget.doctorDetails['slot']['slot']}');
        day = widget.doctorDetails['booking_date'];
        int position = dayList.indexWhere(
                (e) => e['name'].toString() == DateFormat.EEEE().format(dayno!));
        if (dayList.contains(DateFormat.EEEE().format(dayno!))) {
          dayList[position]['id'];
        }
        getSlots(id: dayList[position]['id']);
      });
    }else{
      setState(() {
        dayno = DateTime.now();
        day = DateFormat('yyyy-MM-dd').format(dayno!);
        int position = dayList.indexWhere((e) =>
        e['name'].toString() == DateFormat.EEEE().format(dayno!));
        if (dayList.contains(DateFormat.EEEE().format(dayno!))) {
          dayList[position]['id'];
        }
        getSlots(id: dayList[position]['id']);
      });
    }
  }


  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
      reshedulelist();
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getPatient();
        dayList;
        apiCallForSlot();
        print(usertoken);
      }
    });
  }

  @override
  void initState() {
    controller1.stream.listen(
      (event) {
        setState(() {
          getPatient();
        });
      },
    );
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        widget.reshedule == 'yes'
            ? STM().back2Previous(ctx)
            : STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              widget.reshedule == 'yes'
                  ? STM().back2Previous(ctx)
                  : STM().finishAffinity(ctx, Home());
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Clr().appbarTextColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            widget.reshedule == 'yes'
                ? ' ${widget.doctorDetails['hcp']['first_name']} ${widget.doctorDetails['hcp']['last_name']}'
                : ' ${widget.doctorDetails['first_name']} ${widget.doctorDetails['last_name']}',
            style: Sty().largeText.copyWith(
                color: Clr().appbarTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Row(
                  children: [
                    widget.reshedule == 'yes'
                        ? STM().imageDisplay(
                            list: widget.doctorDetails['hcp']['profile_pic'],
                            url: widget.doctorDetails['hcp']['profile_pic'],
                            h: Dim().d160,
                            w: Dim().d120)
                        : STM().imageDisplay(
                            list: widget.doctorDetails['profile_pic'],
                            url: widget.doctorDetails['profile_pic'],
                            h: Dim().d160,
                            w: Dim().d120),
                    SizedBox(
                      width: Dim().d20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.reshedule == 'yes'
                                ? ' ${widget.doctorDetails['hcp']['first_name']} ${widget.doctorDetails['hcp']['last_name']}'
                                : ' ${widget.doctorDetails['first_name']} ${widget.doctorDetails['last_name']}',
                            style: Sty()
                                .mediumText
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                           if(widget.doctorDetails['professional'] != null)
                           if(widget.doctorDetails['professional']['speciality_name'] != null)
                           Text(
                            widget.reshedule == 'yes'
                                ? widget.doctorDetails['hcp']['professional']['speciality_name'] == null ? '' :'${widget.doctorDetails['hcp']['professional']['speciality_name'][0]['name']}'
                                : widget.doctorDetails['professional']['speciality_name'] == null ? '' : '${widget.doctorDetails['professional']['speciality_name'][0]['name']}',
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: Dim().d8,
                          ),
                          Text(
                            widget.reshedule == 'yes'
                                ? '${widget.doctorDetails['hcp']['city']['name']}'
                                : '${widget.doctorDetails['city']['name']}',
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: Dim().d8,
                          ),
                          Text(
                            widget.reshedule == 'yes'
                                ? 'Experience : ${widget.doctorDetails['hcp']['professional']['experience']} Years'
                                : 'Experience : ${widget.doctorDetails['professional']['experience']} Years',
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              const Divider(),
              SizedBox(
                height: Dim().d12,
              ),
              CalenderPicker(
                DateTime.now(),
                initialSelectedDate: widget.reshedule == 'yes'
                    ? DateTime.parse(dayno.toString())
                    : DateTime.now(),
                selectionColor: Clr().primaryColor,
                selectedTextColor: Colors.white,
                height: Dim().d100,
                width: Dim().d80,
                onDateChange: (date) {
                  setState(() {
                    dayno = date;
                    day = DateFormat('yyyy-MM-dd').format(date);
                    int position = dayList.indexWhere((e) =>
                        e['name'].toString() == DateFormat.EEEE().format(date));
                    if (dayList.contains(DateFormat.EEEE().format(date))) {
                      dayList[position]['id'];
                    }
                    getSlots(id: dayList[position]['id']);
                  });
                },
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select appointment type',
                    style:
                        Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Clr().grey)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: AppointmentValue,
                      hint: Text(
                        AppointmentValue ?? 'Select Type',
                        style: Sty().smallText.copyWith(
                              color: Clr().black,
                            ),
                      ),
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 28,
                        color: Clr().grey,
                      ),
                      style: TextStyle(color: Color(0xff787882)),
                      items: AppointmentList.map((String string) {
                        return DropdownMenuItem<String>(
                          value: string,
                          child: Text(
                            string,
                            style: TextStyle(
                                color: Color(0xff787882), fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: widget.reshedule == 'yes'
                          ? null
                          : (t) {
                              setState(() {
                                AppointmentValue = t!;
                              });
                              setState(() {
                                int position = dayList.indexWhere((e) =>
                                    e['name'].toString() ==
                                    DateFormat.EEEE().format(dayno!));
                                if (dayList.contains(
                                    DateFormat.EEEE().format(dayno!))) {
                                  dayList[position]['id'];
                                }
                                getSlots(id: dayList[position]['id']);
                              });
                            },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.reshedule == 'yes'
                        ? 'Your Complain'
                        : 'Enter your Complain',
                    style:
                        Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: TextFormField(
                  controller: complainCtrl,
                  readOnly: widget.reshedule == 'yes' ? true : false,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Clr().formfieldbg,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Clr().transparent)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Clr().primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d20, vertical: Dim().d16),
                    hintText: "Enter Your Complain",
                    hintStyle: Sty()
                        .mediumText
                        .copyWith(color: Clr().shimmerColor, fontSize: 14),
                    counterText: "",
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              patientlist.isEmpty
                  ? Container()
                  : widget.reshedule == 'yes'
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Patient',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  STM().redirect2page(
                                      ctx,
                                      AddNewPatient(
                                        doctorDetails: widget.doctorDetails,
                                        stype: 'edit',
                                      ));
                                },
                                child: Wrap(
                                  children: [
                                    SvgPicture.asset('assets/add.svg'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'Add New',
                                      style: Sty()
                                          .smallText
                                          .copyWith(color: Clr().primaryColor),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
              SizedBox(height: Dim().d12),
              patientlist.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                      child: InkWell(
                        onTap: () {
                          STM().redirect2page(
                              ctx,
                              AddNewPatient(
                                doctorDetails: widget.doctorDetails,
                                stype: 'edit',
                              ));
                        },
                        child: Container(
                          height: Dim().d44,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dim().d12),
                              border: Border.all(color: Clr().hintColor)),
                          child: Center(
                            child: Text('Add New Patient',
                                style: Sty().mediumBoldText),
                          ),
                        ),
                      ),
                    )
                  : widget.reshedule == 'yes'
                      ? Padding(
                          padding: EdgeInsets.only(left: Dim().d20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: Dim().d20,
                                width: Dim().d20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Clr().primaryColor,
                                    border: Border.all(color: Clr().hintColor)),
                              ),
                              SizedBox(
                                width: Dim().d8,
                              ),
                              SizedBox(
                                width: Dim().d16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.doctorDetails['patient']['full_name']}',
                                    style: Sty()
                                        .mediumText
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Text(
                                    '${widget.doctorDetails['patient']['gender']}, ${widget.doctorDetails['patient']['age']} years',
                                    style: Sty().mediumText.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Clr().grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: patientlist.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return patientDetails(ctx, index, patientlist);
                          }),
              SizedBox(
                height: Dim().d32,
              ),
              slotlist.isEmpty
                  ? Center(
                      child: Text('No Slots', style: Sty().mediumBoldText),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 50,
                        ),
                        itemCount: slotlist.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: slotlist[index]['id'] == selected
                                      ? Clr().primaryColor
                                      : Clr().transparent,
                                  borderRadius: BorderRadius.circular(Dim().d8),
                                  border:
                                      Border.all(color: Clr().primaryColor)),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selected = slotlist[index]['id'];
                                    slottime = slotlist[index]['slot'];
                                  });
                                  // STM().redirect2page(ctx, Electronics(categoryList[index]['id'].toString()));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${DateFormat.jm().format(DateTime.parse('${day} ${slotlist[index]['slot'].toString()}'))}',
                                      style: Sty().smallText.copyWith(
                                          color:
                                              slotlist[index]['id'] == selected
                                                  ? Clr().white
                                                  : Clr().primaryColor,
                                          fontWeight: FontWeight.w600),
                                      // categoryList[index]['name'].toString(),
                                      // overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(
                height: Dim().d20,
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Clr().grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 12,
                        offset: Offset(12, 0.5), // changes position of shadow
                      ),
                    ],
                    color: Clr().primaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dim().d24, vertical: Dim().d16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fees : ₹ ${total == null ? 0 : total}',
                        style: Sty().mediumText.copyWith(
                            fontWeight: FontWeight.w600, color: Clr().white),
                      ),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              Data();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Clr().white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: Text(
                              'Proceed',
                              style: Sty().smallText.copyWith(
                                  color: Clr().primaryColor,
                                  fontWeight: FontWeight.w600),
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // patientdetails

  Widget patientDetails(ctx, index, list) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dim().d16, vertical: Dim().d12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          patientDetailsList.map((e) => e['id']).contains(list[index]['id'])
              ? InkWell(
                  onTap: () {
                    setState(() {
                      patientDetailsList.clear();
                    });
                  },
                  child: Container(
                    height: Dim().d20,
                    width: Dim().d20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Clr().primaryColor,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      patientDetailsList.clear();
                      patientDetailsList.add({
                        'id': list[index]['id'],
                        'name': list[index]['full_name'],
                        'age': list[index]['age'],
                      });
                    });
                    print(patientDetailsList);
                  },
                  child: Container(
                    height: Dim().d20,
                    width: Dim().d20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Clr().white,
                        border: Border.all(color: Clr().hintColor)),
                  ),
                ),
          SizedBox(
            width: Dim().d8,
          ),
          SizedBox(
            width: Dim().d16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${list[index]['full_name']}',
                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Text(
                '${list[index]['gender']}, ${list[index]['age']} years',
                style: Sty()
                    .mediumText
                    .copyWith(fontWeight: FontWeight.w400, color: Clr().grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  // getPatient
  void getPatient() async {
    var result = await STM().getWithTokenUrl(
        ctx, Str().loading, 'get_patient', usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        patientlist = result['patients'];
      });
    }
  }

  // route to book appointment
  Routes(type, nextList) {
    if (widget.reshedule == 'yes') {
      type == 1
          ? STM().redirect2page(
              ctx,
              OnlineConsultation(
                onlineDetails: [nextList],
                reshedule: 'yes',
              ))
          : type == 2
              ? STM().redirect2page(
                  ctx,
                  TeleCallConsultation(
                    aptdetails: [nextList],
                    reshedule: 'yes',
                  ))
              : STM().redirect2page(
                  ctx,
                  HomeVisitConsultation(
                    homedetails: [nextList],
                    reshedule: 'yes',
                  ));
    } else {
      type == 1
          ? STM().redirect2page(
              ctx,
              OnlineConsultation(
                onlineDetails: [nextList],
              ))
          : type == 2
              ? STM().redirect2page(
                  ctx,
                  TeleCallConsultation(
                    aptdetails: [nextList],
                  ))
              : STM().redirect2page(
                  ctx,
                  HomeVisitConsultation(
                    homedetails: [nextList],
                  ));
    }
  }

  // data for next page (review page) and route function
  Data() {
    return patientDetailsList.isEmpty
        ? STM().displayToast('Patient is required')
        : AppointmentValue == null
            ? STM().displayToast('Appointment type is required')
            : selected == null
                ? STM().displayToast('Slot time is required')
                : complainCtrl.text.isEmpty
                    ? STM().displayToast('Your complain is required')
                    : Routes(
                        AppointmentValue == 'Online Appointment'
                            ? 1
                            : AppointmentValue == 'Opd'
                                ? 2
                                : 3,
                        widget.reshedule == 'yes'
                            ? {
                                'hcpuserid': widget.doctorDetails['hcp']['id'],
                                'hcpprofilepic': widget.doctorDetails['hcp']
                                        ['profile_pic']
                                    .toString(),
                                'details': widget.doctorDetails,
                                'hcpname':
                                    '${widget.doctorDetails['hcp']['first_name']} ${widget.doctorDetails['hcp']['last_name']}',
                                'speciality': widget.doctorDetails['hcp']['professional']['speciality_name'] != null ?
                                    '${widget.doctorDetails['hcp']['professional']['speciality_name'][0]['name']}' : '',
                                'bookingtime': slottime,
                                'bookingdate': dayno,
                                'patientname': widget.doctorDetails['patient']
                                    ['full_name'],
                                'patientage': widget.doctorDetails['patient']
                                    ['age'],
                                'patientid': widget.doctorDetails['patient']
                                    ['id'],
                                'slotid': selected,
                                'charges': charges,
                                'gst': gst,
                                'total': total,
                                'appointment_id': widget.doctorDetails['id'],
                                'complain': complainCtrl.text,
                              }
                            : {
                                'hcpuserid': widget.doctorDetails['id'],
                                'hcpprofilepic': widget
                                    .doctorDetails['profile_pic']
                                    .toString(),
                                'hcpname':
                                    '${widget.doctorDetails['first_name']} ${widget.doctorDetails['last_name']}',
                                'speciality': widget.doctorDetails['professional']
                                ['speciality_name'] == null ? '' : widget.doctorDetails['professional']
                                        ['speciality_name'][0]['name'],
                                'bookingtime': slottime,
                                'bookingdate': dayno,
                                'patientname': patientDetailsList[0]['name'],
                                'patientage': patientDetailsList[0]['age'],
                                'patientid': patientDetailsList[0]['id'],
                                'slotid': selected,
                                'charges': charges,
                                'gst': gst,
                                'total': total,
                                'complain': complainCtrl.text,
                              });
  }

  // getSLots
  void getSlots({id}) async {
    FormData body = FormData.fromMap({
      'hcp_user_id': widget.id ?? widget.doctorDetails['hcp']['id'],
      'type': AppointmentValue == 'Opd'
          ? 2
          : AppointmentValue == 'Home Visit'
              ? 3
              : 1,
      'day_no': id,
    });
    var result = await STM().postWithToken(
        ctx, 'Loading Slots', 'get_hcp_details', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        slotlist = result['slot_array'];
        charges = int.parse(result['doctor_details']['charges'].toString());
        gst = int.parse(result['doctor_details']['gst'].toString());
        total = int.parse(result['doctor_details']['charges'].toString()) +
            int.parse(result['doctor_details']['gst'].toString());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
