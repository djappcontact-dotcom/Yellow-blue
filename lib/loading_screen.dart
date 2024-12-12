import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:rating_dialog/rating_dialog.dart';

import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'var.dart' as variables;

const String title1 = "How to Use the App:";
const String message1 =
    "1. Fill out a straightforward form to request your cash.\n\n2. Review and sign the loan agreement to continue.\n\n3. Wait for the cash to be transferred to your account.\n";
const String button1 = "Continue";

const String title2 = "Please Rate Us:";
const String message2 =
    "We value your feedback and would love to hear from you!\n";
const String button2 = "Submit";

const String title3 = "Thank you for your positive rating!";
const String message3 =
    "We’d appreciate it if you could also share your feedback on Google Play to help us improve our service.\n";
const String button3 = "Rate on the Play Store";

const String title4 = "We’re sorry it wasn’t perfect.";
const String message4 =
    "If the app didn’t meet your expectations, please let us know how we can improve your experience.\n";
const String button4 = "Submit";

const String title5 = "Your message has been sent";
const String message5 = "Thank you for the feedback.";
const String button5 = "Continue";

const TextStyle titleStyle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 0,
    color: Colors.black);
const TextStyle messageStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.6,
    color: Colors.black);
const TextStyle submitButtonStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);

double nowRating = 0;
bool needReview = true;

enum Availability { loading, available, unavailable }

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final _inAppReview = InAppReview.instance;
  Future<void> _requestReview() => _inAppReview.requestReview();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  Availability _availability = Availability.loading;

  Future<void> _navigateToHome() async {
    if (mounted) {
      Navigator.of(context).pushNamed('/first');
    }
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt('counter', counter).then((bool success) {
        return counter;
      });
    });
  }

  Future<void> _SendCustomEvent(String name) async {
    await FirebaseAnalytics.instance.logEvent(name: name);
  }

  @override
  void initState() {
    super.initState();
//Remove splash screen
    initialization();

    _counter = _prefs.then((SharedPreferences prefs) {
      int? nowCounter = prefs.getInt('counter') ?? 0;

//Check counter
      if (nowCounter > 0) {
        needReview = false;
        _navigateToHome();
      } else {
//Random seed for review availability
        int rndSeed = Random().nextInt(101);
//If rndSeed >= needShowReview from FIREBASE REMOTE CONFIG, show review dialog
        if (variables.needShowReview < rndSeed) {
          _navigateToHome();
          needReview = false;
        }
      }
      return nowCounter;
    });

//Check review availability, if available show first dialog
    (<T>(T? o) => o!)(WidgetsBinding.instance).addPostFrameCallback((_) async {
      try {
        final isAvailable = await _inAppReview.isAvailable();

        setState(() {
          _availability =
              isAvailable ? Availability.available : Availability.unavailable;
        });
      } catch (_) {
        setState(() => _availability = Availability.unavailable);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFirstDialog();
    });
  }

//First dialog
  void _showFirstDialog() {
    _incrementCounter();
    final _dialog = RatingDialog(
      initialRating: 5,
      title: const Text(
        title1,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        message1,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      backgroundColor: Colors.white,
      starSize: 0,
      force: false,
      secondButton: false,
      enableComment: false,
      submitButtonText: button1,
      onSubmitted: (response) {
        _showRatingDialog();
      },
    );

    // show the dialog
    if (needReview) {
      showDialog(
        context: context,
        barrierDismissible: false, // set to false if you want to force a rating
        builder: (context) => _dialog,
      );
    }
  }

//Set Rating dialog
  void _showRatingDialog() {
    final _dialog = RatingDialog(
      initialRating: nowRating,
      // your app's name?
      title: const Text(
        title2,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        message2,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      secondButtonTextStyle: submitButtonStyle,
      backgroundColor: Colors.white,
      starSize: 30,
      force: false,
      secondButton: false,
      enableComment: false,
      submitButtonText: button2,
      onSubmitted: (response) {
//Send firebase score event
        nowRating = response.rating;
        if (nowRating == 1.0) {
          _SendCustomEvent('rating_1');
        }
        if (nowRating == 2.0) {
          _SendCustomEvent('rating_2');
        }
        if (nowRating == 3.0) {
          _SendCustomEvent('rating_3');
        }
        if (nowRating == 4.0) {
          _SendCustomEvent('rating_4');
        }
        if (nowRating == 5.0) {
          _SendCustomEvent('rating_5');
        }
        if (response.rating < 4.0) {
          _showBadDialog();
        } else {
          _showGoodDialog();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _dialog,
    );
  }

//Good dialog. If rating >= 4
  void _showGoodDialog() {
    // actual store listing review & rating
    void _rateAndReviewApp() async {
      _SendCustomEvent('goodSetYES');
      if (_availability == Availability.available) {
        //Request google play rating dialog if it is available
        _requestReview();
        _navigateToHome();
      }
    }

    final _dialog = RatingDialog(
      initialRating: nowRating,
      title: const Text(
        title3,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      secondButton: false,
      ignore: true,
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        message3,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      backgroundColor: Colors.white,
      starSize: 30,
      force: false,
      enableComment: false,
      secondButtonTextStyle: submitButtonStyle,
      submitButtonText: button3,
      onSubmitted: (response) {
        nowRating = response.rating;
        if (response.rating < 4.0 || response.rating > 20.0) {
          _navigateToHome();
        } else {
          _rateAndReviewApp();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _dialog,
    );
  }

//Bad dialog. If rating < 4
  void _showBadDialog() {
    final _dialog = RatingDialog(
      initialRating: nowRating,
      title: const Text(
        title4,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      ignore: true,
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        message4,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      secondButton: false,
      backgroundColor: Colors.white,
      starSize: 30,
      force: false,
      enableComment: true,
      submitButtonText: button4,
      onSubmitted: (response) {
        nowRating = response.rating;
        _showFinalDialog();
      },
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _dialog,
    );
  }

//Final dialog
  void _showFinalDialog() {
    final _dialog = RatingDialog(
      initialRating: nowRating,
      // your app's name?
      title: const Text(
        title5,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        message5,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      ignore: true,
      backgroundColor: Colors.white,
      starSize: 30,
      force: false,
      enableComment: false,
      secondButton: false,
      submitButtonText: button5,
      onSubmitted: (response) {
        if (mounted) {
          Navigator.pop(context);
        }
        _navigateToHome();
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

// If clicked on the background, the review will be canceled
      body: GestureDetector(
        onTap: () {
          _SendCustomEvent("reviewCanceled");
          _navigateToHome();
        },
        child: Container(
          color: const Color(0xff2050F6),
          child: Align(
            alignment: Alignment.topCenter,
            child: new Image.asset('assets/images/splash_back.png'),
          ),
        ),
      ),
    );
  }
}
