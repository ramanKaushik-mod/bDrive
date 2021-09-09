import 'dart:async';

import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    var row = Expanded(
        child: Container(
            color: Colors.blue[600],
            child: Row(
              children: [
                Container(
                    width: 80,
                    color: Colors.black45,
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  'assets\\bDrive.png',
                                  height: 80,
                                  width: 80,
                                ),
                                Image.asset(
                                  'assets\\bDrive.png',
                                  height: 48,
                                  width: 48,
                                  color: Colors.yellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  IU.dicon(
                                      icon: Icons.home_outlined,
                                      callback: () async {
                                        
                                      },
                                      cSize: 26,
                                      size: 25),
                                  IU.dicon(
                                      icon:
                                          Icons.star_border_purple500_outlined,
                                      callback: () {
                                      },
                                      cSize: 26,
                                      size: 25),
                                  IU.dicon(
                                      icon: Icons.offline_pin_outlined,
                                      callback: () {},
                                      cSize: 26,
                                      size: 25),
                                  IU.dicon(
                                      icon: Icons.share_outlined,
                                      callback: () {},
                                      cSize: 26,
                                      size: 25),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                Expanded(
                  child: Container(
                      color: Colors.blue[600],
                      child: Container(
                        color: Colors.black38,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.black38,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 80,
                                    alignment: Alignment.bottomCenter,
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: Colors.blue[900],
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 40,
                                        width: 120,
                                        child: Center(
                                            child: Text(
                                          "bCLOUD",
                                          style: TU.tTitle(context),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(height: 20,),
                            // TU.tuD(),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(Icons.settings)),
                                    // IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(Icons.settings)),
                                    // IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(Icons.settings)),
                                    // IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(Icons.settings)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            )
                          ],
                        ),
                      )),
                ),
              ],
            )));
    return Drawer(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            row,
            Container(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              height: 80,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IU.diconl(
                          icon: Icons.bubble_chart, callback: () {}, size: 28),
                      TU.tuDw(),
                      IU.diconl(
                          icon: Icons.settings_outlined,
                          callback: () {
                            Timer(Duration(microseconds: 10), () {
                              Navigator.pushNamed(context, '/sep');
                            });
                            Navigator.pop(context);
                          },
                          size: 28)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue[600]),
                        child: Container(
                            height: 30,
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black38),
                            child: Center(
                                child: RichText(
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                  text: '@raman', style: TU.teesmall(context)),
                            ))),
                      ),
                      IU.dicon(
                          icon: Icons.person,
                          callback: () {},
                          cSize: 20,
                          size: 20),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
