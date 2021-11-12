import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final HandlingFS handlingFS;
  const SearchPage({Key? key, required this.handlingFS}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static CU cu = CU();
  TextEditingController con = TextEditingController();
  late GetChanges gChanges;
  @override
  void initState() {
    super.initState();
    gChanges = Provider.of<GetChanges>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (gChanges.getLoadingIndicatorStatus() == true) {
          gChanges.updateLoadingIndicatorStatus(flag: false);
          return Future.value(false);
        }
        if (gChanges.getWList().length != 0) {
          gChanges.updateWList(list: []);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: cu.accent,
        body: Container(
          color: cu.cwhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                    child: Hero(
                      tag: 'searchbox',
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        color: cu.cwhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: cu.cblack),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: cu.cwhite),
                            child: TextFormField(
                              controller: con,
                              style: TU.tesmall(context, 44),
                              showCursor: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: IU.iwoc(icon: Icons.search, size: 28),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: 'Search bCLOUD',
                                  hintStyle: TU.tesmall(context, 48)),
                              onChanged: (query) {
                                if (query.trim().isNotEmpty) {
                                  searchInList(query: query);
                                } else {
                                  gChanges.updateWList(list: []);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                ]),
              ),
              SizedBox(height: 10),
              TU.tuD(context),
              SizedBox(height: 14),
              Expanded(
                  child: Container(
                color: Colors.black38,
                child: Consumer<GetChanges>(
                    builder: (BuildContext context, changes, win) {
                  return changes.getWList().length > 0 ?SingleChildScrollView(
                      child: Container(
                        margin:EdgeInsets.only(top:3),
                        child: Column(children: changes.getWList()))):Container();
                }),
              )),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Card(
          color: cu.c2white,
          shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black45,
              ),
              padding: const EdgeInsets.all(3),
              child: IU.ditask(
                  icon: Icons.close,
                  callback: () {
                    if (con.text.trim().length == 0) {
                      gChanges.updateWList(list: []);
                      con.text = '';
                      Navigator.pop(context);
                    } else {
                      gChanges.updateWList(list: []);
                      con.text = '';
                    }
                  },
                  size: 24)),
        ),
      ),
    );
  }

  searchInList({required String query}) async {
    gChanges.updateWList(
        list: Mapping.mapSFiles(
            list: gChanges.sList
                .where((element) => element.fileName
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList(),
            handlingFS: widget.handlingFS));
  }

  @override
  void dispose() {
    super.dispose();
    con.dispose();
  }
}
