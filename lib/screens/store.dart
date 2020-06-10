import 'package:flutter/material.dart';
import 'package:literature/provider/playerlistprovider.dart';
import 'package:literature/utils/constants.dart';
import 'package:provider/provider.dart';

class Store extends StatefulWidget {
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  List moneyValues;
  // selected money value for purchase.
  double amountOfPurchase;
  void initState() {
    super.initState();
    moneyValues = new List();
    moneyOptions.forEach((element) {
      moneyValues.add(element);
    });
  }
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerList>(context, listen: false);
    return new SafeArea(
      bottom: false,
      top: false,
      child: DefaultTabController(
        length: 3,
          child: Scaffold(
          // Disable going to the waiting page
          // cause there won't be any forwarding
          // from there on.
          // appBar: new AppBar(),
          appBar: AppBar(
            title: new Text("Literature Store"),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(2),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(children: <Widget>[
                    Icon(Icons.attach_money, size: 14),
                    Text(playerProvider.currency.toString(), style: TextStyle(fontStyle: FontStyle.italic)),
                  ],)
                ),
              )
            ],
            bottom: TabBar(tabs: [
              Tab(text: "Coins"),
              Tab(text: "Visuals"),
              Tab(text: "Combos")
            ]),
            elevation: 0,
            leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
            backgroundColor: Colors.lightBlue[800],
          ),
          body: TabBarView(children: [
            // Currency
            GridView.count(
              crossAxisCount: 2,
              children: moneyOptions.map((e) => Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0
                    )
                  ),
                  padding: const EdgeInsets.all(8),
                  // color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      amountOfPurchase = double.parse(e);
                      final playerProvider = Provider.of<PlayerList>(context, listen: false);
                      playerProvider.addCurrency(amountOfPurchase);
                      setState(() {});
                    },
                    child: Stack(children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(height: 140,child: Hero(tag: e, child: Image.asset("assets/money.png"))),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.attach_money), Text(e, style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic))
                          ],
                        )
                      )
                    ],),
                  ),
                ),
              )).toList(),
            ),
            Text("Buy In game mats and cards"),
            Text("Game packs"),
          ]),
        ),
      ),
    );
  }
}
