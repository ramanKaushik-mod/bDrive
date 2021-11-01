import 'package:bdrive/models/models.dart';
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
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              toolbarHeight: 70,
              backgroundColor: Colors.black38,
              leadingWidth: 76,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue[800],
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Settings',
                style: TU.teeesmall(context, 32),
              ),
            )
          ];
        },
        body: Container(
          color: Colors.black45,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: userProfile(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
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
        height: 10,
      ),
      Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19.8), color: Colors.black38),
          margin: EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.7),
          child:
              Consumer<GetChanges>(builder: (BuildContext context, value, win) {
            Users user = value.getUser();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    radius: TU.getw(context) / 9,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: TU.getw(context) / 9.2,
                      backgroundColor: Colors.black26,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: value.getUserImage(),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTextWidget(user.uName),
                      getTextWidget(user.uNName),
                      getTextWidget(user.uEmail),
                      getTextWidget(user.contactId),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IU.diconl(
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
                )
              ],
            );
          }),
        ),
      ),
    ]);
  }

  getTextWidget(String text) => Wrap(
        direction: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
                text: TextSpan(text: text, style: TU.teesmall(context)),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );

  getTItle({required String text}) => Row(children: [
        TU.tuDw(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text, style: TU.tesmall(context, 38)),
        ),
      ]);

  otherDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTItle(text: 'Cloud State'),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19.8),
                  color: Colors.black38),
              margin: EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.7),
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
                                      top: 20.0,
                                      left: 10,
                                      right: 10,
                                      bottom: 10),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: (2.3) * ((1024 * 100) / 1024),
                                        color: Colors.blue[800],
                                      ),
                                      Container(
                                        height: 5,
                                        width:
                                            (2.3) * ((user.space * 100) / 1024),
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${((user.space * 100) / 1024).toStringAsFixed(2)} %',
                                    style: TU.teesmall(context),
                                  ),
                                )
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
          ),
        ],
      );

  getCloudDetailW({required String label, required dynamic info}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
                text: TextSpan(text: label, style: TU.teesmall(context)),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: RichText(
                text: TextSpan(
                    text: info.toString(), style: TU.teesmall(context)),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
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
            child: RichText(
                text: TextSpan(text: label, style: TU.teesmall(context)),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          IU.diconl(icon: icon, callback: func, size: 20)
        ],
      );
}
