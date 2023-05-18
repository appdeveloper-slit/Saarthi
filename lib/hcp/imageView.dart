import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:saarathi/values/colors.dart';
import 'package:saarathi/values/dimens.dart';

class ImagView extends StatefulWidget {
  final String? image;
  const ImagView({Key? key,this.image}) : super(key: key);

  @override
  State<ImagView> createState() => _ImagViewState();
}

class _ImagViewState extends State<ImagView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: Dim().d350,
            width: double.infinity,
            child: PhotoView(imageProvider: NetworkImage('${widget.image}'),backgroundDecoration: BoxDecoration(color: Clr().white)),
          )
        ],
      ),
    );
  }
}
