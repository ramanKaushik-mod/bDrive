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
  CU cu = CU();
  TextEditingController nCon = TextEditingController();
  TextEditingController sCon = TextEditingController();
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    var container = Column(
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
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cu.cwhite),
                child: Consumer<GetChanges>(
                    builder: (BuildContext context, value, win) {
                  bool flag = value.codeSentSemaphore == true ? false : true;
                  return TextFormField(
                    enabled: flag,
                    controller: nCon,
                    style: TU.tesmall(context, 44),
                    showCursor: false,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        hintText: TS.numHint,
                        hintStyle: TU.tesmall(context, 54)),
                  );
                }),
              ),
            )
          ]),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          alignment: Alignment.center,
          width: TU.getw(context) / 4,
          child:
              Consumer<GetChanges>(builder: (BuildContext context, value, win) {
            return value.getUpdateTime() == 0
                ? TF.getTField2(context, con: sCon, htext: TS.smsCodeHint)
                : Container();
          }),
        )
      ],
    );

    var card = Card(
      color: Colors.white10,
      margin: EdgeInsets.symmetric(horizontal: 20),
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white10),
                              child: value.getCodeSentSemaphore() == true
                                  ? Text(
                                      '${value.time}',
                                      style: TU.tesmall(context, 56),
                                    )
                                  : Text(
                                      '30',
                                      style: TU.tesmall(context, 56),
                                    )),
                          TF.inst(context, text: TS.seconds)
                        ],
                      )
                    : Text('');
              }),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        child: BU.btDialogDUIB(icon: Icons.arrow_forward_ios_outlined, size: 20),
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            container,
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 50,
                    ),
                    card
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: TF.inst(context, text: TS.inst3),
            ),
            Container(
              height: 70,
            )
          ],
        ),
        Consumer<GetChanges>(builder: (BuildContext context, changes, win) {
          return changes.loadingIndicator == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: cu.w,
                  ),
                )
              : Container();
        })
      ]),
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
