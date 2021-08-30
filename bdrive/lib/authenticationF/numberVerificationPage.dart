import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberVerificationPage extends StatefulWidget {
  const NumberVerificationPage({Key? key}) : super(key: key);

  @override
  _NumberVerificationPageState createState() => _NumberVerificationPageState();
}

class _NumberVerificationPageState extends State<NumberVerificationPage> {
  TextEditingController numC = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                    width: TU.getw(context) / 2,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: TextFormField(
                      controller: numC,
                      autofocus: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                      cursorColor: Colors.white,
                      cursorWidth: 2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Enter your number',
                          hintStyle: TU.tlarge(context)),
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
                    var text = numC.text.trim();
                    if (text.isEmpty) {
                      SB.ssb(context,
                          text: "You haven't entered your number yet");
                    } else if (text.length < 10 || text.length > 10) {
                      SB.ssb(context, text: 'Enter a 10 digit number');
                    } else {
                      SB.sdb(context, () {
                        SB.cpi(context);
                        FirebaseFunctions.verifyNumber(context, '+91$text');
                      }, () {},
                          dialog: 'Are you sure about your number\n\n$text');
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
          height: 40,
        )
      ],
    );
    return WillPopScope(
      onWillPop: () {
        Future.delayed(Duration(milliseconds: 800), () {
          SystemNavigator.pop();
        });
        return Future.value(true);
      },
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
          body: Container(
            child: Stack(
              children: [
                Container(
                  width: TU.geth(context),
                  color: Color(0xFFF2F2F2),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        margin: EdgeInsets.all(20),
                        elevation: 20,
                        shadowColor: Colors.blue,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          width: TU.getw(context) * 0.7,
                          height: TU.getw(context) * 0.8,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                              top: 10, left: 0, right: 10, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      TS.nvp,
                                      style: TU.telarge(context),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      TS.nvp1,
                                      style: TU.tesmall(context),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      TS.nvp2,
                                      style: TU.tsmall(context),
                                    ),
                                  ],
                                ),
                              )
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
      ),
    );
  }

  @override
  void dispose() {
    numC.dispose();
    super.dispose();
  }
}
