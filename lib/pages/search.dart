import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/common_state.dart';

import '../models/custome_models.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late CommonState commonState;
  SearchResluts? searchResluts;
  final TextEditingController _controller = TextEditingController();
  Timer? treshold;
  int doCallIn = 0;
  final LocalStorage storage = LocalStorage('search');
  @override
  Widget build(BuildContext context) {
    CommonState commonState = Provider.of<CommonState>(context);
    doSearch(String q) async {
      var temp = await commonState.locationSearch(q);
      setState(() {
        searchResluts = temp;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          commonState.currentPage = CurrentPage.home;
                        });
                      },
                      icon: const Icon(Icons.arrow_back)),
                  Expanded(
                      child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration.collapsed(hintText: "Search"),
                    onChanged: (String val) {
                      setState(() {
                        searchResluts = null;
                      });
                      if (treshold != null) treshold!.cancel();
                      treshold = Timer(const Duration(milliseconds: 500),
                          () => doSearch(val));
                    },
                    autocorrect: true,
                    onEditingComplete: () {
                      doSearch(_controller.text);
                    },
                  )),
                  IconButton(
                      onPressed: () {
                        doSearch(_controller.text);
                      },
                      icon: const Icon(Icons.search)),
                ],
              ),
              () {
                if (_controller.text.isEmpty) {
                  return const Text("Please Type to Search");
                }

                if (searchResluts != null &&
                    searchResluts!.query != null &&
                    searchResluts!.features!.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: searchResluts!.features!
                        .map((e) => InkWell(
                            onTap: () async {
                              await storage.ready.then((value) {
                                if (value) {
                                  storage.setItem(
                                      "lastSearch",
                                      json.encode(Location(
                                        lat: e.center![1],
                                        lon: e.center![0],
                                        name: e.text,
                                        secondaryName: e.placeName!
                                            .split(',')
                                            .skip(1)
                                            .join(','),
                                      ).toJson()));
                                  setState(() {
                                    commonState.selectedLoc = Location(
                                      lat: e.center![1],
                                      lon: e.center![0],
                                      name: e.text,
                                      secondaryName: e.placeName!
                                          .split(',')
                                          .skip(1)
                                          .join(','),
                                    );
                                    commonState.currentPage = CurrentPage.home;
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30, top: 20),
                              child: Text(" ${e.placeName}"),
                            )))
                        .toList(),
                  );
                } else {
                  return const Text("No resluts found");
                }
              }()
            ],
          ),
        ),
      ),
    );
  }
}
