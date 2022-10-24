import 'package:flutter/material.dart';
import 'package:loanproject/models/slide.dart';

import '../size_config.dart';

class SlideItem extends StatelessWidget {
  final int index;

  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(height);
    double bottomPadding = 50.0;
    double bottomPaddingBlock = 10.0;

    // if(Platform.isAndroid && height > 670 && height <= 700){
    //   bottomPadding = 25.0;
    //   bottomPaddingBlock = 70.0;
    // }
    if (height <= 670) {
      ///SE 2
      bottomPadding = 25.0;
      bottomPaddingBlock = 70.0;
    } else if (height <= 900 && height >= 895) {
      ///XS Max & XR & 11 & 11 Pro Max
      bottomPadding = 90.0;
      bottomPaddingBlock = 150.0;
    } else if (height <= 1000 && height >= 900) {
      ///12 pro max
      bottomPadding = 90.0;
      bottomPaddingBlock = 150.0;
      //else if (height <= 739 && height >= 730) {
    } else if (height <= 739 && height >= 710) {
      /// 7 Plus
      bottomPadding = 35.0;
      bottomPaddingBlock = 90.0;
      //else if (height <= 812 && height >= 750) {
    } else if (height <= 812 && height >= 750) {
      ///X iphone & 11 Pro
      bottomPadding = 70.0;
      bottomPaddingBlock = 120.0;
    } else if (height <= 845 && height >= 840) {
      ///12 iphone & 12 Pro
      bottomPadding = 70.0;
      bottomPaddingBlock = 120.0;
    }

    double sizeImage = 0.95;
    double sizeBox = 50;
    double sizeTextMain = 1.8;
    double sizeTextBottom = 2.7;

    if (height <= 670) {

      ///SE 2
      sizeImage = 0.75;
      sizeBox = 30;
      sizeTextMain = 2.3;
      sizeTextBottom = 3.5;
    } else if (height <= 900 && height >= 895) {
      ///XS Max & XR & 11 & 11 Pro Max

    } else if (height <= 1000 && height >= 900) {
      ///12 pro max

    } else if (height <= 739 && height >= 710) {
      /// 7 Plus
      sizeImage = 0.75;
      sizeBox = 10;
      sizeTextMain = 2.3;
      sizeTextBottom = 3;
    } else if (height <= 812 && height >= 750) {
      ///X iphone & 11 Pro
      sizeBox = 20;
    } else if (height <= 845 && height >= 840) {
      ///12 iphone & 12 Pro

    }

    return Opacity(
        opacity: index != 3 ? 1 : 0,
        child:
        ((){
          if(index ==0 || index == 2){
             return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width * sizeImage,
                  width: MediaQuery.of(context).size.height * sizeImage,
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
                          style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                                text: slideList[index].title,
                                style: TextStyle(
                                  color: Color(0xFF1D1D1D),
                                  fontFamily: "Phonk",
                                  fontSize:
                                  SizeConfig.heightMultiplier * sizeTextBottom,
                                )),
                            new TextSpan(
                                text: index==0?'?':'',
                                style: TextStyle(
                                  color: Color(0xFF1D1D1D),
                                  fontFamily: "Poppins-ExtraBold",
                                  fontSize:
                                  SizeConfig.heightMultiplier * sizeTextBottom,
                                )),
                          ],
                        ),
                      )),
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
                        ))),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: sizeBox,
                ),
              ],
            );
          }else{
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Align(
                  alignment: Alignment.centerLeft,
                  child:Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      slideList[index].title,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color:  Color(0xFF1D1D1D),
                        fontFamily: "Phonk",

                        fontSize: SizeConfig.heightMultiplier * sizeTextBottom,
                      ),

                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child:Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          slideList[index].description,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color:  Color(0xFF1D1D1D),
                              letterSpacing: 1.5,
                              fontFamily: "Poppins-LightItalic",
                              fontSize: SizeConfig.heightMultiplier * sizeTextMain,
                              ),
                        ))),


                SizedBox(
                  height: sizeBox,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * sizeImage,
                  width: MediaQuery.of(context).size.height * sizeImage,
                  child: Image.asset(slideList[index].imageUrl),
                ),
                SizedBox(
                  height: sizeBox,
                ),
              ],
            );
          }
        }())

    );
    // return Column(
    //   mainAxisAlignment:
    //   deviceSize == true
    //       ?MainAxisAlignment.start
    //       :MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: <Widget>[
    //     Opacity(
    //         opacity: index!=3 ? 1 : 0,
    //         child: Padding(
    //             padding: const EdgeInsets.only(top: 0, right: 20, left: 20),
    //             child: Center(
    //                 child: Image.asset(slideList[index].imageUrl,
    //                     fit: BoxFit.contain,
    //                     height: sizeImage * SizeConfig.imageSizeMultiplier)))),
    //     SizedBox(
    //       height: sizeMargin,
    //     ),
    //     Opacity(
    //         opacity: index!=3 ? 1 : 0,
    //         child: Text(
    //           slideList[index].title,
    //           style: TextStyle(
    //             fontFamily: 'Raleway',
    //             fontSize: textSize * SizeConfig.heightMultiplier,
    //             fontWeight: FontWeight.w400,
    //             color: Colors.black,
    //           ),
    //         )),
    //     SizedBox(
    //       height: 10,
    //     ),
    //     Opacity(
    //         opacity: index!=3 ? 1 : 0,
    //         child: Padding(
    //           padding: const EdgeInsets.only(left: 20, right: 20),
    //           child: Text(
    //             slideList[index].description,
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //                 color: Color(0xFF828282),
    //                 fontSize: textButtom * SizeConfig.heightMultiplier,
    //                 fontFamily: 'Raleway'),
    //           ),
    //         )),
    //   ],
    // );
  }
}
