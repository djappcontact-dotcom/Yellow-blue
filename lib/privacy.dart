import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loanproject/size_config.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key key}) : super(key: key);

  @override
  _SimplePageState createState() => _SimplePageState();
}

class _SimplePageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ImageProvider background = AssetImage('assets/images/back_privacy.png');

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0), // here the desired height
            child: AppBar(
              backgroundColor: Colors.black, // Status bar color
            )),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: background,
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
            child: profileView(height,
                width)) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget profileView(height, width) {
    return Container(
      child: Container(child: mainBlocks(height, width)),
    );
  }

  Widget mainBlocks(height, width) {
    double sizePadding = 1.8;
    double sizePaddingDesc = 1.5;
    double padTop = 0.07;
    double sizeTitle = 3.0;
    if (height <= 670) {
      sizePadding = 2.2;
      sizePaddingDesc = 2;
      padTop = 0.03;
      sizeTitle = 3.5;
    } else if (height <= 811 && height >= 671) {
      sizePadding = 1.8;
      sizePaddingDesc = 2;
      sizePadding = 2.0;
      padTop = 0.03;
    }

    if (Platform.isIOS) {
      if (height <= 900 && height >= 812) {
        sizeTitle = 2.8;
        padTop = 0.05;
      }
    }
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: width * 0.03, top: height * padTop, right: width * 0.1),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Opacity(
                      opacity: 1,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF1D1D1D),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      )),

                  // Opacity(
                  //     opacity: 0,
                  //     child: IconButton(
                  //       alignment: Alignment.topCenter,
                  //       icon: SvgPicture.asset('assets/svg/profile.svg'),
                  //       onPressed: () {},
                  //     )),
                  Text("Privacy Policy",
                      style: TextStyle(
                        color: Color(0xFF1D1D1D),
                        fontFamily: "Phonk",
                        fontSize: SizeConfig.heightMultiplier * sizeTitle,
                      )),
                ],
              ),
            ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Text(
                  //   'What is a microloan\n',
                  //   textScaleFactor: 1.0,
                  //   textAlign: TextAlign.left,
                  //   style: TextStyle(
                  //       fontFamily: 'Poppins-Bold', fontSize: SizeConfig.heightMultiplier * sizePadding, color: Color(0xFF1D1D1D)),
                  // ),
                  Text(
                      'To provide you with methods and principles we apply to data management on this application, we established this Privacy Policy. Please read this section before you start using our app. Please note that by using our app you confirm that you agree with our Privacy Policy.',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.heightMultiplier * sizePaddingDesc,
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF1D1D1D))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '1. Information Which We Collect\n',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: SizeConfig.heightMultiplier * sizePadding,
                        color: Color(0xFF1D1D1D)),
                  ),
                  Text(
                      'We gather the following information from you, personally identifiable information and non-personally identifiable information.\nPersonally identifiable information is the sort of data that allows us to recognize you as an individual. This information may include but is not limited to: your full name, date of birth, place of residence, phone and mobile phone number, driver’s license, social security number, relevant employment details, income, banking account, credit history, military status.\nNon-personally identifiable information relates to the data that doesn’t reveal anything about your identity. This information is anonymous and may include but is not limited to: IP address, language, time of browsing session, clicks, links you followed, etc. Such kind of data is collected through cookies and pixel tags.\nCollecting personal details of users is necessary for business management, technical support improvement and marketing research. We also need your private data to process your application and get you connected with one of our lenders.',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.heightMultiplier * sizePaddingDesc,
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF1D1D1D))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '2. How We Protect Your Information\n',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: SizeConfig.heightMultiplier * sizePadding,
                        color: Color(0xFF1D1D1D)),
                  ),
                  Text(
                      'To keep your personal information secure, we use safeguards and advanced security systems that correspond to the US law requirements regarding this matter. Only authorized personnel can access your data. They may do so only for business purposes allowed by the current US legislation.\n\nDespite our best efforts, we cannot guarantee the total safety of your data. This is impossible due to the fact that we are not able to control law violators.',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.heightMultiplier * sizePaddingDesc,
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF1D1D1D))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '3. How We Share Your Personally and Non-Personally Identifiable Information\n',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: SizeConfig.heightMultiplier * sizePadding,
                        color: Color(0xFF1D1D1D)),
                  ),
                  Text(
                      'Please be informed that you allow us to process your application and connect you with a lender by providing your personally identifiable information. That also means that we have the right to share this information with a third party because a lender cannot approve your loan without knowing anything about you.\n\nPlease note that lenders may verify your personal information by sending requests to national databases and credit reporting agencies. Such inquiries may affect your credit score. We may share some of your data with our affiliates, partners and other accredited third parties for the purposes of business management, security, advertising, marketing, consumer behavior research, consumer support improvement. We reserve the right to share your information with another company that has acquired our business, a part of it, or fused with us. In case such a situation takes place, it’s possible that we will inform you about these changes by email or with an announcement posted on our application.\n\nAlso please be aware that we may share your personally identifiable information if it is required by the law and is necessary to proceed with a legal process or to protect our rights.\n\nBy collecting and sharing your non-personally identifiable information with third parties, we improve our technical service, study behavior of our customers and gather app statistics important to the management of our business. We may share it with other third parties for these purposes.',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.heightMultiplier * sizePaddingDesc,
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF1D1D1D))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '4. Links Provided by Third Parties\n',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: SizeConfig.heightMultiplier * sizePadding,
                        color: Color(0xFF1D1D1D)),
                  ),
                  Text(
                      'When using our app, you may come upon links to third parties’ websites. All these links are given to you only as a reference. You click them on your own will. We do not manage those websites; therefore, we cannot be held accountable for their content, privacy policy, terms and practices as their management is beyond our responsibility and control.',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.heightMultiplier * sizePaddingDesc,
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF1D1D1D))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '5. How to opt-out from messages\n',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: SizeConfig.heightMultiplier * sizePadding,
                        color: Color(0xFF1D1D1D)),
                  ),
                  Text(
                      'By accessing our app, you confirm that you have nothing against receiving advertisements, marketing messages and other promotional materials from us. Our third-party partners may also send you their marketing messages using all the contacts you’ve provided us with.\n\nPlease be informed that in all emails/SMS there is a possibility to choose an option to cancel the subscription. Please use this option next time when you get the message.\n\nPlease note, that we are not responsible for the marketing practices of third parties as we do not control them. Nevertheless, if you want to opt-out from third parties’ messages, you should contact them directly with this request.\n\n',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.heightMultiplier * sizePaddingDesc,
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF1D1D1D))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '6. Restrictions\n',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: SizeConfig.heightMultiplier * sizePadding,
                        color: Color(0xFF1D1D1D)),
                  ),
                  Text(
                      'We render our services exclusively to people over 18 years old. If you are a minor, don’t access our application.\n\nWe render our services exclusively to employed residents of the United States. If you are a foreigner, don’t access our app.\n\n',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.heightMultiplier * sizePaddingDesc,
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF1D1D1D))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '7. Privacy Policy Changes\n',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: SizeConfig.heightMultiplier * sizePadding,
                        color: Color(0xFF1D1D1D)),
                  ),
                  Text(
                      'We reserve the right to revise, modify, update this Privacy Policy when we find it appropriate to do so. We can revise, modify, update the Privacy Policy without notice. For this reason we encourage you to reread this section from time to time. If you keep accessing our app after we’ve changed the Privacy Policy, then it will mean that you agree with the changes.\n\nIf there is something you would like to discuss with us or propose, please, send us a message using our email\n\n',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.heightMultiplier * sizePaddingDesc,
                          fontFamily: 'Poppins-Regular',
                          color: Color(0xFF1D1D1D))),
                ],
              ),
            ),
          ])))
        ],
      ),
    );
  }
}
