import 'package:flutter/material.dart';
import 'package:loanproject/models/slide.dart';

import '../size_config.dart';

class NewSlide extends StatelessWidget {
  final int index;

  NewSlide(this.index);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double sizeBox = 50;
    double sizeTextMain = 1.8;
    double sizeTextBottom = 2.7;

    if (height <= 670) {
      ///SE 2
      sizeBox = 30;
      sizeTextMain = 2.3;
      sizeTextBottom = 3.5;
    } else if (height <= 739 && height >= 710) {
      /// 7 Plus
      sizeBox = 10;
      sizeTextMain = 2.3;
      sizeTextBottom = 3;
    } else if (height <= 812 && height >= 750) {
      ///X iphone & 11 Pro
      sizeBox = 20;
    }

    return Opacity(
      opacity: index != 3 ? 1 : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.5,
            width: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(slideList[index].imageUrl),
          ),
          SizedBox(
            height: sizeBox,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: RichText(
                text: new TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: slideList[index].title,
                      style: TextStyle(
                        color: Color(0xFF1D1D1D),
                        fontFamily: "Phonk",
                        fontSize: SizeConfig.heightMultiplier * sizeTextBottom,
                      ),
                    ),
                    TextSpan(
                        text: index == 0 ? '?' : '',
                        style: TextStyle(
                          color: Color(0xFF1D1D1D),
                          fontFamily: "Poppins-ExtraBold",
                          fontSize:
                              SizeConfig.heightMultiplier * sizeTextBottom,
                        )),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                slideList[index].description,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: Color(0xFF1D1D1D),
                  fontFamily: "Poppins-LightItalic",
                  fontSize: SizeConfig.heightMultiplier * sizeTextMain,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          SizedBox(
            height: sizeBox,
          ),
        ],
      ),
    );
  }
}
