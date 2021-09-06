import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Image imageFromPreferences;
  TextEditingController nCon = TextEditingController();
  TextEditingController uNCon = TextEditingController();
  TextEditingController eCon = TextEditingController();
  TextEditingController pCon = TextEditingController();

  int toggle = 0;
  late String dialogCode;
  late HandlingFS handlingFirebaseDB;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB = HandlingFS(contactID: await Utility.getUserContact());
    bool check = await handlingFirebaseDB.cue();
    if (check) {
      Users user = await Utility.getUserDetails();
      nCon.text = user.uName;
      uNCon.text = user.uNName;
      eCon.text = user.uEmail;
      pCon.text = user.upasscode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Utility.exitApp(context);
        return Future<bool>.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.blue[600],
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.black26,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 0, left: 20, right: 10, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: Colors.black,
                      ),
                      height: TU.geth(context) / 2,
                      width: TU.getw(context),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Text(
                                TS.firstTime,
                                style: TU.tlarge(context, 44),
                              )),
                              Stack(
                                children: [
                                  Image.asset(
                                    'assets\\bDrive.png',
                                    height: TU.geth(context) / 5.5,
                                    width: TU.geth(context) / 5.5,
                                  ),
                                  Image.asset(
                                    'assets\\bDrive.png',
                                    height: TU.geth(context) / 8,
                                    width: TU.geth(context) / 8,
                                    color: Colors.yellow,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TF.inst(context, text: TS.inst1),
                          TF.inst(context, text: TS.inst2),
                          TF.inst(context, text: TS.inst3)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Consumer<GetChanges>(
                            builder: (BuildContext context, value, win) {
                          return value.tellImageExist() != true
                              ? InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/imc');
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: IU.dicon(
                                          icon: Icons.person,
                                          callback: () {},
                                          size: 30,
                                          cSize: 30,
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 1,
                                          right: 0.8,
                                          child: IU.dicon(
                                              icon: Icons.edit,
                                              callback: () {
                                    Navigator.pushNamed(context, '/imc');},
                                              size: 16,
                                              cSize: 16)),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.only(right: 15),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 29.5,
                                      backgroundColor: Colors.black,
                                      child: value.getUserImage(),
                                    ),
                                  ),
                                );
                        }),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black26),
                            child: TextFormField(
                              controller: nCon,
                              style: TU.tlarge(context, 44),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: TS.pyourName,
                                  hintStyle: TU.tesmall(context, 54)),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TF.getTField(context, con: uNCon, htext: TS.puserName),
                    SizedBox(
                      height: 25,
                    ),
                    TF.getTField(context, con: eCon, htext: TS.pemailId),
                    SizedBox(
                      height: 25,
                    ),
                    TF.getTField(context, con: pCon, htext: TS.ppcode),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          splashColor: Colors.blue,
          onPressed: () async {
            Users user = Users(
                uName: nCon.text.trim(),
                uNName: uNCon.text.trim(),
                uEmail: eCon.text.trim(),
                upasscode: pCon.text.trim(),
                uimgString: await Utility.getImageFromPreferences(),
                uJoin: DateTime.now().toString(),
                contactId: await Utility.getUserContact());
            await handlingFirebaseDB.setUserDetails(user: user);
            // print("function is called");
            // Map<String, dynamic> map =
            //     await handlingFirebaseDB.getUserDetails();
            // user = Users.fromJson(map);
            // print('print json ${user.toJson()}');
          },
          child: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
