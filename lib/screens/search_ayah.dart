import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/screens/searchingIcon.dart';

class dataSearch extends SearchDelegate<String> {
  List _items = [];

  @override
  TextStyle? get searchFieldStyle => TextStyle(
        fontSize: 20,
        fontFamily: 'Hafs',
      );

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/hafs_smart_v8.json');
    final data = await json.decode(response);
    _items = data["sura"];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: const Color(0xffeab676),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.brown[700]!,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(13),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.brown[700],
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        color: Colors.brown[700],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final result = _items
        .where((element) => element['aya_text_emlaey']
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    if (result.length == 0) {
      return const Center(
        child: Text(
          "لم يتم العثور على الآية",
          style: TextStyle(fontFamily: 'Kitab'),
        ),
      );
    } else {
      return Container(
        color: const Color(0xffeab676),
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: result.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => searhingIcon(
                          num_page: result.elementAt(index)["page"])),
                );
              },
              title: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  color: Colors.grey.withOpacity(.2),
                  child: Column(
                    children: [
                      Text(
                        result.elementAt(index)['aya_text'],
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Hafs',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              'سورة :  ${result.elementAt(index)['sura_name_ar']}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Hafs',
                              ),
                            ),
                            Text(
                              'الجزء :  ${result.elementAt(index)['jozz']}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Hafs',
                              ),
                            ),
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.brown.withOpacity(.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            );
          },
        ),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    readJson();
    final suggestionList = query.isEmpty
        ? _items
        : _items
            .where((element) => element['aya_text_emlaey']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
    return Container(
      color: const Color(0xffeab676),
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => searhingIcon(
                        num_page: suggestionList.elementAt(index)["page"])),
              );
            },
            title: Container(
              margin: EdgeInsets.only(bottom: 20),
              color: Colors.grey.withOpacity(.2),
              child: Text(
                suggestionList[index]['aya_text'],
                style: const TextStyle(
                  fontFamily: 'Hafs',
                  color: Colors.black,
                  fontSize: 20,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        },
      ),
    );
  }
}
