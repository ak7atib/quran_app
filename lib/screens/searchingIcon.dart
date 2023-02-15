import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class searhingIcon extends StatefulWidget {
  final int num_page;

  const searhingIcon({super.key, required this.num_page});

  @override
  _searhingIconState createState() {
    return _searhingIconState();
  }
}

class _searhingIconState extends State<searhingIcon> {
  List _items = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/hafs_smart_v8.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["sura"];
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100]!.withOpacity(.8),
      body: PageView.builder(
        reverse: true,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          if (_items.isNotEmpty) {
            String byPage = '';
            String surahName = '';
            int jozzNum = 0;
            bool isBasmalahShown = false;

            for (Map ayahData in _items) {
              if (ayahData['page'] == widget.num_page) {
                byPage = byPage + ' ${ayahData['aya_text']}';
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == widget.num_page) {
                surahName = ayahData['sura_name_ar'];
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == widget.num_page) {
                jozzNum = ayahData['jozz'];
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == widget.num_page) {
                if (ayahData['aya_no'] == 1 &&
                    ayahData['sura_name_ar'] != 'الفَاتِحة' &&
                    ayahData['sura_name_ar'] != 'التوبَة') {
                  isBasmalahShown = true;
                  break;
                }
              }
            }

            return SafeArea(
              child: Container(
                decoration: index % 2 == 0
                    ? const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                            Colors.black26,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.transparent
                          ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight))
                    : const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                            Colors.black26,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.transparent
                          ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الجزء $jozzNum',
                                style: const TextStyle(
                                    fontFamily: 'Kitab', fontSize: 20),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                surahName,
                                style: const TextStyle(
                                    fontFamily: 'Kitab', fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isBasmalahShown
                                  ? const Text(
                                      "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontFamily: 'Hafs', fontSize: 22),
                                      textAlign: TextAlign.center,
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                byPage,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    fontFamily: 'Hafs', fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${widget.num_page}',
                            style: const TextStyle(
                                fontFamily: 'Kitab', fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
