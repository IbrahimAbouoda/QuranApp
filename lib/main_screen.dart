import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int page = 1;
  int jozz = 1;
  String sourah = "البقرة";

  var ayat = "";

  late List allAyat;
  late List pageAyat;

  @override
  void initState() {
    super.initState();

    allAyat = [];
    pageAyat = [];
    loadData();
  }

  Future<String> loadData() async {
    var boolean = false;
    // ayat = "";
    var data = await rootBundle.loadString("assets/hafs_smart_v8.json");
    setState(() {
      allAyat = json.decode(data);
    });
    print("$data $allAyat");

    allAyat.forEach((element) {
      boolean = false;
      if (element["page"] == page) {
        boolean = true;
        // pageAyat.add(element['aya_text']);
        page = element['page'];
        ayat += element['aya_text'];
        jozz = element['jozz'];
        sourah = element['sura_name_ar'];
      }
    });

    return "success";
  }

  @override
  Widget build(BuildContext context) {
    print(allAyat[10]);
    // loadData();
    return Scaffold(
      backgroundColor: Color(0xfffbf2d6),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text("$jozz الجزء"),
                Spacer(),
                Text("$sourah"),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            SizedBox(
                child:
                    // Display the data loaded from sample.json
                    pageAyat.isNotEmpty
                        ? Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                ayat,
                                style:
                                    TextStyle(fontFamily: "Hafs", fontSize: 21),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          )
                        : Text("Data")),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (page <= 600) {
                        ayat = "";
                        ++page;
                        loadData();
                      };
                    });
                  },
                  child: Text("الصفحة التالية"),
                ),
                Spacer(),
                Text("$page"),
                Spacer(),
                TextButton(
                  onPressed: () {
                   setState(() {
                     if (page >= 2) {
                       ayat = "";
                       --page;
                       loadData();
                     };

                   });
                    // print("ffff , $catalogdata");
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
