import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
      await Provider.of<GetChanges>(context, listen: false).updateUserImage();
      await Provider.of<GetChanges>(context, listen: false).updateImageExists();

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
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 10, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: Colors.black38,
                      ),
                      width: TU.getw(context),
                      child: Wrap(
                        runAlignment: WrapAlignment.end,
                        alignment: WrapAlignment.end,
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
                                  Image.asset('assets\\bDrive.png',
                                      height: TU.geth(context) / 8,
                                      width: TU.geth(context) / 8,
                                      color: Colors.white60),
                                ],
                              ),
                            ],
                          ),
                          Container(height: 20,),
                          TF.instl(context, text: TS.inst1, fSize: 54),
                          Container(height: 50),
                          TF.instl(context, text: TS.inst2, fSize: 54),
                          Container(height: 60),
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
                              ? Stack(
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
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/imc');
                                          },
                                          child: IU.dicon(
                                              icon: Icons.edit,
                                              callback: () {
                                                Navigator.pushNamed(
                                                    context, '/imc');
                                              },
                                              size: 16,
                                              cSize: 16),
                                        )),
                                  ],
                                )
                              : InkResponse(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/imc');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    padding: EdgeInsets.only(right: 15),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blue[900],
                                      child: CircleAvatar(
                                        radius: 29,
                                        backgroundColor: Colors.black,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: value.getUserImage(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        }),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white12),
                            child: TextFormField(
                              controller: nCon,
                              style: TU.tesmall(context, 50),
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
                      height: 20,
                    ),
                    TF.getTField(context, con: eCon, htext: TS.pemailId),
                    SizedBox(
                      height: 20,
                    ),
                    TF.getTField(context, con: pCon, htext: TS.ppcode),
                  ],
                ),
              ),
              Consumer<GetChanges>(
                  builder: (BuildContext context, changes, win) {
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
        floatingActionButton: InkResponse(
          onTap: () async {
            final str = await Utility.getImageFromPreferences();
            if (str.length < 4) {
              SB.ssb(context, text: 'select an image as your profile pic');
              return;
            } else if (pCon.text.trim().length < 8) {
              SB.ssb(context, text: "enter a valid passcode");
              return;
            } else if (eCon.text.trim().isEmpty) {
              SB.ssb(context, text: "enter a valid email");
              return;
            } else if (uNCon.text.trim().length < 3) {
              SB.ssb(context, text: "enter a valid username");
              return;
            } else if (uNCon.text.trim().length < 3) {
              SB.ssb(context, text: "enter a valid nick-name");
              return;
            }
            if (!await CIC.checkConnectivity(context)) {
              return;
            }
            await Provider.of<GetChanges>(context, listen: false)
                .updateLoadingIndicatorStatus(flag: true);
            bool check = await handlingFirebaseDB.cue();
            if (!check) {
              Users user = Users(
                  uName: nCon.text.trim(),
                  uNName: uNCon.text.trim(),
                  uEmail: eCon.text.trim(),
                  upasscode: pCon.text.trim(),
                  uimgString: await Utility.getImageFromPreferences(),
                  uJoin: DateTime.now().toString(),
                  contactId: await Utility.getUserContact(),
                  homeUid: handlingFirebaseDB.getHomeCollection().doc().id,
                  recentId: handlingFirebaseDB.getRecentCollection().doc().id,
                  starId: handlingFirebaseDB.getStarCollection().doc().id,
                  nFiles: 0,
                  nFolders: 0,
                  searchId: handlingFirebaseDB.getHomeCollection().doc().id,
                  space: 0.0);
              await handlingFirebaseDB.setUserDetails(user: user);
              await Utility.setUserDetails(map: user.toJson());
              await handlingFirebaseDB.setUserHomeFolder(
                  home: Folder(
                      docUid: user.homeUid,
                      fName: 'Home',
                      createdAt: user.uJoin,
                      folderList: [],
                      fileList: [],
                      star: false));
            } else {
              Map<String, dynamic> map = {
                'uName': nCon.text.trim(),
                'uNName': uNCon.text.trim(),
                'uEmail': eCon.text.trim(),
                'upasscode': pCon.text.trim(),
                'uimgString': await Utility.getImageFromPreferences()
              };

              await handlingFirebaseDB.updatteSubSetInfo(map: map);
              await Utility.setSubSetInfo(
                  email: map['uEmail'],
                  uName: map["uName"],
                  uNName: map["uNName"],
                  passcode: map['upasscode']);
            }
            await Utility.setProfileStatus(true);
            await Provider.of<GetChanges>(context, listen: false)
                .updateLoadingIndicatorStatus(flag: false);
            Phoenix.rebirth(context);
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
            child: Icon(Icons.arrow_forward_ios, color: Colors.white))),
        ),
      ),
    );
  }
}
