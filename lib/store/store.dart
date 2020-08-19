import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:literature/store/artifacts.dart';
import 'package:literature/store/rarity.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class Item {
  String tier;
  String value;
}

class _StoreState extends State<Store> {
  // This widget will update when someone searches for the item.
  Widget generatedItems = Text("Please wait...");
  // This needs to be updated once we make
  // network requests.
  double walletCurrency = 0.00;
  // Async network request to fetch account information.
  Future fetchAccountInformation() async {
    final response = await http.get('http://localhost:3000/wallet');
    if (response.statusCode == 200) {
      setState(() {
        walletCurrency = double.parse(response.body);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load the store. Check your network.');
    }
  }
  @override
  void initState() {
    fetchAccountInformation();
    super.initState();
  }

  var artifacts = [
    {
      "rarity": 'Diamond',
      "color": 'green',
      "chance": '5%'
    },
    {
      "rarity": 'Gold',
      "color": 'gold',
      "chance": '10%'
    },
    {
      "rarity": 'Silver',
      "color": 'silver',
      "chance": '25%'
    },
    {
      "rarity": 'Bronze',
      "color": 'bronze',
      "chance": '60%'
    }
  ];

  // Searches for a value within the
  // random number generator.
  int binarySearch(int rng, List arr) {
    int lo = 0;
    int hi = arr.length;
    while (lo < hi) {
      int mid = lo + (hi-lo)~/2;
      if (arr[mid] < rng) {
        lo = mid+1;
      } else hi = mid;
    }
    return lo;
  }

  String findItem(int index) {
    var selectedTier = store[index];
    final random = new Random();
    var i = random.nextInt(selectedTier[selectedTier.keys.first].length);
    return selectedTier[selectedTier.keys.first][i];
  }

  Map getItem() {
    List arr = [];
    int accum = 0;
    rarity.forEach((artifact) {
      accum = accum + artifact["rarity"];
      arr.add(accum);
    });
    Random rng = new Random();
    int randomNumeral = rng.nextInt(accum);
    int index = binarySearch(randomNumeral, arr);
    Map item = { "tier": rarity[index]["tier"], "index": index };
    return item;
  }

  void getGeneratedItems() {
    List items = new List();
    // assign to generatedItems
    for(var i=0; i<5; i++) {
      // break it down as findRarity
      // findItem into a composite class
      // such as Item.
      Map itemObj = getItem();
      var actualItem = findItem(itemObj["index"]);
      Item item = new Item();
      item.tier = itemObj["tier"];
      item.value = actualItem;
      items.add(item);
    }
    List<Widget> children = new List();
    for (var i=0; i < items.length; i++) {
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              items[i].value,
              style: TextStyle(
                // color: getColor(item["color"]),
                fontWeight: FontWeight.bold
              ),
            ),
            Expanded(
              child: Text(
                items[i].tier,
                style: TextStyle(
                  // color: getColor(item["color"]),
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ]
        )
      );
    }
    setState(() {
      generatedItems = Column(
        mainAxisSize: MainAxisSize.min,
        children: children
      );
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var appBar = GlobalAppBar();
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: 20.0,),
            _buildInfoExpansionPanel(),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "MEGA ARTIFACTS PACK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      height: 300,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.lightBlue),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Subtract the money.
                              if (walletCurrency >= 99.0) {
                                setState(() {
                                  walletCurrency -= 99.00;
                                });
                                getGeneratedItems();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("You got..."),
                                      content: generatedItems
                                    );
                                  }
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Icon(Icons.info),
                                      content: Text("You do not have enough currency")
                                    );
                                  }
                                );
                              }
                            },
                            child: Padding(padding: EdgeInsets.all(2), child: Text("Rs 99.00"))
                          )
                        )
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "OBTAINABLE ITEMS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            _getObtainableItems()
          ],
        ),
      ),
    );
  }

  Widget _getObtainableItems() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Card(
          child: Container(
            height: 100,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.lightBlue),
                ),
                child: Padding(padding: EdgeInsets.all(2), child: Text("CARDS"))
              )
            ),
          ),
        ),
        Card(
          child: Container(
            height: 100,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.lightBlue),
                ),
                child: Padding(padding: EdgeInsets.all(2), child: Text("GAME MATS"))
              )
            ),
          ),
        ),
        Card(
          child: Container(
            height: 100,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.lightBlue),
                ),
                child: Padding(padding: EdgeInsets.all(2), child: Text("ARENA"))
              )
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoExpansionPanel() {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.black
      ),
      child: ExpansionTile(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                Icon(Icons.apps),
                Text(" Artifacts in Literature")
              ]),
              Row(children: <Widget>[
                Icon(Icons.card_giftcard),
                Text(" " + walletCurrency.toString())
              ])
            ],
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '''Items in literature are categorised in different categories as follows. Rarer the category, the harder it is to obtain that particular item.''',
                maxLines: 3,
              )
            ),
          ),
          getArtifactsList()
        ],
      ),
    );
  }

  Color getColor(String artifactColor) {
    switch (artifactColor) {
      case "green":
        return Colors.teal[900];
        break;
      case "gold":
        return Colors.yellow[700];
        break;
      case "silver":
        return Colors.grey;
        break;
      case "bronze":
        return Colors.brown;
        break;
      default:
        return Colors.black;
    }
  }

  Widget getArtifactsList() {
    var children = artifacts.map((item) => Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item["rarity"],
            style: TextStyle(
              color: getColor(item["color"]),
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            item["chance"],
            style: TextStyle(
              color: getColor(item["color"]),
              fontWeight: FontWeight.bold
            ),
          )
        ]
      ),
    )).toList();
    return Column(
      children: children,
    );
  }
}
