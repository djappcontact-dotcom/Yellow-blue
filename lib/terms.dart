import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loanproject/size_config.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({Key key}) : super(key: key);

  @override
  _SimplePageState createState() => _SimplePageState();
}

class _SimplePageState extends State<TermsPage> {

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
            ),
          ),
          child: profileView(height,
              width)), // This trailing comma makes auto-formatting nicer for build methods.
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
      sizePadding = 2.0;
      sizePaddingDesc = 2;
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
                  Text("Terms of Use",
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
              child: Column(
                children: [
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
                        Text(
                            'In this document described important information concerning our terms and conditions of your usage of this application (hereinafter also referred to as ‘Company’, ‘we’, ‘us’, ‘app’, ‘application’, etc.). We encourage you to read it carefully and revisit this section once in a while because we have the right to modify and update the present Terms as we see fit. We also recommend that you read other sections of our app, such as the Privacy Policy that highlights our data management practices.\n\nPlease bear in mind that as soon as you start using our app, you admit that you agree to our Terms and Privacy Policy and are ready to abide by them. If you disagree with these Terms of Use, do not access our app in the first place. By clicking links like “Submit”, “I Agree”, “E-Sign”, “Consent”, etc., you give your electronic signature. You also consent that you are able to communicate with us and third parties electronically.\n\nIf you violate our Terms of Use, we reserve the right to terminate your account without notice and remove any content or materials you submitted to our app.',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier *
                                    sizePaddingDesc,
                                fontFamily: 'Poppins-Regular',
                                color: Color(0xFF1D1D1D))),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.only(
                        left: 15, top: 20, right: 15, bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '1. Usage Restrictions\n',
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins-Bold',
                              fontSize:
                                  SizeConfig.heightMultiplier * sizePadding,
                              color: Color(0xFF1D1D1D)),
                        ),
                        Text(
                            'To access our app, you must be at least 18 years, have a steady source of income, and be a legal resident of the United States. Foreigners and minors cannot use our platform and we do not deliberately collect any data from them.',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier *
                                    sizePaddingDesc,
                                fontFamily: 'Poppins-Regular',
                                color: Color(0xFF1D1D1D))),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.only(
                        left: 15, top: 20, right: 15, bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '2. What Services We Render\n',
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins-Bold',
                              fontSize:
                                  SizeConfig.heightMultiplier * sizePadding,
                              color: Color(0xFF1D1D1D)),
                        ),
                        Text(
                            'The purpose of our app is to give you quick access to a network of trustworthy lenders. We are not lenders ourselves, we are a free-of-charge platform that allows you to submit a funding request and get connected with a financial provider. We do not lend money, we do not participate in your communication with a lender and we do not represent or promote the services of any particular lender. You are under no obligation to use our app, submit your personal details, or agree to a loan offer made by a third-party lender.\n\nAll the questions regarding your loan, agreement, fees, APR, and other conditions should be addressed to your lender as we ourselves are not involved in the lending process. We will not be liable for any damages, costs, or misunderstanding that may arise from the communication between you and your lender.\n\nBy using our app you are aware that you need to enter some of your personal information to get access to our network of lenders. You understand that we may share this information with them and that they, in their turn, may also use it. Our policy of data management is clearly expressed in the section for Privacy Policy. By using this app, you consent to our Privacy Policy. You also consent to use our app only for its direct purposes and in full accordance with our terms and the US legislation.\n\nNote that some lenders may verify your personal information to see your eligibility. They may address national databases and credit reporting agencies with such requests. Some of these inquiries may affect your credit score.\n\nThe minimum period of quick loan repayment is 65 days. The max loan repayment term is 2 years. The maximum APR for our online loans is 35.95% (including all possible fees that may apply). All conditions for your loan will be set by your lender, and you will be notified of this before accepting the offer of the instant money loan. Please, be informed that you have to contact your lender directly if you want to negotiate a specific repayment schedule. This can be done if you are unable to make monthly payments.\n\nBelow we\'d like to provide you with a representative example of possible conditions for a quick loan. You want to secure a \$500 loan quickly. For example, the period for such payday loans is 3 months. The annual percentage rate is 20%. The monthly payment that you need to do is \$172.25. The total amount owing is \$516.76. So the interest on this fast cash loan will be \$16.76.',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier *
                                    sizePaddingDesc,
                                fontFamily: 'Poppins-Regular',
                                color: Color(0xFF1D1D1D))),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.only(
                        left: 15, top: 20, right: 15, bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '3. Intellectual Property Rights\n',
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins-Bold',
                              fontSize:
                                  SizeConfig.heightMultiplier * sizePadding,
                              color: Color(0xFF1D1D1D)),
                        ),
                        Text(
                            'Our app, its logo, content, and other materials are protected by US copyright laws. By giving you access to our app we DO NOT delegate our intellectual property rights to you. Any reproduction, sale, copy, or other misuses of this app without our written permission is a violation of our rights and will be treated as such.\n\nWe reserve our right to make amendments, delete, change, or modify any content of the add regarding which the agreement is made. If you continue to use the app, you automatically agree and accept these changes.',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier *
                                    sizePaddingDesc,
                                fontFamily: 'Poppins-Regular',
                                color: Color(0xFF1D1D1D))),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.only(
                        left: 15, top: 20, right: 15, bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '4. Disclaimer of Warranties\n',
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins-Bold',
                              fontSize:
                                  SizeConfig.heightMultiplier * sizePadding,
                              color: Color(0xFF1D1D1D)),
                        ),
                        Text(
                            'This app and the services offered are available “as is” and on the basis of the stated availability. They are accessed and used at your own risk after understanding the terms of use. This company makes no warranties or guarantees whatsoever with the service or any product presented via the app, and they are subject to change without any prior notifications. Also, the company does not guarantee that its services will meet your requirements at any given point in time or that the services offered by the company will be uninterrupted, secure or error-free. The software and other technologies used by the company may come with errors that will be corrected by the company when possible.\n\nThe company does not guarantee that any third party software, websites and tools will be secure or error-free. As a result, the company will not accept any liability arising out of such errors or problems. This company carries no responsibilities for the links of third-party providers and financial service providers presented on the app. It is up to you to visit these third-party links and accept the product or services offered by them. By visiting such links, you fall under the power of the terms and conditions, which govern the websites or other locations you get following these links, so you are at your own risk and the company is not liable for any losses accrued to you through such actions.',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier *
                                    sizePaddingDesc,
                                fontFamily: 'Poppins-Regular',
                                color: Color(0xFF1D1D1D))),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.only(
                        left: 15, top: 20, right: 15, bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '5. Force Majeure Event and Disputes Solving\n',
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins-Bold',
                              fontSize:
                                  SizeConfig.heightMultiplier * sizePadding,
                              color: Color(0xFF1D1D1D)),
                        ),
                        Text(
                            'You agree and fully understand that we carry no responsibility for the damage, harm, events or the consequences of the events, which happen beyond our control, including but not limited to the events of the failure of mechanical equipment or communication, malicious online activity, errors, natural disasters, strikes, wars and governmental restrictions.\n\nIf you choose to use this app, you confirm that you agree to indemnify it and its parental company together with any subsidiaries and affiliates. You agree that we won’t be responsible for any damages, costs, and misunderstanding that may arise through your use of our app.\n\nAll disputes that may arise between you and this app shall be resolved through arbitration only. By accessing the app you admit that you agree to solve any dispute through arbitration. You also agree that to waive your rights to represent yourself individually or through legal counsel in court.',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier *
                                    sizePaddingDesc,
                                fontFamily: 'Poppins-Regular',
                                color: Color(0xFF1D1D1D))),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.only(
                        left: 15, top: 20, right: 15, bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '6. Contact Us\n',
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins-Bold',
                              fontSize:
                                  SizeConfig.heightMultiplier * sizePadding,
                              color: Color(0xFF1D1D1D)),
                        ),
                        Text(
                            'If there is something you would like to discuss with us, please, send us a message using our email\n\n',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: SizeConfig.heightMultiplier *
                                    sizePaddingDesc,
                                fontFamily: 'Poppins-Regular',
                                color: Color(0xFF1D1D1D))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
