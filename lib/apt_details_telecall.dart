import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apt_details_home_visit.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'dr_name.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class TeleCallAppointmentDetails extends StatefulWidget {
  final dynamic details;
  final String? time;
  const TeleCallAppointmentDetails({super.key, this.details,this.time});
  @override
  State<TeleCallAppointmentDetails> createState() => _TeleCallAppointmentDetailsState();
}

class _TeleCallAppointmentDetailsState extends State<TeleCallAppointmentDetails> {
  late BuildContext ctx;
  TextEditingController canCtrl = TextEditingController();
  DateTime now = DateTime.now();
  String? usertoken;
  DateTime? slotDate;
  DateTime? startTime;
  List<dynamic> arrayList = [];
  var v,stypeValue;
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
      DateTime slotDate = DateTime.parse('${v['booking_date']} ${v['slot']['slot']}');
      DateTime startTime = slotDate.subtract(Duration(minutes: int.parse(widget.time.toString())));
      DateTime endTime = startTime.add(Duration(minutes: 5));
    });
    setState(() {
      v = widget.details;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getReason();
        print(usertoken);
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
          'Appointment Details',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(v['hcp']['profile_pic'].toString()),
                ),
                SizedBox(
                  width: Dim().d24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment ID : #${v['appointment_uid']}',
                      style: Sty()
                          .mediumText
                          .copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dim().d4,),
                    Text(
                      '${v['hcp']['first_name']} ${v['hcp']['last_name']}',
                      style: Sty()
                          .mediumText
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dim().d4,),
                    Text(
                      v['hcp']['professional']['speciality_name'][0]['name'],
                      style: Sty()
                          .mediumText
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dim().d4,),
                    Text(
                      v['status'] == '0' ? 'Pending' :  v['status'] == '1' ? 'Completed' : 'Cancelled',
                      style: Sty()
                          .mediumText
                          .copyWith(
                          color: v['status'] == '0' ? Color(0xffFFC107) : v['status'] == '1' ? Clr().green : Clr().red,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            const Divider(),
            SizedBox(
              height: 12,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Clr().primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Dim().d16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BOOKING TIME',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'BOOKING DATE',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 1.5,
                      decoration: BoxDecoration(color: Color(0xffECFFDB)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v['slot']['slot'],
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          v['booking_date'],
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Appointment type',
              style: Sty().largeText.copyWith(
                  fontWeight: FontWeight.w600, color: Clr().primaryColor),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'OPD',
              style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Payment Details',
              style: Sty().largeText.copyWith(
                  fontWeight: FontWeight.w600, color: Clr().primaryColor),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Consultation Fee',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  '₹ ${v['consultation_fee']}',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GST',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  '₹ ${v['gst']}',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  '₹ ${v['discount'] == null ? 0 : v['discount']}',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount Payable',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '₹ ${v['total_amount']}',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Clr().borderColor,

                  )
              ),
              elevation: 0,
              color: Clr().formfieldbg,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16,vertical: Dim().d16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        SvgPicture.asset('assets/invoice.svg',width: 20,),
                        SizedBox(width: 12,),
                        Text(
                          'Invoice download',
                          style:
                          Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SvgPicture.asset('assets/arrow_black.svg'),
                  ],
                ),
              ),),
            SizedBox(
              height: 30,
            ),
            v['status'] == '1' ? Container() : v['status'] == '2' ? Container() : CancelButton(),
            SizedBox(height: 20,),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum ',
              textAlign: TextAlign.center,
              style:
              Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text(
                'Contact Support',
                style:
                Sty().mediumText.copyWith(
                    color: Clr().primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(onTap: (){
              STM().redirect2page(ctx, DrName(doctorDetails: widget.details,reshedule: 'yes',));
            },
              child: Container(
                height: Dim().d52,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dim().d12),
                    border: Border.all(color: Color(0xff80C342))),
                child: Center(
                  child: Text('Appointment Reschedule',
                      style: Sty()
                          .mediumBoldText
                          .copyWith(color: Clr().primaryColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Cancel appointment and condition is if before 5 minutes slot time can't cancel appointment( appintment 18:00 user can't cancel appoitmnet 17:55)
  Widget CancelButton() {

    // Duration diff = beforeTime.difference(afterTime);
    // now.isAfter(startTime) && now.isBefore(endTime) ? print('cancel not show') : print('cancel button show');
    return now.isAfter(startTime!)
        ? Container()
        : Center(
      child: SizedBox(
        height: 50,
        width: 300,
        child: ElevatedButton(
            onPressed: () {
              _CancelDialog();
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Clr().primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text(
              'Cancel Appointment',
              style: Sty().mediumText.copyWith(
                color: Clr().white,
                fontWeight: FontWeight.w600,
              ),
            )),
      ),
    );
  }

  _CancelDialog(){
    return showDialog(context: context, builder: (index){
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setstate) {
            return AlertDialog(
              content: Column(mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dim().d12),
                      border: Border.all(color: Clr().black),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: Dim().d8),
                      child: DropdownButton(
                        value: stypeValue,
                        isExpanded: true,
                        hint: Text('Select Type',
                            style: Sty().mediumText.copyWith(
                                color: Clr().shimmerColor)),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 28,
                          color: Clr().grey,
                        ),
                        underline: Container(),
                        style: TextStyle(color: Color(0xff787882)),
                        items: arrayList.map((string) {
                          return DropdownMenuItem(
                            value: string['name'],
                            child: Text(
                              string['name'],
                              style: const TextStyle(
                                  color: Color(0xff787882),
                                  fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (t) {
                          setstate(() {
                            stypeValue = t!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: Dim().d12),
                  stypeValue == 'Other' ? TextFormField(
                    decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                        hintText: 'Enter The Reason',
                        hintStyle: Sty().mediumText.copyWith(color: Clr().hintColor)
                    ),
                    style: Sty().mediumText,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: canCtrl,
                  ) :Container(),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d44),
                  child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Clr().primaryColor)),onPressed: (){
                    AppointmentCancel(v['id']);
                  }, child: Center(child: Text('Submit'))),
                )
              ],
            );
          }
      );
    });
  }


  void getReason() async {
    var result = await STM().getWithoutDialogToken(ctx, 'get_reason',usertoken,'customer');
    setState(() {
      arrayList = result['reasons'];
    });
  }

  // appointment cancel

  void AppointmentCancel(id) async {
    FormData data = FormData.fromMap({
      'appointment_id': id,
      'reason': canCtrl.text.isEmpty ? stypeValue : canCtrl.text,
    });
    var result = await STM().postWithToken(ctx, Str().processing, 'cancel_appointment', data, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().successDialogWithReplace(ctx, message, Home());
    }else{
      STM().errorDialog(ctx, message);
    }
  }
}
