import 'dart:async';

import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SMSVerificationPage extends StatefulWidget {
  const SMSVerificationPage({ Key? key }) : super(key: key);

  @override
  _SMSVerificationPageState createState() => _SMSVerificationPageState();
}

class _SMSVerificationPageState extends State<SMSVerificationPage> {
  TextEditingController smsC = TextEditingController();
  String pNum = '';
  String vFyId = '';
  late Timer timer;
  @override
  void initState() {
    super.initState();
    getDetails();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Provider.of<GetChanges>(context, listen: false).updateSmsWaitingTime(
          cancelTimer: () {
        timer.cancel();
      });
    });
  }

  getDetails() async {
    pNum = await Utility.getUserContact();
    vFyId = await Utility.getVFyId();
  }

  exitApp() {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Card(
                  margin: EdgeInsets.only(right: 20),
                  elevation: 20,
                  color: Colors.blue,
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    color: Colors.black26,
                      ),
                    width: w / 3,
                    
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: TextFormField(
                      controller: smsC,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: TU.tlarge(context, 38),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'SMS Code',
                          hintStyle: TU.tlarge(context, 38)),
                    ),
                  ),
                )
              ],
            ),
            Card(
              elevation: 20,
              color: Colors.white,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                  splashColor: Colors.white,
                  splashRadius: 25,
                  onPressed: () {
                    var text = smsC.text.trim();
                    if (text.isEmpty) {
                      SB.ssb(context,
                          text: "You haven't entered the SMS-code yet");
                    } else if (text.length < 6 || text.length > 6) {
                      SB.ssb(context, text: 'Enter the 6 SMS-code');
                    } else {
                      SB.cpi(context);
                      FirebaseFunctions.signInUser(context,
                          smsCode: text, phoneNumber: pNum, vefyId: vFyId);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                  )),
            )
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
    return WillPopScope(
      onWillPop: () {
        Provider.of<GetChanges>(context, listen: false).turnTimeTo30();
        Utility.clearPreferences();
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Container(
                width: TU.geth(context),
                color: Color(0xFFF2F2F2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Card(
                      margin: EdgeInsets.all(20),
                      elevation: 20,
                      shadowColor: Colors.blue,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black12),
                        alignment: Alignment.bottomLeft,
                        width: TU.getw(context) * 0.7,
                        height: TU.getw(context) * 0.8,
                        padding: EdgeInsets.symmetric(horizontal:10, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Image.asset(
                                      'assets\\bDrive.png',
                                      height: 130,
                                      width: 130,
                                    ),
                                    Image.asset(
                                      'assets\\bDrive.png',
                                      height: 80,
                                      width: 80,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                Card(
                                  color: Colors.black,
                                  shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: Consumer<GetChanges>(
                                      builder: (context, value, w) {
                                        return Container(
                                          child: Text(
                                            '${value.time}',
                                            style: TU.tesmallw(context),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        TS.svp,
                                        style: TU.tlarge(context, 38),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        TS.svp2,
                                        style: TU.tesmall(context, 50),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        TS.svp3,
                                        style: TU.tsmall(context),
                                      ),
                                    ])),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(child: column)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    smsC.dispose();
    super.dispose();
  }
}
