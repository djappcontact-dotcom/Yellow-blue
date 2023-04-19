import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loanproject/home.dart';
import 'package:loanproject/size_config.dart';
import 'package:loanproject/state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Map appsFlyerOptions = {
  "afDevKey":
      Platform.isIOS ? 'XmphTEoVgARoCrhALJusC6' : 'XXzKfE9qPGH5XTrEysZc6W',
  "afAppId": '1570037577',
  "isDebug": true
};

class WebScreen extends StatefulWidget {
  const WebScreen({Key key}) : super(key: key);

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String cuid = "";

  @override
  void initState() {
    initConnectivity();
    cuid = getRandomString(15);
    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
    appsflyerSdk.setCustomerUserId(cuid);
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
      print(result);
    } on PlatformException catch (exception) {
      print(exception.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController webViewController;
  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  String url = "";
  double progress = 0;
  String _osidCheck = "70621a8c-7e46-46b9-88fd-1411a45982a3";

  @override
  Widget build(BuildContext context) {
    final _appState = Provider.of<AppState>(context, listen: false);

    if (_appState.osid != null) {
      _osidCheck = _appState.osid;
    }
    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage())),
      child: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, _) {
          print(_connectionStatus);
          if (_connectionStatus != ConnectivityResult.none) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(40.0),
                  child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: GestureDetector(
                        child: Icon(Icons.arrow_back_ios,
                            color: Color.fromRGBO(208, 201, 214, 1)),
                        onTap: () => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage())),
                      ),
                      systemOverlayStyle: SystemUiOverlayStyle.dark)),
              body: InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(
                    url: Uri.parse(Platform.isAndroid
                        ? "https://samedayfin.com/YB-app-gp.php?CUID=" +
                            _appState.cuid +
                            "&AFID=" +
                            _appState.id +
                            "&OSID=" +
                            _osidCheck
                        : "https://samedayfin.com/YB-app-as.php?CUID=" +
                            _appState.cuid +
                            "&AFID=" +
                            _appState.id +
                            "&OSID=" +
                            _osidCheck)),
                initialOptions: options,
                onWebViewCreated: (InAppWebViewController controller) {
                  webViewController = controller;
                },
              ),
            );
          } else {
            double height = MediaQuery.of(context).size.height;
            double width = MediaQuery.of(context).size.width;
            double top = 40;
            double sizeImage = 1;
            double sizeTextMain = 4.2;

            if (height <= 670) {
              ///SE 2
              top = 40;
              sizeImage = 0.8;
              sizeTextMain = 3.5;
            } else if (height <= 900 && height >= 895) {
              ///XS Max & XR & 11 & 11 Pro Max
              top = 80;
            } else if (height <= 1000 && height >= 900) {
              ///12 pro max
              top = 130;
            } else if (height <= 739 && height >= 710) {
              /// 7 Plus
              top = 50;
              sizeImage = 0.9;
              sizeTextMain = 3.7;
            }

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Color(0xFFF1FF50),
                        Color(0xFFE8FF5B),
                      ],
                      begin: const FractionalOffset(0.0, 3.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.03,
                            top: height * 0.07,
                            right: width * 0.1),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFF1D1D1D),
                                ),
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage())),
                              ),
                            ],
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: top,
                      ),
                      Text(
                        'No internet\naccess',
                        style: TextStyle(
                          color: Color(0xFF1D1D1D),
                          fontFamily: "Phonk",
                          fontSize: SizeConfig.heightMultiplier * sizeTextMain,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * sizeImage,
                        width: MediaQuery.of(context).size.height * sizeImage,
                        child: Image.asset('assets/images/no_inet.png'),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            right: 35.0, bottom: 50.0, top: 10.0, left: 35.0),
                        child: Padding(
                          padding: EdgeInsets.only(left: 0, right: 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.asset('assets/images/buttontry.png'),
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
              ),
            );
          }
        },
      ),
    );
  }
}