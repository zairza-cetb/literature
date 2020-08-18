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
      body: Row(
        children: <Widget>[
          SizedBox(height: 20.0,),
          Expanded(
            child: _buildInfoExpansionPanel()
          )
        ],
      ),
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
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '''Items in literature are categorised in different categories as follows. Rarer the category, the hardest it is to obtain that particular item.''',
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
      padding: EdgeInsets.all(5),
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
