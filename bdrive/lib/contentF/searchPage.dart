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
    var card = Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: cu.be,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: cu.cwhite),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              color: cu.b,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: cu.cwhite,
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
            Card(
              elevation: 10,
              color: cu.b,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: cu.cwhite,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: IU.ditask(
                      icon: Icons.manage_search,
                      callback: () {
                        gChanges.setFocus();
                      },
                      size: 24)),
            ),
          ],
        ),
      ),
    );
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
        backgroundColor: cu.be,
        body: Container(
          color: cu.cwhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: 'searchbox',
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            color: cu.c4black,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: cu.be),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: cu.cwhite),
                                child: Consumer<GetChanges>(builder:
                                    (BuildContext context, changes, win) {
                                  return TextFormField(
                                    focusNode: changes.focusNode,
                                    controller: con,
                                    style: TU.tesmall(context, 44),
                                    showCursor: false,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(top: 14),
                                        prefixIcon: IU.iwoc(
                                            icon: Icons.search, size: 28),
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
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Consumer<GetChanges>(
                          builder: (BuildContext context, changes, win) {
                        return changes.getLoadingIndicatorStatus() == true
                            ? Tooltip(
                                message:
                                    'loading file \npress back button to stop',
                                padding: EdgeInsets.all(3),
                                child: Wrap(
                                  runAlignment: WrapAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      height: 28,
                                      width: 28,
                                      child: Transform.scale(
                                        scale: 0.4,
                                        child: CircularProgressIndicator(
                                          color: Colors.white70,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white60),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container();
                      })
                    ]),
              ),
              SizedBox(height: 5),
              TU.tuD(context),
              SizedBox(height: 9),
              Expanded(
                  child: Container(
                color: cu.t,
                child: Consumer<GetChanges>(
                    builder: (BuildContext context, changes, win) {
                  return changes.getWList().length > 0
                      ? SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(children: changes.getWList()))
                      : Container();
                }),
              )),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: card,
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
