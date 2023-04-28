import 'package:flutter/material.dart';
import 'package:saarathi/set_time.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'medication_reminder2.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class MedicationReminder extends StatefulWidget {
  final dynamic medicationDetails;
  const MedicationReminder({super.key, this.medicationDetails});
  @override
  State<MedicationReminder> createState() => _MedicationReminderState();
}

class _MedicationReminderState extends State<MedicationReminder> {
  late BuildContext ctx;
  TextEditingController medicineCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<dynamic> dayList = [
    {"id": "0", "name": "Sunday"},
    {"id": "1", "name": "Monday"},
    {"id": "2", "name": "Tuesday"},
    {"id": "3", "name": "Wednesday"},
    {"id": "4", "name": "Thursday"},
    {"id": "5", "name": "Friday"},
    {"id": "6", "name": "Saturday"},
  ];
  List<dynamic> daySelectedList = [];

  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  bool isChecked6 = false;
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
      medicineCtrl = TextEditingController(text: widget.medicationDetails['medicine']);
      daySelectedList = widget.medicationDetails['day_id'];
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        // getHome();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.medicationDetails);
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
          'Medication Reminder',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What medicine do you want to add?',
                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              TextFormField(
                controller: medicineCtrl,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Medicine name is required';
                  }
                },
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
                  // label: Text('Enter Your Number'),
                  hintText: "Medicine Name",
                  hintStyle: Sty()
                      .mediumText
                      .copyWith(color: Clr().shimmerColor, fontSize: 14),
                  counterText: "",
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Text(
                'Choose the days you need to take the medicine',
                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              ListView.builder(
                  itemCount: dayList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: Dim().d20),
                      child: Row(
                        children: [
                          daySelectedList.contains(dayList[index]['id'])
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      daySelectedList
                                          .remove(dayList[index]['id']);
                                    });
                                  },
                                  child: Container(
                                    height: Dim().d20,
                                    width: Dim().d20,
                                    child: Icon(Icons.check_box,
                                        color: Clr().primaryColor),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      daySelectedList.add(dayList[index]['id']);
                                    });
                                  },
                                  child: Container(
                                    height: Dim().d20,
                                    width: Dim().d20,
                                    child: Icon(
                                      Icons.check_box_outline_blank,
                                      color: Clr().hintColor,
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: Dim().d20,
                          ),
                          Expanded(
                              child: Text(
                            dayList[index]['name'],
                            style: TextStyle(
                                fontSize: Dim().d16,
                                fontWeight: FontWeight.w400),
                            overflow: TextOverflow.fade,
                          ))
                        ],
                      ),
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
                        if (formKey.currentState!.validate()) {
                          daySelectedList.isEmpty
                              ? STM().displayToast(
                                  'Days is needed to take the medicine')
                              : STM().redirect2page(
                                  ctx,
                                  SetTime(
                                    days: daySelectedList,
                                    medicine: medicineCtrl.text,
                                    timelist: widget.medicationDetails == null ? [] : widget.medicationDetails['time'],
                                    id: widget.medicationDetails == null ? null : widget.medicationDetails['id'].toString(),
                                  ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Clr().primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        'Next',
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
    );
  }
}
