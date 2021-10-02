

import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController con = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        color: Colors.white12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Row(
              children:[
                
                Expanded(
                  child: Hero(
                    tag: 'searchbox',
                    child: Card(
                      margin:
                          EdgeInsets.only(left: 30, right: 10, top: 5, bottom: 5),
                      color: Colors.black38,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 20, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white24),
                            child: TextFormField(
                                controller: con,
                                style: TU.tesmall(context, 44),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search bCLOUD',
                    hintStyle: TU.tesmall(context, 44)),
                              ),
                      ),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(left:10.0, right: 30),
                  child: Hero(
                    tag: 'seap',
                    child: Icon(Icons.search, color:Colors.red,size: 28,),
                  ),
                ),
                
              ]
            ),
            
        SizedBox(height: 10),
        TU.tuD(context),
        SizedBox(height: 10),
        Expanded(child: Container(color: Colors.black38)),
          ],
        ),
      ),
    );
  }
}