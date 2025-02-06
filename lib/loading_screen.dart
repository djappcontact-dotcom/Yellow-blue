import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:rating_dialog/rating_dialog.dart';

import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'var.dart' as variables;

const String firstDialogTitle = "How to Use the App:";
const String firstDialogMessage =
    "1. Fill out the simple form to request your funds.\n\n2. Review and agree to the terms to proceed.\n\n3. Wait for your money to be deposited into your account.		\n\n";
const String firstDialogButtonText = "Continue";

const String ratingDialogTitle = "Please Rate Us:";
const String ratingDialogMessage =
    "Your opinion matters to us! We’d love to hear what you think about our app.			\n";
const String ratingDialogButtonText = "Submit";

const String goodDialogTitle = "Thank you for your positive rating!";
const String goodDialogMessage =
    "We’d love it if you could share your review on Google Play to help us improve.			\n";
const String goodDialogButtonText = "Rate on the Play Store";

const String badDialogTitle = "We’re sorry to hear that.";
const String badDialogMessage =
    "If the app fell short of your expectations, please share how we can improve.			\n";
const String badDialogButtonText = "Submit";

const String finalDialogTitle = "We’ve received your message.";
const String finalDialogMessage =
    "Thanks for taking the time to share your feedback.		";
const String finalDialogButtonText = "Continue";

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
const TextStyle submitButtonStyle = TextStyle(
  color: Color(0xFFF9FF00),
  fontSize: 23,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w700,
);

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
  Future<void> _requestReview() async {
    if (await _inAppReview.isAvailable()) {
      // Open the store review page
      _inAppReview.openStoreListing();
    } else {
      _showRatingDialog();
    }
  }

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
    if (Platform.isIOS) {
      _navigateToHome();
    }
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

  Future<void> _sendCustomEvent(String name) async {
    await FirebaseAnalytics.instance.logEvent(name: name);
  }

  Future<void> _sendCustomEventWithMessage(String name, String message) async {
    await FirebaseAnalytics.instance
        .logEvent(name: name, parameters: {"message": "$message"});
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
        firstDialogTitle,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        firstDialogMessage,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      backgroundColor: Colors.white,
      starSize: 0,
      force: false,
      secondButton: false,
      enableComment: false,
      submitButtonText: firstDialogButtonText,
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
        ratingDialogTitle,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        ratingDialogMessage,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      secondButtonTextStyle: submitButtonStyle,
      backgroundColor: Colors.white,
      starSize: 30,
      force: false,
      secondButton: false,
      enableComment: false,
      submitButtonText: ratingDialogButtonText,
      onSubmitted: (response) {
//Send firebase score event
        nowRating = response.rating;
        if (nowRating == 1.0) {
          _sendCustomEvent('rating_1');
        }
        if (nowRating == 2.0) {
          _sendCustomEvent('rating_2');
        }
        if (nowRating == 3.0) {
          _sendCustomEvent('rating_3');
        }
        if (nowRating == 4.0) {
          _sendCustomEvent('rating_4');
        }
        if (nowRating == 5.0) {
          _sendCustomEvent('rating_5');
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
      _sendCustomEvent('goodSetYES');
      if (_availability == Availability.available) {
        //Request google play rating dialog if it is available
        _requestReview();
        _navigateToHome();
      }
    }

    final _dialog = RatingDialog(
      initialRating: nowRating,
      title: const Text(
        goodDialogTitle,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      secondButton: false,
      ignore: true,
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        goodDialogMessage,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      backgroundColor: Colors.white,
      starSize: 30,
      force: false,
      enableComment: false,
      secondButtonTextStyle: submitButtonStyle,
      submitButtonText: goodDialogButtonText,
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
        badDialogTitle,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      ignore: true,
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        badDialogMessage,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      secondButton: false,
      backgroundColor: Colors.white,
      starSize: 30,
      force: false,
      enableComment: true,
      submitButtonText: badDialogButtonText,
      onSubmitted: (response) {
        nowRating = response.rating;
        _sendCustomEventWithMessage("bad_review_message", response.comment);
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
        finalDialogTitle,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      submitButtonTextStyle: submitButtonStyle,
      message: const Text(
        finalDialogMessage,
        textAlign: TextAlign.left,
        style: messageStyle,
      ),
      ignore: true,
      backgroundColor: Colors.white,
      starSize: 30,
      force: false,
      enableComment: false,
      secondButton: false,
      submitButtonText: finalDialogButtonText,
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: const Color(0xFFA9D6FF),
          child: Align(
            alignment: Alignment.topCenter,
            child: new Image.asset('assets/images/splash_back.png'),
          ),
        ),
      ),
    );
  }
}
