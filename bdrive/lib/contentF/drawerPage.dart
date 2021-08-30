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
    return Drawer(
      child: Container(
        child: Row(
          children: [
            Container(
                width: 80,
                color: Color(0xFFF2F2F2),
                padding: EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 4,
                        ),
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
                                  callback: () {},
                                  size: 25),
                              IU.dicon(
                                  icon: Icons.star_border_purple500_outlined,
                                  callback: () {},
                                  size: 25),
                              IU.dicon(
                                  icon: Icons.offline_pin_outlined,
                                  callback: () {},
                                  size: 25),
                              IU.dicon(
                                  icon: Icons.share_outlined,
                                  callback: () {},
                                  size: 25),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IU.diconl(
                              icon: Icons.bubble_chart,
                              callback: () {},
                              size: 28),
                          TU.tuD(),
                          IU.diconl(
                              icon: Icons.settings_outlined,
                              callback: () {
                                Timer(Duration(microseconds: 10), () {
                                  
                                  Navigator.pushNamed(context, '/sep');
                                });
                                Navigator.pop(context);
                              },
                              size: 28),
                        ],
                      ),
                    )
                  ],
                )),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.yellow,
                          child: Container(
                            height: 40,
                            // child: Text("Cloud", style: TU.tTitle(context),),
                          ),
                        ),
                      ),
                      TU.tuD(),
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
                      TU.tuD(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User Details",
                              style: TU.tsmall(context),
                            ),
                            TU.tuD(),
                            Text(
                              "User Details",
                              style: TU.tsmall(context),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
