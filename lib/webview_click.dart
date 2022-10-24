import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loanproject/size_config.dart';
import 'package:loanproject/state.dart';
import 'package:loanproject/tutorial/first.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


Map appsFlyerOptions = {
  "afDevKey": Platform.isIOS?'XmphTEoVgARoCrhALJusC6':'XXzKfE9qPGH5XTrEysZc6W',
  "afAppId": '1570037577', "isDebug": true};

class WebScreenClick extends StatefulWidget {
  const WebScreenClick({Key key}) : super(key: key);

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreenClick> {
  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool start = true;
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
    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
    appsflyerSdk.setCustomerUserId(cuid);

    // Timer(Duration(seconds: 2), () {
    //   setState(() {
    //     start = false;
    //   });
    // });

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
          _connectionStatus = result.toString();
          // controllerGlobal.reload();

        });
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController pullToRefreshController;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _appState = Provider.of<AppState>(context, listen: false);
    double height = MediaQuery.of(context).size.height;

    double sizeImageBack = 70;

    if (height <= 670) {
      ///SE 2

      sizeImageBack = 50;
    } else if (height <= 900 && height >= 895) {
      ///XS Max & XR & 11 & 11 Pro Max

      sizeImageBack = 60;
    } else if (height <= 1000 && height >= 900) {
      ///12 pro max

    } else if (height <= 739 && height >= 710) {
      /// 7 Plus

      sizeImageBack = 60;
    } else if (height <= 812 && height >= 750) {
      ///X iphone & 11 Pro

      sizeImageBack = 60;
    } else if (height <= 845 && height >= 840) {
      ///12 iphone & 12 Pro

      sizeImageBack = 60;
    }

    return WillPopScope(
        onWillPop: () => _exitAppArrow(context),
        child: StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (_connectionStatus != 'ConnectivityResult.none') {
              return Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(40.0),
                    // here the desired height
                    child: AppBar(
                        backgroundColor: Color(0xFFFFFFFF),
                        brightness: Brightness.light,
                        elevation: 0,
                        leading: GestureDetector(
                          child: Icon(Icons.arrow_back_ios,
                              color: Color.fromRGBO(208, 201, 214, 1)),
                          onTap: () => _exitAppArrow(context),
                        ))),
                body: Center(
                  child:
                  InAppWebView(
                    key: webViewKey,
                    // contextMenu: contextMenu,
                    initialUrlRequest:
                    // URLRequest(url: Uri.parse("https://google.com")),
                    URLRequest(url: Uri.parse(
                      Platform.isAndroid
                          ? "https://samedayfin.com/YB-app-gp.php?CUID=43f3423f3&AFID=8080232322&OSID=70621a8c-7e46-46b9-88fd-1411a45982a3"
                          : "https://samedayfin.com/YB-app-as.php?CUID=43f3423f3&AFID=8080232322&OSID=70621a8c-7e46-46b9-88fd-1411a45982a3"
                    )),

                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url;

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunch(url)) {
                          // Launch the App
                          await launch(
                            url,
                          );
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),

                  //Text('TEST')
                  // WebView(
                  //   initialUrl: Platform.isAndroid
                  //       ? "https://samedayfin.com/YB-app-gp.php?CUID=" +
                  //       _appState.cuid +
                  //       "&AFID=" +
                  //       _appState.id
                  //       : "https://samedayfin.com/YB-app-as.php?CUID=" +
                  //       _appState.cuid +
                  //       "&AFID=" +
                  //       _appState.id,
                  //   javascriptMode: JavascriptMode.unrestricted,
                  //   onWebViewCreated: (WebViewController webViewController) {
                  //     _controller.future
                  //         .then((value) => controllerGlobal = value);
                  //     _controller.complete(webViewController);
                  //   },
                  //   javascriptChannels: <JavascriptChannel>[
                  //     // _toasterJavascriptChannel(context),
                  //   ].toSet(),
                  //   navigationDelegate: (NavigationRequest request) async {
                  //
                  //
                  //     print('allowing navigation to $request');
                  //     return NavigationDecision.navigate;
                  //   },
                  //   onPageStarted: (String url) async {
                  //     print('Page started loading: $url');
                  //   },
                  //   onPageFinished: (String url) {
                  //     print('Page finished loading: $url');
                  //
                  //   },
                  //   gestureNavigationEnabled: true,
                  // ),

                ),
              );
            } else {
              double height = MediaQuery.of(context).size.height;
              double width = MediaQuery.of(context).size.width;
              double top = 40;
              double sizeTextButton = 2.5;
              double sizeImageBack = 70;
              double sizeImage = 1;
              double sizeTextMain = 4.2;
              double sizeText = 2;

              if (height <= 670) {
                ///SE 2
                top = 40;
                sizeImageBack = 50;
                sizeImage = 0.8;
                sizeTextMain = 3.5;
                sizeText = 2.2;
                sizeTextButton = 2.8;
              } else if (height <= 900 && height >= 895) {
                ///XS Max & XR & 11 & 11 Pro Max
                top = 80;
                sizeImageBack = 60;
              } else if (height <= 1000 && height >= 900) {
                ///12 pro max
                top = 130;
              } else if (height <= 739 && height >= 710) {
                /// 7 Plus
                top = 50;
                sizeImageBack = 60;
                sizeImage = 0.9;
                sizeTextMain = 3.7;
                sizeText = 2.4;
                sizeTextButton = 3;
              } else if (height <= 812 && height >= 750) {
                ///X iphone & 11 Pro
                sizeImageBack = 60;
              } else if (height <= 845 && height >= 840) {
                ///12 iphone & 12 Pro
                sizeImageBack = 60;
              }

              return Scaffold(
                // appBar: AppBar(
                //   backgroundColor: _appState.darkMode ? Color(0xFF002D3E) : Color(0xFFFFFFFF),
                //   brightness: _appState.darkMode ? Brightness.dark : Brightness.light,
                //   shadowColor: Colors.transparent,
                //   toolbarHeight: 0,
                //   // leading: GestureDetector(
                //   //   child: Icon(Icons.arrow_back, color: Color.fromRGBO(208, 201, 214, 1)),
                //   //   onTap: () => Navigator.of(context).pop(),
                //   // )
                // ),
                //  backgroundColor: Colors.white,
                  body: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              Color(0xFFF1FF50),
                              Color(0xFFE8FF5B),
                              //const Color(0xFF0EEDFF),
                            ],
                            begin: const FractionalOffset(0.0, 3.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Stack(children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.03,
                                  top: height * 0.07,
                                  right: width * 0.1),
                              child: Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Opacity(
                                        opacity: 1,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            color: Color(0xFF1D1D1D),
                                          ),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )),

                                    // Opacity(
                                    //     opacity: 0,
                                    //     child: IconButton(
                                    //       alignment: Alignment.topCenter,
                                    //       icon: SvgPicture.asset('assets/svg/profile.svg'),
                                    //       onPressed: () {},
                                    //     )),
                                    Opacity(
                                        opacity: 0,
                                        child: Text("Privacy Policy",
                                            style: TextStyle(
                                              color: Color(0xFF1D1D1D),
                                              fontFamily: "MainBold",
                                              fontSize:
                                              SizeConfig.heightMultiplier *
                                                  3.0,
                                            ))),
                                  ],
                                ),
                              ]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: top,
                            ),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 30,
                            // ),
                            Text(
                              'No internet\naccess',
                              style: TextStyle(
                                color: Color(0xFF1D1D1D),
                                fontFamily: "Phonk",
                                fontSize: SizeConfig.heightMultiplier *
                                    sizeTextMain,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 10,
                            ),
                            Container(
                              height:
                              MediaQuery.of(context).size.width * sizeImage,
                              width: MediaQuery.of(context).size.height *
                                  sizeImage,
                              child: Image.asset('assets/images/no_inet.png'),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 10,
                            ),
                            // Text(
                            //   'Please make sure that you have\ninternet connection',
                            //   style: TextStyle(
                            //       color: Color(0xFF064054),
                            //       fontFamily: "Main",
                            //       fontSize: SizeConfig.heightMultiplier * sizeText,
                            //       height: 1.5),
                            //   textAlign: TextAlign.center,
                            // ),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 30,
                            // ),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 35.0,
                                  bottom: 50.0,
                                  top: 10.0,
                                  left: 35.0),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 0, right: 0),
                                  child: SizedBox(
                                      width: double.infinity,
                                      // <-- match_parent
                                      child: Image.asset(
                                          'assets/images/buttontry.png'))),
                            )
                          ],
                        ),
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Padding(
                        //       padding: EdgeInsets.only(
                        //         left: width * 0.08,
                        //         top: height * 0.04,
                        //       ),
                        //       child: InkWell(
                        //           onTap: () async {
                        //             Navigator.of(context).pop();
                        //           },
                        //           child: SvgPicture.asset(
                        //
                        //             'assets/svg/back_button_black.svg',
                        //             width: sizeImageBack,
                        //           ))),
                        // )
                      ])));
            }
          },
        ));
  }


  Future<dynamic> _exitAppArrow(BuildContext context) async {

    final _appState = Provider.of<AppState>(context, listen: false);

    if(_appState.darkMode==true){
      _appState.setDarkMode(false);
      return  Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FirstTutorial();
      }));
    }else{
      return Navigator.of(context).pop();

    }


  }
}
