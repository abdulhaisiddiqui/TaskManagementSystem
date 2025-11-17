import 'package:flutter/material.dart';

class ReuseableImageWidget extends StatelessWidget {
  final String img;
  final double? height;
  final double? width;
  const ReuseableImageWidget({super.key,required this.img, this.height,this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/appImages/$img',height: height,width: width
      ,fit: BoxFit.cover,);
  }
}
