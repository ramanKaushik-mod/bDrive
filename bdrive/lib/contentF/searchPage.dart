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
        backgroundColor: Colors.black87,
        body: Container(
          color: Colors.white12,
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
                        margin: EdgeInsets.only(
                            left: 0, right: 10, top: 5, bottom: 5),
                        color: Colors.black26,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white24),
                          child: TextFormField(
                            controller: con,
                            style: TU.tesmall(context, 44),
                            showCursor: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 14),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.red,
                                ),
                                // contentPadding: EdgeInsets.only(top: 15),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: 'Search bCLOUD',
                                hintStyle: TU.tesmall(context, 55)),
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
                  Wrap(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white24,
                          ),
                          padding: const EdgeInsets.all(3),
                          child: IU.diconl(
                              icon: Icons.close,
                              callback: () {
                                gChanges.updateWList(list: []);
                                con.text = '';
                              },
                              size: 24)),
                    ],
                  ),
                ]),
              ),
              SizedBox(height: 10),
              TU.tuD(context),
              SizedBox(height: 10),
              Expanded(
                  child: Container(
                color: Colors.black38,
                child: Consumer<GetChanges>(
                    builder: (BuildContext context, changes, win) {
                  return SingleChildScrollView(
                      child: Column(children: changes.getWList()));
                }),
              )),
            ],
          ),
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
