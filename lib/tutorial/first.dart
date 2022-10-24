import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import '../home.dart';
import '../models/slide.dart';
import '../models/slide_item.dart';
import '../size_config.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../webview.dart';
import '../webview_click.dart';

Map appsFlyerOptions = {
  "afDevKey": Platform.isIOS?'XmphTEoVgARoCrhALJusC6':'XXzKfE9qPGH5XTrEysZc6W',
  "afAppId": '1570037577',
  "isDebug": true
};

class FirstTutorial extends StatefulWidget {
  const FirstTutorial({Key key}) : super(key: key);

  @override
  State<FirstTutorial> createState() => _FirstTutorialState();
}

class _FirstTutorialState extends State<FirstTutorial> {

  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  int _currentPage = 0;
  String _back = 'assets/images/img_backon1.png';
  String _backButton = 'assets/images/button1.svg';
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    OneSignal.shared.setNotificationOpenedHandler((notification) {
      final _appState = Provider.of<AppState>(context, listen: false);
      Map userId = {'CUID': _appState.cuid};
      logEvent('GetLoan', userId);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebScreenClick()),
      );
      print('GNIDA open from click from ONBOARD');
    });

  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()),
      );
    }
    setState(() {
      _currentPage = index;
      if(_currentPage == 0){
        _back = 'assets/images/img_backon1.png';
        _backButton = 'assets/images/button1.svg';
      }else if(_currentPage == 1){
        _back = 'assets/images/back_sec.png';
        _backButton = 'assets/images/button2.svg';
      }else if(_currentPage == 2){
        _back = 'assets/images/back_three.png';
        _backButton = 'assets/images/button3.svg';
      }
    });
  }


  void initApsSdk() {

    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

  }

  Future<bool> logEvent(String eventName, Map eventValues) async {
    bool result;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(height);
    double bottomPadding = 50.0;
    double bottomPaddingBlock = 10.0;
    double sizeSkip = 2;

    if(Platform.isAndroid){
      bottomPadding = 30.0;
      if (height <= 670) {
        ///SE 2
        bottomPadding = 20.0;
        bottomPaddingBlock = 70.0;
        sizeSkip = 2.5;
      } else if (height <= 900 && height >= 895) {
        ///XS Max & XR & 11 & 11 Pro Max
        bottomPadding = 50.0;
        bottomPaddingBlock = 150.0;
      } else if (height <= 1000 && height >= 900) {
        ///12 pro max
        bottomPadding = 50.0;
        bottomPaddingBlock = 150.0;
        //else if (height <= 739 && height >= 730) {
      } else if (height <= 739 && height >= 710) {
        /// 7 Plus
        bottomPadding = 35.0;
        bottomPaddingBlock = 90.0;
        //else if (height <= 812 && height >= 750) {
      } else if (height <= 812 && height >= 750) {
        ///X iphone & 11 Pro
        bottomPadding = 50.0;
        bottomPaddingBlock = 120.0;
      } else if (height <= 845 && height >= 840) {
        ///12 iphone & 12 Pro
        bottomPadding = 50.0;
        bottomPaddingBlock = 120.0;
      }


      double sizeImage = 0.95;
      double sizeBox = 50;
      double sizeTextMain = 1.8;
      double sizeTextBottom = 2.7;

      if (height <= 670) {
        ///SE 2
        sizeImage = 1;
        sizeBox = 10;
        sizeTextMain = 2.3;
        sizeTextBottom = 3;
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
    }else{
      if (height <= 670) {
        ///SE 2
        bottomPadding = 20.0;
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
        sizeSkip = 2.5;
        sizeImage = 1;
        sizeBox = 10;
        sizeTextMain = 2.3;
        sizeTextBottom = 3;
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
    }

    if(_currentPage==0){
      Map userId = {'open': 'open'};
      logEvent('onbording1', userId);
      logEvent('onbording2', userId);
      logEvent('onbording3', userId);

      OneSignal.shared.sendTag("onbording1", "onbording1").then((response) {
        print("Successfully sent tags with response: $response");
      }).catchError((error) {
        print("Encountered an error sending tags: $error");
      });
      OneSignal.shared.sendTag("onbording2", "onbording2").then((response) {
        print("Successfully sent tags with response: $response");
      }).catchError((error) {
        print("Encountered an error sending tags: $error");
      });
      OneSignal.shared.sendTag("onbording3", "onbording3").then((response) {
        print("Successfully sent tags with response: $response");
      }).catchError((error) {
        print("Encountered an error sending tags: $error");
      });
    }



    return WillPopScope(
        onWillPop: () async => false,
        child:Scaffold(
            body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_back),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10, top: 0.0),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => SlideItem(i),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: bottomPadding, right: width * 0.08),
                          child: InkWell(
                              onTap: () async {

                                if (_pageController.page.toInt() != 3) {
                                  _pageController.animateToPage(_pageController.page.toInt() + 1,
                                      duration: Duration(milliseconds: 200), curve: Curves.easeOut);

                                  if(_currentPage==1){
                                    Map userId = {'open': 'open'};
                                    logEvent('onbording2', userId);
                                    OneSignal.shared.sendTag("onbording2", "onbording2").then((response) {
                                      print("Successfully sent tags with response: $response");
                                    }).catchError((error) {
                                      print("Encountered an error sending tags: $error");
                                    });
                                  }else if(_currentPage==2){
                                    Map userId = {'open': 'open'};
                                    logEvent('onbording3', userId);
                                    OneSignal.shared.sendTag("onbording3", "onbording3").then((response) {
                                      print("Successfully sent tags with response: $response");
                                    }).catchError((error) {
                                      print("Encountered an error sending tags: $error");
                                    });
                                  }
                                }else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                }
                              },
                              child: SvgPicture.asset(
                                  _backButton))),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: InkWell(
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.08, bottom: bottomPadding * 1.2),
                              child: Opacity(
                                  opacity: 1,
                                  child: Text(
                                    "Skip",
                                    // height.toString(),
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      color: Color(0xFF1D1D1D),
                                       fontFamily: "Poppins-SemiBold",
                                      fontSize: SizeConfig.heightMultiplier * sizeSkip,
                                    ),
                                  )),
                            )))
                  ]),
            ))));
  }
}
