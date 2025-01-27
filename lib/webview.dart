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
  const WebScreen({Key? key, this.fromDpLnk = false}) : super(key: key);
  final bool fromDpLnk;
  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String cuid = "";

  @override
  void initState() {
    super.initState();

    initConnectivity();
    cuid = getRandomString(15);

    appsflyerSdk.setCustomerUserId(cuid);

    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _checkInitialConnectivity();
    if (widget.fromDpLnk) {
      appsflyerSdk.logEvent('af_content_view', {'media_source': 'push'});
    } else {
      appsflyerSdk.logEvent('af_content_view', {});
    }
  }

//   Future<String?> getAppInstanceId() async {
//   FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   return await analytics.appInstanceId;
// }

  Future<void> initConnectivity() async {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // Got a new connectivity status!
      _updateConnectionStatus(result.last);
    });
  }

  Future<void> _checkInitialConnectivity() async {
    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result.last);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (!mounted) return;
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

  InAppWebViewController? webViewController;

  String url = "";
  double progress = 0;
  String _osidCheck = "70621a8c-7e46-46b9-88fd-1411a45982a3";

  @override
  Widget build(BuildContext context) {
    final _appState = Provider.of<AppState>(context, listen: false);

    if (_appState.osid != null) {
      _osidCheck = _appState.osid ?? 'null';
    }
    return StreamBuilder<List<ConnectivityResult>>(
      stream: _connectivity.onConnectivityChanged,
      builder: (context, _) {
        print(_connectionStatus);
        if (_connectionStatus != ConnectivityResult.none) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                  child: Icon(Icons.arrow_back_ios,
                      color: Color.fromRGBO(208, 201, 214, 1)),
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage())),
                ),
                systemOverlayStyle: SystemUiOverlayStyle.dark),
            body: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: WebUri.uri(
                  Uri.parse(Platform.isAndroid
                      ? "https://euroloan-pl.site/YB-app-gp.php?CUID=" +
                          (_appState.cuid ?? 'null') +
                          "&AFID=" +
                          (_appState.id ?? 'null') +
                          "&OSID=" +
                          _osidCheck +
                          "&FID=" +
                          (_appState.fbuid ?? 'null') +
                          "&ref=" +
                          (_appState.ref ?? 'null')
                      : "https://euroloan-pl.site/YB-app-as.php?CUID=" +
                          (_appState.cuid ?? 'null') +
                          "&AFID=" +
                          (_appState.id ?? 'null') +
                          "&OSID=" +
                          _osidCheck),
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webViewController = controller;
              },
            ),
          );
        } else {
          double height = MediaQuery.of(context).size.height;
          double sizeImage = 1;
          double sizeTextMain = 4.2;

          if (height <= 670) {
            ///SE 2
            sizeImage = 0.8;
            sizeTextMain = 3.5;
          } else if (height <= 900 && height >= 895) {
            ///XS Max & XR & 11 & 11 Pro Max
          } else if (height <= 1000 && height >= 900) {
            ///12 pro max
          } else if (height <= 739 && height >= 710) {
            /// 7 Plus
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
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF1D1D1D),
                          ),
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage())),
                        ),
                      ),
                    ),
                    Spacer(),
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
                      padding: EdgeInsets.only(right: 35.0, left: 35.0),
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
              ),
            ),
          );
        }
      },
    );
  }
}
