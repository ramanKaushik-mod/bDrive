import 'dart:async';

import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController nCon = TextEditingController();
  TextEditingController sCon = TextEditingController();
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: InkResponse(
        onTap: () async {
          if (!await CIC.checkConnectivity(context)) return;
          GetChanges val = Provider.of<GetChanges>(context, listen: false);
          if (val.getCodeSentSemaphore() == false) {
            var text = nCon.text.trim();
            if (text.isEmpty) {
              SB.ssb(context, text: "You haven't entered your number yet");
            } else if (text.length < 10 || text.length > 10) {
              SB.ssb(context, text: 'Enter a 10 digit number');
            } else {
              SB.sdb(context, () {
                val.updateCodeSentSemaphore(flag: true);
                FirebaseFunctions.verifyNumber(context, '$text');
                timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  Provider.of<GetChanges>(context, listen: false)
                      .updateSmsWaitingTime(cancelTimer: () {
                    timer.cancel();
                  });
                });
              }, () {}, null,
                  dialog: 'Are you sure about your number\n\n$text');
            }
          }
          if (val.getUpdateTime() == 0) {
            var text = sCon.text.trim();
            if (text.isEmpty) {
              SB.ssb(context, text: "You haven't entered the SMS-code yet");
            } else if (text.length < 6 || text.length > 6) {
              SB.ssb(context, text: 'Enter the 6-digit SMS-code');
            } else {
              val.updateLoadingIndicatorStatus(flag: true);
              FirebaseFunctions.signInUser(context,
                  smsCode: text,
                  phoneNumber: nCon.text.trim(),
                  vefyId: await Utility.getVFyId());
            }
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue[900],
          shadowColor: Colors.blue,
          elevation: 10,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:Colors.white10
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.black38,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Card(
                  color: Colors.white,
                  shadowColor: Colors.blue,
                  elevation: 0,
                  shape:RoundedRectangleBorder(borderRadius:BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5))),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      color: Colors.black38,
                    ),
                    width: TU.getw(context),
                    child: Wrap(
                      runAlignment: WrapAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Text(
                              TS.nvp,
                              style: TU.tlarge(context, 32),
                            )),
                            Stack(
                              children: [
                                Image.asset(
                                  'assets\\bDrive.png',
                                  height: TU.getw(context) / 2.5,
                                  width: TU.getw(context) / 2.5,
                                ),
                                Image.asset(
                                  'assets\\bDrive.png',
                                  height: TU.getw(context) / 4.2,
                                  width: TU.getw(context) / 4.2,
                                  color: Colors.white60,
                                ),
                              ],
                            ),
                          ],
                        ),
                        TF.instl(context, text: TS.nvp1, fSize: 54),
                        Container(
                          height: 30,
                        ),
                        TF.instl(context, text: TS.svp, fSize: 54),
                        Container(
                          height: 30,
                        ),
                        TF.instl(context, text: TS.svp2, fSize: 54),
                        Container(
                          height: 50,
                        ),
                        Container(
                          width: TU.getw(context),
                          height: 40,
                          margin: EdgeInsets.only(right: 20),
                          child: Consumer<GetChanges>(
                              builder: (BuildContext context, value, win) {
                            return value.getCodeSentSemaphore() == true
                                ? Wrap(
                                    alignment: WrapAlignment.end,
                                    children: [
                                      TF.inst(context, text: TS.svp3),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.black87),
                                          child: value.getCodeSentSemaphore() ==
                                                  true
                                              ? Text(
                                                  '${value.time}',
                                                  style:
                                                      TU.tesmall(context, 56),
                                                )
                                              : Text(
                                                  '30',
                                                  style:
                                                      TU.tesmall(context, 56),
                                                )),
                                      TF.inst(context, text: TS.seconds)
                                    ],
                                  )
                                : Text('');
                          }),
                        ),
                        Container(height: 40),
                        Align(
                          alignment: Alignment.center,
                          child: TF.inst(context, text: TS.inst3),
                        ),
                        Container(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: TU.getw(context) / 2,
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white12),
                          child: Consumer<GetChanges>(
                              builder: (BuildContext context, value, win) {
                            bool flag =
                                value.codeSentSemaphore == true ? false : true;
                            return TextFormField(
                              enabled: flag,
                              controller: nCon,
                              style: TU.tesmall(context, 44),  
                              showCursor:false,                         
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: TS.numHint,
                                  hintStyle: TU.tesmall(context, 54)),
                            );
                          }),
                        ),
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: TU.getw(context) / 4,
                    child: Consumer<GetChanges>(
                        builder: (BuildContext context, value, win) {
                      return value.getUpdateTime() == 0
                          ? TF.getTField2(context,
                              con: sCon, htext: TS.smsCodeHint)
                          : Container();
                    }),
                  )
                ],
              ),
            ),
            Consumer<GetChanges>(builder: (BuildContext context, changes, win) {
              return changes.loadingIndicator == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue[800],
                      ),
                    )
                  : Container();
            })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nCon.dispose();
    sCon.dispose();
    timer.cancel();
  }
}
