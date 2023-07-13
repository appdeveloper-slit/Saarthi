import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:saarathi/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'enroll_program.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';

class ProgramDetails extends StatefulWidget {
  final String? programId;
  final String? stype;
  const ProgramDetails({Key? key, this.programId,this.stype}) : super(key: key);

  @override
  State<ProgramDetails> createState() => _ProgramDetailsState();
}

class _ProgramDetailsState extends State<ProgramDetails> {
  late BuildContext ctx;
  String? usertoken;
  dynamic programDetails;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getProgramDetails();
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
      appBar: abbbar(ctx),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Dim().d32),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: Dim().d20),
              child: Align(alignment: Alignment.center,
                  child: Text('${programDetails == null ? ''  : programDetails['name']}',
                      style: Sty()
                          .mediumBoldText
                          .copyWith(color: Clr().primaryColor))),
            ),
            SizedBox(height: Dim().d28),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              child: Text(
                '${programDetails == null ? ''  : programDetails['description']}',
                style: Sty().mediumText,
              ),
            ),
            SizedBox(height: Dim().d20),
            programDetails['qr_code_image'] == null ? Container() : Align(
                alignment: Alignment.center,
                child: Image.network(
                  '${programDetails['qr_code_image']}',
                )),
            SizedBox(height: Dim().d8),
            // Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       '${programDetails['qr_code']}',
            //       style: Sty().mediumText,
            //     )),
         widget.stype == 'done'? Container() : SizedBox(height: Dim().d40),
            programDetails['is_enroll'] == true ? Container() :  Center(
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, EnrollForProgram());
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Enroll In',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            ),
            widget.stype == 'done'? Container()  :SizedBox(height: Dim().d20),
          ],
        ),
      ),
    );
  }

  void getProgramDetails() async {
    FormData body = FormData.fromMap({
      'program_primary_id': widget.programId,
    });
    var result = await STM().postWithToken(
        ctx, Str().loading, 'singleProgramDetails', body, usertoken,'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        programDetails = result['data'];
      });
    }
  }

  AppBar abbbar(ctx) {
    return AppBar(
      elevation: 2,
      backgroundColor: Clr().white,
      leading: InkWell(
        onTap: () {
          STM().back2Previous(ctx);
        },
        child: Icon(
          Icons.arrow_back_rounded,
          color: Clr().black,
        ),
      ),
    );
  }
}
