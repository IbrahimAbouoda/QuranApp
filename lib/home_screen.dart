import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageNo = 1;
  int pageNo2 = 2;
  int jozoua = 1;
  String sourah = "البقرة";
  int index = 1;

  late List allData;

  late PageController _controller;
  List<String> ayatOfPage = [];
  List<String> allSourahs = List.filled(604, '');
  String ayatOfPageClear = "";
  List<String> allPages = List.filled(604, '');
  List<String> allPagesClear = List.filled(604, '');

  late TextEditingController controllerPage;
  late TextEditingController controllerJouza;
  late TextEditingController controllerAya;

  Future<void> loadData() async {
    var data = await rootBundle.loadString("assets/hafs_smart_v8.json");
    setState(() {
      allData = json.decode(data);
      allData.forEach((element) {
        allPages[(element['page']-1)] += element['aya_text'];
        allPagesClear[element['page']-1] += element['aya_text_emlaey'];
        allSourahs[(element['page']-1)] = element['sura_name_ar'];
      });
    });
  }



  @override
  void initState() {
    loadData();
    _controller = PageController(initialPage: 0);
    controllerPage = TextEditingController();
    controllerJouza = TextEditingController();
    controllerAya = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                Text("${allSourahs[pageNo-1]}"),
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
                  // physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return ListView(
                      children: [
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              allPages[index],
                              style: TextStyle(fontFamily: 'Hafs', fontSize: 24),
                              textAlign: TextAlign.justify,
                            )),
                      ],
                    );
                  },
                  onPageChanged: (value) {
                    setState(() {
                      pageNo = value+1;
                    });
                  },
                  itemCount: allPages.length,
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
                        // loadData();
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
                                  controller: controllerAya,
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
                                        allPagesClear.forEach((String element) {
                                          if (element.contains(
                                              controllerAya.value.text)) {
                                            print("yes");
                                            pageNo = index;
                                          }
                                          index++;
                                        });
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
                        // loadData();
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
