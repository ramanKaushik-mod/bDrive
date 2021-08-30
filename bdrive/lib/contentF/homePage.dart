import 'package:bdrive/contentF/drawerPage.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 90,
        leading: Builder(
            builder: (context) => InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets\\bDrive.png',
                          height: 60,
                          width: 60,
                        ),
                        Image.asset(
                          'assets\\bDrive.png',
                          height: 30,
                          width: 30,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Scaffold.of(context).openDrawer(),
                )),
      ),
      drawer: DrawerPage(),
      bottomSheet: BottomSheet(
        elevation: 20,
        onClosing: () {},
        enableDrag: false,
        builder: (BuildContext con) => Container(
          color: Colors.white,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IU.ditask(
                  icon: Icons.create_new_folder_outlined,
                  callback: () {},
                  size: 28),
              IU.ditask(icon: Icons.upload_outlined, callback: () {}, size: 28),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
          ),
          Expanded(child: Container(color: Color(0xFFF2F2F2),)),
        ],
      ),
    );
  }
}
