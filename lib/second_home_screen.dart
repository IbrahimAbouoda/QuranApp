import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Aya.dart';

class SecondHomeScreen extends StatefulWidget {
  const SecondHomeScreen({Key? key}) : super(key: key);

  @override
  State<SecondHomeScreen> createState() => _SecondHomeScreenState();
}

class _SecondHomeScreenState extends State<SecondHomeScreen> {
  int pageNo = 1;
  int pageNo2 = 2;
  int jozoua = 1;
  String sourah = "البقرة";
  int index = 1;
  int id = 0;

  dynamic searchPageNo = 0;
  dynamic searchAyaNo = 0;

  late List allData;

  late PageController _controller;
  List<String> ayatOfPage = [];
  List<String> allSourahs = List.filled(604, '');
  String ayatOfPageClear = "";
  List<List<Aya>> allPages = List.filled(604, []);

  // late List<List<String>> allPages;
  List<List<String>> allPagesClear = List.filled(604, List.filled(300, ''));

  // List<List<String>> allPagesClear = [[]];

  late TextEditingController _controllerAya;

  List<TextSpan> myTextSpans = [];

  TextStyle textStyle =
      TextStyle(fontFamily: 'Hafs', fontSize: 24, color: Colors.black);
  Color? color = Colors.grey;

  void changeBackColor() {
    setState(() {
      color = color == Colors.grey ? null : Colors.grey;
      textStyle = TextStyle(
          fontFamily: 'Hafs',
          fontSize: 24,
          backgroundColor: color,
          color: Colors.black);
    });
  }

  late TapGestureRecognizer recognizer;

  Future<void> loadData() async {
    var data = await rootBundle.loadString("assets/hafs_smart_v8.json");
    allData = json.decode(data);
    allData.forEach((element) {
      if (element['page'] == pageNo) {
        allPages[(element['page'] - 1)]
            .add(Aya(text: element['aya_text'], ayaNo: element['id']));
        allSourahs[(element['page'] - 1)] = element['sura_name_ar'];
      }
      // allPagesClear[(element['page'] - 1)] += element['aya_text_emlaey'];
      // allPagesClear[(element['page'] - 1)][(element['aya_no'] - 1)] =
      //     element['aya_text_emlaey'];
    });
    makeTextSpan();
    setState(() {});
  }

  Future<void> makeTextSpan() async {
    myTextSpans = [];
    setState(() {});
    for (int i = 0; i < allPages[pageNo].length; i++) {
      print("i : $i , ${allPages[pageNo][i].ayaNo}");
      if (allPages[pageNo][i].ayaNo == id) {
        myTextSpans.add(
          TextSpan(
            style: textStyle.copyWith(backgroundColor: Colors.black12),
            text: allPages[pageNo][i].text,
          ),
        );
      } else {
        myTextSpans.add(
          TextSpan(
            style: textStyle,
            text: allPages[pageNo][i].text,
          ),
        );
      }
    }
    setState(() {});
  }

  Future<void> search({required String text}) async {
    myTextSpans = [];
    for (int i = 0; i < allData.length; i++) {
      if (allData[i]['aya_text_emlaey'].contains(text)) {
        searchAyaNo = allData[i]['aya_no'];
        searchPageNo = allData[i]['page'];
        id = allData[i]['id'];
        print("searchAyaNo $searchAyaNo");
        print("searchPageNo $searchPageNo");
        pageNo = searchPageNo;
        loadData();
        break;
      }
    }
    // allData.forEach((ayat) {
    //   if(ayat['aya_text_emlaey'].contains(text)){
    //     searchAyaNo = ayat['aya_no'];
    //     searchPageNo = ayat['page'];
    //   }
    // });
  }

  @override
  void initState() {
    loadData();
    _controller = PageController(initialPage: 0);
    _controllerAya = TextEditingController();
    recognizer = TapGestureRecognizer()..onTap = changeBackColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("myTextSpans.length) ${myTextSpans.length}");
    return Scaffold(
      backgroundColor: Color(0xfffbf2d6),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text("${(pageNo * 0.05).ceil()}"),
                Spacer(),
                Text("${allSourahs[pageNo - 1]}"),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      if (pageNo == value) {
                        allPages[pageNo + 1].clear();
                      } else {
                        allPages[pageNo - 1].clear();
                      }
                      pageNo = value + 1;
                      loadData();
                      myTextSpans = <TextSpan>[];
                    });
                  },
                  itemCount: allPages.length,
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: RichText(
                            textAlign: TextAlign.justify,
                            // selectionColor: Colors,
                            text: TextSpan(
                              mouseCursor: SystemMouseCursors.click,
                              style: textStyle,
                              children: myTextSpans,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (pageNo < 614) {
                        _controller.animateToPage(
                          pageNo + 1,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInBack,
                        );
                        ++pageNo;
                        myTextSpans = <TextSpan>[];
                        allPages[pageNo - 1].clear();
                        loadData();
                      }
                    });
                  },
                  child: Text("الصفحة التالية"),
                ),
                Spacer(),
                InkWell(
                  child: Text("$pageNo"),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _controllerAya,
                                  decoration: InputDecoration(
                                    hintText: "أدخل الآية",
                                    hintTextDirection: TextDirection.rtl,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    enabledBorder: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        int index = 0;
                                        allPages[pageNo].clear();
                                        search(text: _controllerAya.value.text);
                                        _controllerAya.clear();

                                      });
                                    },
                                    child: Text("بدأ البحث"),
                                  )),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (pageNo > 1) {
                        _controller.animateToPage(
                          pageNo - 1,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInBack,
                        );
                        --pageNo;
                        allPages[pageNo + 1].clear();
                        loadData();
                      }
                    });
                  },
                  child: Text("الصفحة السابقة"),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
