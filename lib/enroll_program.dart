import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/programdetails.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class EnrollForProgram extends StatefulWidget {
  @override
  State<EnrollForProgram> createState() => _EnrollForProgramState();
}

class _EnrollForProgramState extends State<EnrollForProgram> {
  late BuildContext ctx;
  List<dynamic> programList = [];
  String? usertoken;
  TextEditingController enrollText = TextEditingController();

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        myPrograms();
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
            color: Clr().black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Enroll For Program',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dim().d12,
            ),
            TextFormField(
              controller: enrollText,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Clr().formfieldbg,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Clr().transparent)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Clr().primaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dim().d20, vertical: Dim().d16),
                // label: Text('Enter Your Number'),
                hintText: "Enter program code is here",
                hintStyle: Sty()
                    .mediumText
                    .copyWith(color: Clr().shimmerColor, fontSize: 14),
                counterText: "",
              ),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      enrollProgram();
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
            ),
            SizedBox(
              height: Dim().d32,
            ),
            programList.isEmpty
                ? Container()
                : Text(
                    'My Program',
                    style:
                        Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                  ),
            programList.isEmpty
                ? Container()
                : SizedBox(
                    height: Dim().d12,
                  ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: programList.length,
              itemBuilder: (context, index) {
                return programLayout(ctx, index, programList);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget programLayout(ctx, index, List) {
    return InkWell(
      onTap: () {
        STM().redirect2page(
            ctx,
            ProgramDetails(
              programId: List[index]['program_id'],
              stype: 'done',
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Clr().borderColor)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dim().d16, vertical: Dim().d16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    List[index]['programs']['name'].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Sty().mediumText,
                  ),
                ),
                SvgPicture.asset('assets/arrow.svg')
              ],
            ),
          ),
        ),
      ),
    );
  }

  void myPrograms() async {
    FormData body = FormData.fromMap({});
    var result = await STM()
        .postWithToken(ctx, Str().loading, 'userProgramList', body , usertoken,'customer');
    setState(() {
      programList = result['program_list'];
    });
  }

  void enrollProgram() async {
    FormData body = FormData.fromMap({
      'program_code': enrollText.text,
    });
    var result = await STM().postWithToken(
        ctx, Str().processing, 'enrollInProgram', body, usertoken,'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, Home());
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
