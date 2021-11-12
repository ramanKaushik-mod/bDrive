import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DetailOfFolder extends StatefulWidget {
  final String docID;
  final HandlingFS handlingFS;
  const DetailOfFolder(
      {Key? key, required this.docID, required this.handlingFS})
      : super(key: key);

  @override
  _DetailOfFolderState createState() => _DetailOfFolderState();
}

class _DetailOfFolderState extends State<DetailOfFolder> {
  CU cu = CU();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: widget.handlingFS.getFolderDetails(docID: widget.docID),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> map = snapshot.data as Map<String, dynamic>;
              return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) => [
                            SliverAppBar(
                              toolbarHeight: 50,
                              backgroundColor: Colors.white10,
                              leading: IU.iwc(
                                  icon: Icons.arrow_back_ios_new_outlined,
                                  callback: () {
                                    Navigator.pop(context);
                                  },
                                  size: 24),
                              title: Text(
                                map['fName'].toString().toLowerCase(),
                                style: TU.tesmall(context, 36),
                              ),
                            )
                          ],
                  body: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.black,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        getTItle(text: "Folder Details"),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 0,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19.8),
                                  color: Colors.white10),
                              child: Row(
                                children: [
                                  Container(
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets\\bDrive.png',
                                          height: 110,
                                          width: 110,
                                        ),
                                        Icon(
                                          Icons.folder_outlined,
                                          color: Colors.white70,
                                          size: 60,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          detailOfFolder(
                                              label: 'name',
                                              detail: map['fName']),
                                          detailOfFolder(
                                              label: 'created on',
                                              detail: map['createdAt']
                                                  .split(' ')[0]),
                                          detailOfFolder(
                                              label: 'sub folders',
                                              detail: map['folderList']
                                                  .length
                                                  .toString()),
                                          detailOfFolder(
                                              label: 'files',
                                              detail: map['fileList']
                                                  .length
                                                  .toString()),
                                          detailOfFolder(
                                              label: 'location',
                                              detail: Provider.of<GetChanges>(
                                                      context,
                                                      listen: false)
                                                  .getPathList()
                                                  .last[1]
                                                  .toLowerCase()
                                                  .toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ]),
                    ),
                  ));
            }
            return Container();
          }),
    );
  }

  detailOfFolder({required String label, required String detail}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TU.cat(context, text: label, factor: 60)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: TU.cat(context, text: detail, factor: 60)
          ),
        ],
      );
 getTItle({required String text}) => Row(children: [
        TU.tuDw(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TU.cat(context, text: text, factor: 42),
        ),
      ]);
}

class DetailOfFile extends StatefulWidget {
  final String parentDocID;
  final String dan;
  final HandlingFS handlingFS;
  const DetailOfFile(
      {Key? key,
      required this.parentDocID,
      required this.handlingFS,
      required this.dan})
      : super(key: key);

  @override
  _DetailOfFileState createState() => _DetailOfFileState();
}

class _DetailOfFileState extends State<DetailOfFile> {
  CU cu = CU();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cu.accent,
      body: FutureBuilder(
          future: widget.handlingFS.getFileDetails(
            dan: widget.dan,
            parentDocID: widget.parentDocID,
          ),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> map = snapshot.data as Map<String, dynamic>;
              return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) => [
                            SliverAppBar(
                              toolbarHeight: 50,
                              backgroundColor: Colors.white10,
                              leading: IU.iwc(
                                  icon: Icons.arrow_back_ios_new_outlined,
                                  callback: () {
                                    Navigator.pop(context);
                                  },
                                  size: 24),
                              title: Text(
                                map['fileName'].toString().toLowerCase(),
                                style: TU.tesmall(context, 36),
                              ),
                            )
                          ],
                  body: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.black,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        getTItle(text: 'File Details'),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 0,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19.8),
                                color: Colors.white10),
                            child: Row(
                              children: [
                                Container(
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets\\bDrive.png',
                                        height: 110,
                                        width: 110,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.file,
                                        color: Colors.white70,
                                        size: 50,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    children: [
                                      detailOfile(
                                          label: 'uploaded at',
                                          detail:
                                              map['uploadTime'].split(' ')[0]),
                                      detailOfile(
                                          label: 'type',
                                          detail: map['fileName']
                                              .split('.')
                                              .last
                                              .toUpperCase()),
                                      detailOfile(
                                          label: 'location',
                                          detail: map['path']),
                                      detailOfile(
                                          label: 'size',
                                          detail:
                                              map['size'].toStringAsFixed(2) +
                                                  ' mb'),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ));
            }
            return Container();
          }),
    );
  }

  detailOfile({required String label, required String detail}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: TU.cat(context, text: label, factor: 60)),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: TU.cat(context, text: detail, factor: 60)),
        ],
      );

  getTItle({required String text}) => Row(children: [
        TU.tuDw(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TU.cat(context, text: text, factor: 42),
        ),
      ]);
}
