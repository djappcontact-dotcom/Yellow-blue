import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:loanproject/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loanproject/state.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

Map appsFlyerOptions = {
  "afDevKey":
      Platform.isIOS ? 'XmphTEoVgARoCrhALJusC6' : 'XXzKfE9qPGH5XTrEysZc6W',
  "afAppId": '1570037577',
  "isDebug": true
};

class Calculat extends StatefulWidget {
  const Calculat({Key? key}) : super(key: key);

  @override
  State<Calculat> createState() => _CalculatState();
}

class _CalculatState extends State<Calculat> {
  bool _viewResult = false;
  TextEditingController _loanAmount = new TextEditingController();
  TextEditingController _loanTerms1 = new TextEditingController();
  TextEditingController _loanTerms2 = new TextEditingController();
  TextEditingController _interest1 = new TextEditingController();
  TextEditingController _interest2 = new TextEditingController();

  TextEditingController _resultTerms1Monthly = new TextEditingController();
  TextEditingController _resultTerms2Monthly = new TextEditingController();
  TextEditingController _resultTerms1TotalPayment = new TextEditingController();
  TextEditingController _resultTerms2TotalPayment = new TextEditingController();
  TextEditingController _resultTerms1TotalInterest =
      new TextEditingController();
  TextEditingController _resultTerms2TotalInterest =
      new TextEditingController();

  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

  @override
  void initState() {
    super.initState();
    Map userId = {'open': 'open'};
    logEvent('calculator', userId);

    OneSignal.shared.setNotificationOpenedHandler((notification) {
      final _appState = Provider.of<AppState>(context, listen: false);
      Map userId = {'CUID': _appState.cuid};
      logEvent('GetLoan', userId);
      Navigator.pushReplacementNamed(context, '/home');
      Timer(Duration(milliseconds: 100),
              () async => await Navigator.pushReplacementNamed(context, '/web'));
    });
  }

  String _getPickerValues() {
    var arr = [];
    for (int i = 2; i < 25; i++) {
      arr.add(i);
    }
    return '''$arr''';
  }

  Future<bool?> logEvent(String eventName, Map eventValues) async {
    bool? result;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (exception) {
      print(exception);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double sizePadding = 1.8;

    double sizeTop = 0.07;
    print(height);
    if (height <= 670) {
      sizePadding = 2.0;
      sizeTop = 0.05;
    } else if (height <= 811 && height >= 671) {
      sizePadding = 1.8;
      // sizePadding = 2.0;
      sizeTop = 0.05;
    }

    if (Platform.isIOS) {
      if (height <= 900 && height >= 812) {
        sizeTop = 0.05;
      }
    }

    if (Platform.isAndroid) {
      if (height <= 846 && height >= 842) {
        sizeTop = 0.02;
      }
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0), // here the desired height
            child: AppBar(
              backgroundColor: Colors.black, // Status bar color
            )),
        resizeToAvoidBottomInset: false,
        body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/back_calculat.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            top: height * sizeTop,
                            right: 16),
                        child: Column(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              Text("Loan Comparison\nCalculator",
                                  style: TextStyle(
                                    color: Color(0xFF1D1D1D),
                                    fontFamily: "Phonk",
                                    fontSize:
                                        24,
                                  )),
                            ],
                          ),
                        ]),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          padding: EdgeInsets.only(
                              left: 0, top: 45, right: 0, bottom: 0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Loan Amount:',
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    fontSize: SizeConfig.heightMultiplier *
                                        sizePadding,
                                    color: Color(0xFF1D1D1D)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(10.0)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      stops: [
                                        0.1,
                                        0.5
                                      ],
                                      colors: [
                                        Color(0xFF1C1C1C),
                                        Color(0xFF454545)
                                      ]),
                                ),
                                child: TextField(
                                  style: TextStyle(
                                      fontFamily: 'Poppins-SemiBold',
                                      fontSize: SizeConfig.heightMultiplier *
                                          sizePadding,
                                      color: Colors.white),
                                  controller: _loanAmount,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.only(
                                      left: 0, top: 10, right: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Loan Term 1',
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'Poppins-Medium',
                                            fontSize:
                                                SizeConfig.heightMultiplier *
                                                    sizePadding,
                                            color: Color(0xFF1D1D1D)),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Picker(
                                              adapter: PickerDataAdapter<
                                                      String>(
                                                  pickerData: JsonDecoder()
                                                      .convert(
                                                          _getPickerValues())),
                                              changeToFirst: true,
                                              hideHeader: false,
                                              onConfirm:
                                                  (Picker picker, List value) {
                                                _loanTerms1.text = picker
                                                    .adapter.text
                                                    .replaceAll(']', '')
                                                    .replaceAll('[', '');
                                                print(value.toString());
                                                print(picker.adapter.text);
                                              }).showModal(this.context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(10.0)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                stops: [
                                                  0.1,
                                                  0.5
                                                ],
                                                colors: [
                                                  Color(0xFF1C1C1C),
                                                  Color(0xFF454545)
                                                ]),
                                          ),
                                          child: TextField(
                                            enabled: false,
                                            style: TextStyle(
                                                fontFamily: 'Poppins-SemiBold',
                                                fontSize: SizeConfig
                                                        .heightMultiplier *
                                                    sizePadding,
                                                color: Colors.white),
                                            controller: _loanTerms1,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                                Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    padding: EdgeInsets.only(
                                        left: 0, top: 10, right: 0, bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.5,
                                            color: Color(0xFFF1FF50)),
                                      ),
                                    ),
                                    child: Text(
                                      'Month',
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Medium',
                                          fontSize:
                                              SizeConfig.heightMultiplier *
                                                  sizePadding,
                                          color: Color(0xFF1D1D1D)),
                                    )),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.only(
                                      left: 0, top: 10, right: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Interest(%)',
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'Poppins-Medium',
                                            fontSize:
                                                SizeConfig.heightMultiplier *
                                                    sizePadding,
                                            color: Color(0xFF1D1D1D)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(10.0)),
                                          gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              stops: [
                                                0.1,
                                                0.5
                                              ],
                                              colors: [
                                                Color(0xFF1C1C1C),
                                                Color(0xFF454545)
                                              ]),
                                        ),
                                        child: TextField(
                                          style: TextStyle(
                                              fontFamily: 'Poppins-SemiBold',
                                              fontSize:
                                                  SizeConfig.heightMultiplier *
                                                      sizePadding,
                                              color: Colors.white),
                                          controller: _interest1,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02, bottom: height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.only(
                                      left: 0, top: 10, right: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Loan Term 2',
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'Poppins-Medium',
                                            fontSize:
                                                SizeConfig.heightMultiplier *
                                                    sizePadding,
                                            color: Color(0xFF1D1D1D)),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Picker(
                                              adapter: PickerDataAdapter<
                                                      String>(
                                                  pickerData: JsonDecoder()
                                                      .convert(
                                                          _getPickerValues())),
                                              changeToFirst: true,
                                              hideHeader: false,
                                              onConfirm:
                                                  (Picker picker, List value) {
                                                _loanTerms2.text = picker
                                                    .adapter.text
                                                    .replaceAll(']', '')
                                                    .replaceAll('[', '');
                                                print(value.toString());
                                                print(picker.adapter.text);
                                              }).showModal(this.context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(10.0)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                stops: [
                                                  0.1,
                                                  0.5
                                                ],
                                                colors: [
                                                  Color(0xFF1C1C1C),
                                                  Color(0xFF454545)
                                                ]),
                                          ),
                                          child: TextField(
                                            enabled: false,
                                            style: TextStyle(
                                                fontFamily: 'Poppins-SemiBold',
                                                fontSize: SizeConfig
                                                        .heightMultiplier *
                                                    sizePadding,
                                                color: Colors.white),
                                            controller: _loanTerms2,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                                Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    padding: EdgeInsets.only(
                                        left: 0, top: 10, right: 0, bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.5,
                                            color: Color(0xFFF1FF50)),
                                      ),
                                    ),
                                    child: Text(
                                      'Month',
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Medium',
                                          fontSize:
                                              SizeConfig.heightMultiplier *
                                                  sizePadding,
                                          color: Color(0xFF1D1D1D)),
                                    )),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding: EdgeInsets.only(
                                      left: 0, top: 10, right: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Interest(%)',
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'Poppins-Medium',
                                            fontSize:
                                                SizeConfig.heightMultiplier *
                                                    sizePadding,
                                            color: Color(0xFF1D1D1D)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(10.0)),
                                          gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              stops: [
                                                0.1,
                                                0.5
                                              ],
                                              colors: [
                                                Color(0xFF1C1C1C),
                                                Color(0xFF454545)
                                              ]),
                                        ),
                                        child: TextField(
                                          style: TextStyle(
                                              fontFamily: 'Poppins-SemiBold',
                                              fontSize:
                                                  SizeConfig.heightMultiplier *
                                                      sizePadding,
                                              color: Colors.white),
                                          controller: _interest2,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.only(
                              right: 15.0, bottom: 0.0, top: 10.0, left: 15.0),
                          child: InkWell(
                              onTap: () {
                                if (_loanAmount.text.isNotEmpty &&
                                    _loanTerms1.text.isNotEmpty &&
                                    _loanTerms2.text.isNotEmpty &&
                                    _interest1.text.isNotEmpty &&
                                    _interest2.text.isNotEmpty) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  double amount =
                                      double.parse(_loanAmount.text);
                                  double interest1 =
                                      double.parse(_interest1.text) / 100 / 12;
                                  double x1 = pow(1 + interest1,
                                          double.parse(_loanTerms1.text))
                                      .toDouble();
                                  double mP1 =
                                      (amount * x1 * interest1) / (x1 - 1);
                                  double monthPay1 = roundDouble(mP1, 2);
                                  double tC1 =
                                      (mP1 * double.parse(_loanTerms1.text));
                                  double totalCost1 = roundDouble(tC1, 2);

                                  String totalInterest1 =
                                      (totalCost1 - amount).toStringAsFixed(2);

                                  double interest2 =
                                      double.parse(_interest2.text) / 100 / 12;
                                  double x2 = pow(1 + interest2,
                                          double.parse(_loanTerms2.text))
                                      .toDouble();
                                  double mP2 =
                                      (amount * x2 * interest2) / (x2 - 1);
                                  double monthPay2 = roundDouble(mP2, 2);
                                  double tC2 =
                                      (mP2 * double.parse(_loanTerms2.text));
                                  double totalCost2 = roundDouble(tC2, 2);

                                  String totalInterest2 =
                                      (totalCost2 - amount).toStringAsFixed(2);

                                  setState(() {
                                    _resultTerms1Monthly.text =
                                        monthPay1.toString();
                                    _resultTerms2Monthly.text =
                                        monthPay2.toString();
                                    _resultTerms1TotalPayment.text =
                                        totalCost1.toString();
                                    _resultTerms2TotalPayment.text =
                                        totalCost2.toString();
                                    _resultTerms1TotalInterest.text =
                                        totalInterest1.toString();
                                    _resultTerms2TotalInterest.text =
                                        totalInterest2.toString();
                                    _viewResult = true;
                                  });
                                } else if (_loanAmount.text.isNotEmpty &&
                                    _loanTerms1.text.isNotEmpty &&
                                    _interest1.text.isNotEmpty) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  double amount =
                                      double.parse(_loanAmount.text);
                                  double interest =
                                      double.parse(_interest1.text) / 100 / 12;
                                  double x = pow(1 + interest,
                                          double.parse(_loanTerms1.text))
                                      .toDouble();
                                  double mP = (amount * x * interest) / (x - 1);
                                  double monthPay1 = roundDouble(mP, 2);
                                  double tC =
                                      (mP * double.parse(_loanTerms1.text));
                                  double totalCost1 = roundDouble(tC, 2);

                                  String totalInterest1 =
                                      (totalCost1 - amount).toStringAsFixed(2);
                                  //
                                  setState(() {
                                    _resultTerms1Monthly.text =
                                        monthPay1.toString();

                                    _resultTerms1TotalPayment.text =
                                        totalCost1.toString();

                                    _resultTerms1TotalInterest.text =
                                        totalInterest1.toString();

                                    _viewResult = true;
                                  });
                                } else if (_loanAmount.text.isNotEmpty &&
                                    _loanTerms2.text.isNotEmpty &&
                                    _interest2.text.isNotEmpty) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  double amount =
                                      double.parse(_loanAmount.text);
                                  double interest =
                                      double.parse(_interest2.text) / 100 / 12;
                                  double x = pow(1 + interest,
                                          double.parse(_loanTerms2.text))
                                      .toDouble();
                                  double mP = (amount * x * interest) / (x - 1);
                                  double monthPay2 = roundDouble(mP, 2);
                                  double tC =
                                      (mP * double.parse(_loanTerms2.text));
                                  double totalCost2 = roundDouble(tC, 2);

                                  String totalInterest2 =
                                      (totalCost2 - amount).toStringAsFixed(2);

                                  setState(() {
                                    _resultTerms2Monthly.text =
                                        monthPay2.toString();

                                    _resultTerms2TotalPayment.text =
                                        totalCost2.toString();

                                    _resultTerms2TotalInterest.text =
                                        totalInterest2.toString();
                                    _viewResult = true;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "You have not entered all the data",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: SizedBox(
                                  width: double.infinity,
                                  // <-- match_parent
                                  child: Image.asset(
                                      'assets/images/button_calc.png'))),
                        ),
                        (() {
                          if (_viewResult == false) {
                            return Container();
                          } else {
                            return Padding(
                                padding: EdgeInsets.only(top: height * 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 10,
                                            right: 0,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.5,
                                                color: Color(0xFFF1FF50)),
                                          ),
                                        ),
                                        child: Text(
                                          'Monthly\nPayment:',
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: 'Poppins-Medium',
                                              fontSize:
                                                  SizeConfig.heightMultiplier *
                                                      sizePadding,
                                              color: Color(0xFF1D1D1D)),
                                        )),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          top: 10,
                                          right: 0,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Loan Term 1\n',
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'Poppins-Medium',
                                                fontSize: SizeConfig
                                                        .heightMultiplier *
                                                    sizePadding,
                                                color: Color(0xFF1D1D1D)),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  stops: [
                                                    0.1,
                                                    0.5
                                                  ],
                                                  colors: [
                                                    Color(0xFF1C1C1C),
                                                    Color(0xFF454545)
                                                  ]),
                                            ),
                                            child: TextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins-SemiBold',
                                                  fontSize: SizeConfig
                                                          .heightMultiplier *
                                                      sizePadding,
                                                  color: Colors.white),
                                              enableInteractiveSelection: false,
                                              controller: _resultTerms1Monthly,
                                              enabled: false,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          top: 10,
                                          right: 0,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Loan Term 2\n',
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'Poppins-Medium',
                                                fontSize: SizeConfig
                                                        .heightMultiplier *
                                                    sizePadding,
                                                color: Color(0xFF1D1D1D)),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  stops: [
                                                    0.1,
                                                    0.5
                                                  ],
                                                  colors: [
                                                    Color(0xFF1C1C1C),
                                                    Color(0xFF454545)
                                                  ]),
                                            ),
                                            child: TextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins-SemiBold',
                                                  fontSize: SizeConfig
                                                          .heightMultiplier *
                                                      sizePadding,
                                                  color: Colors.white),
                                              enableInteractiveSelection: false,
                                              controller: _resultTerms2Monthly,
                                              enabled: false,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ));
                          }
                        }()),
                        (() {
                          if (_viewResult == false) {
                            return Container();
                          } else {
                            return Padding(
                                padding: EdgeInsets.only(top: height * 0.01),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 10,
                                            right: 0,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.5,
                                                color: Color(0xFFF1FF50)),
                                          ),
                                        ),
                                        child: Text(
                                          'Total\nPayment:',
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: 'Poppins-Medium',
                                              fontSize:
                                                  SizeConfig.heightMultiplier *
                                                      sizePadding,
                                              color: Color(0xFF1D1D1D)),
                                        )),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          top: 10,
                                          right: 0,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  stops: [
                                                    0.1,
                                                    0.5
                                                  ],
                                                  colors: [
                                                    Color(0xFF1C1C1C),
                                                    Color(0xFF454545)
                                                  ]),
                                            ),
                                            child: TextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins-SemiBold',
                                                  fontSize: SizeConfig
                                                          .heightMultiplier *
                                                      sizePadding,
                                                  color: Colors.white),
                                              enableInteractiveSelection: false,
                                              controller:
                                                  _resultTerms1TotalPayment,
                                              enabled: false,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          top: 10,
                                          right: 0,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  stops: [
                                                    0.1,
                                                    0.5
                                                  ],
                                                  colors: [
                                                    Color(0xFF1C1C1C),
                                                    Color(0xFF454545)
                                                  ]),
                                            ),
                                            child: TextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins-SemiBold',
                                                  fontSize: SizeConfig
                                                          .heightMultiplier *
                                                      sizePadding,
                                                  color: Colors.white),
                                              enableInteractiveSelection: false,
                                              controller:
                                                  _resultTerms2TotalPayment,
                                              enabled: false,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ));
                          }
                        }()),
                        (() {
                          if (_viewResult == false) {
                            return Container();
                          } else {
                            return Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.01, bottom: height * 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 10,
                                            right: 0,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.5,
                                                color: Color(0xFFF1FF50)),
                                          ),
                                        ),
                                        child: Text(
                                          'Total\nInterest:  ',
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: 'Poppins-Medium',
                                              fontSize:
                                                  SizeConfig.heightMultiplier *
                                                      sizePadding,
                                              color: Color(0xFF1D1D1D)),
                                        )),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          top: 10,
                                          right: 0,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  stops: [
                                                    0.1,
                                                    0.5
                                                  ],
                                                  colors: [
                                                    Color(0xFF1C1C1C),
                                                    Color(0xFF454545)
                                                  ]),
                                            ),
                                            child: TextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins-SemiBold',
                                                  fontSize: SizeConfig
                                                          .heightMultiplier *
                                                      sizePadding,
                                                  color: Colors.white),
                                              enableInteractiveSelection: false,
                                              controller:
                                                  _resultTerms1TotalInterest,
                                              enabled: false,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          top: 10,
                                          right: 0,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  stops: [
                                                    0.1,
                                                    0.5
                                                  ],
                                                  colors: [
                                                    Color(0xFF1C1C1C),
                                                    Color(0xFF454545)
                                                  ]),
                                            ),
                                            child: TextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins-SemiBold',
                                                  fontSize: SizeConfig
                                                          .heightMultiplier *
                                                      sizePadding,
                                                  color: Colors.white),
                                              enableInteractiveSelection: false,
                                              controller:
                                                  _resultTerms2TotalInterest,
                                              enabled: false,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ));
                          }
                        }()),
                      ])))
                    ],
                  ),
                ))));
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }
}
