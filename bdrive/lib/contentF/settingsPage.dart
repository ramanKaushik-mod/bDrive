import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      backgroundColor: Colors.black87,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              toolbarHeight: 70,
              backgroundColor: Colors.white12,
              leadingWidth: 76,
              leading: Hero(
                tag: 'settingspage',
                child: Icon(
                  Icons.settings,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              title: Text(
                'Settings',
                style: TU.teeesmall(context, 32),
              ),
            )
          ];
        },
        body: Container(
          color: Colors.white10,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Padding(padding: EdgeInsets.all(8),child: userProfile(),)],
            ),
          ),
        ),
      ),
    );
  }

  userProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: Text('User Profile', style:TU.tesmall(context, 38)),
        ),
        SizedBox(height: 10,),
        Card(
        elevation: 0,
        color: Colors.white54,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(19.8),
          color: Colors.black),
          margin: EdgeInsets.symmetric(horizontal:0.5, vertical: 0.7),
          child: Consumer<GetChanges>(builder: (BuildContext context, value, win) {
            Users user = value.getUser();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'settingPage',
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      radius: TU.getw(context) / 9,
                      backgroundColor: Colors.red,
                      child: CircleAvatar(
                        radius: TU.getw(context) / 9.2,
                        backgroundColor: Colors.black,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: value.getUserImage(),
                        ),
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
                        child: IU.diconl(icon: Icons.edit, callback: (){}, size: 20),
                      )
                      
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),]
    );
  }

  getTextWidget(String text) => Wrap(
        direction: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
                text: TextSpan(text: text, style: TU.teeesmall(context, 66)),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Divider(
                color: Colors.white,
                height: .2,
              ),
            ],
          )
        ],
      );
}
