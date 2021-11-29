import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  CU cu = CU();
  TextEditingController con = TextEditingController();
  @override
  void initState() {
    super.initState();
    updateUser();
  }

  updateUser() async {
    GetChanges change = Provider.of<GetChanges>(context, listen: false);
    change.updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cu.ac,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              toolbarHeight: 70,
              backgroundColor: cu.cwhite,
              leading: IU.iwc(
                  icon: Icons.arrow_back_ios_new_outlined,
                  callback: () {
                    Navigator.pop(context);
                  },
                  size: 24),
              title: Text(
                'Settings',
                style: TU.cAppText(context, 32),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            color: cu.accent,
            height: TU.geth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(14),
                  child: userProfile(),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: otherDetails(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  userProfile() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      getTItle(text: "User Profile"),
      SizedBox(
        height: 20,
      ),
      Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cu.cwhite,
        ),
        child:
            Consumer<GetChanges>(builder: (BuildContext context, value, win) {
          Users user = value.getUser();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TU.getw(context) / 9),
                  gradient: LinearGradient(colors: [
                    Colors.orange,
                    Colors.purple,
                    Colors.purple,
                    Colors.red
                  ]),
                ),
                padding: EdgeInsets.all(1),
                child: CircleAvatar(
                  radius: TU.getw(context) / 9.2,
                  backgroundColor: Colors.black,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: value.getUserImage(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTextWidget(user.uName),
                      getTextWidget(user.uNName),
                      getTextWidget(user.uEmail),
                      getTextWidget(user.contactId),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IU.iwcow(
                            icon: Icons.edit,
                            callback: () {
                              con.text = '';
                              SB.sdb(context, () async {
                                await Utility.setProfileStatus(false);
                                Phoenix.rebirth(context);
                              }, () {}, con, dialog: "your passcode");
                            },
                            size: 20),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    ]);
  }

  getTextWidget(String text) => Wrap(
        direction: Axis.vertical,
        children: [
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: TU.cat(context, text: text, factor: 66)),
        ],
      );

  getTItle({required String text}) => Row(children: [
        TU.tuDw(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TU.cat(context, text: text, factor: 42),
        ),
      ]);

  otherDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTItle(text: 'Cloud State'),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: cu.cwhite),
            child: Consumer<GetChanges>(
              builder: (BuildContext context, change, win) {
                Users user = change.getUser();
                return Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets\\bDrive.png',
                              height: 110,
                              width: 110,
                            ),
                            Image.asset(
                              'assets\\bDrive.png',
                              height: 70,
                              width: 70,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getCloudDetailW(
                                  info: user.uJoin.split(' ').first,
                                  label: 'Joined On'),
                              getCloudDetailW(
                                  info: user.nFiles, label: 'Files'),
                              getCloudDetailW(
                                  info: user.nFolders, label: 'Folders'),
                              getCloudDetailW(
                                  info: '${user.space.toStringAsFixed(2)} MB',
                                  label: 'Cloud Acquired'),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 10, right: 10, bottom: 10),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: (2.3) * ((1024 * 100) / 1024),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red[900],
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                      width: (2.3) *
                                          (((user.space > 0 ? user.space : 0) *
                                                  100) /
                                              1024),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: cu.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomRight,
                                  child: TU.cat(context,
                                      text:
                                          '${(((user.space > 0 ? user.space : 0) * 100) / 1024).toStringAsFixed(2)} %',
                                      factor: 60))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TU.tuDFBM(context, 1),
                  ),
                  getBL(
                      label: 'SignOut',
                      icon: Icons.logout_outlined,
                      func: () async {
                        await Utility.clearPreferences();
                        Phoenix.rebirth(context);
                      }),
                  getBL(
                      label: '',
                      icon: Icons.error_outline_outlined,
                      func: () {})
                ]);
              },
            ),
          ),
        ],
      );

  getCloudDetailW({required String label, required dynamic info}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: TU.cat(context, text: label, factor: 66)),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: TU.cat(context, text: info.toString(), factor: 66)),
        ],
      );

  getBL(
          {required String label,
          required IconData icon,
          required Function func}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: TU.cat(context, text: label, factor: 60)),
          IU.iwcow(icon: icon, callback: func, size: 20)
        ],
      );
}
