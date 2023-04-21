import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'hcphome.dart';

class Preview extends StatefulWidget {
  final String sUrl;

  const Preview(this.sUrl, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PreviewPage();
  }
}

class PreviewPage extends State<Preview> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(ctx).canPop()) {
          Navigator.of(ctx).pop();
        } else {
          STM().replacePage(ctx, HomeVisit());
        }
        return true;
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
            'Add Prescription',
            style: Sty().largeText.copyWith(
              color: Clr().black,
            ),
          ),
        ),
        body: bodyLayout(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: Dim().d16,
        horizontal: Dim().d20,
      ),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(ctx).size.width,
            height: MediaQuery.of(ctx).size.height / 1.5,
            child: const PDF().cachedFromUrl(
              widget.sUrl,
              placeholder: (double progress) =>
                  Center(child: Text('$progress %')),
              errorWidget: (dynamic error) =>
                  Center(child: Text(error.toString())),
            ),
          ),
          SizedBox(
            height: Dim().d32,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: Sty().primaryButton,
              onPressed: () async {
                await launchUrl(
                  Uri.parse(widget.sUrl.toString()),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Text(
                'Download PDF',
                style: Sty().largeText.copyWith(
                  color: Clr().white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}