import 'package:flutter/material.dart';
import 'package:literature/components/appbar.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  void initState() {
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
                          child: Padding(padding: EdgeInsets.all(2), child: Text("Rs 99.00"))
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
                child: Padding(padding: EdgeInsets.all(2), child: Text("ROPES"))
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
            children: <Widget>[
              Icon(Icons.apps),
              Text(" Artifacts in Literature")
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
