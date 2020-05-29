import 'package:enum_to_string/enum_to_string.dart';

// Returns true if the person has a card of same set
// so that he can ask for it to the opponent.
bool hasOneFromSameSet (cardSuit, cardType, cardsList) {
  Map refresz = formSetDefinitions(cardsList);
  var set = lowerSet(cardType) ? "low" : "high";
  var keyToSearch = cardSuit + " -> " + set;
  if (refresz[keyToSearch] == "true") {
    // clear space for next values.
    refresz.clear();
    return true;
  }
  // clear space for next values.
  refresz.clear();
  return false;
}

// Forms a search space of cards.
formSetDefinitions(cards) {
  Map<String, String> hm = new Map();
  cards.forEach((card) {
    // { cardSuit -> "low" or "high"  : "true" or "false" }
    hm.putIfAbsent(
      EnumToString.parse(card.cardSuit) + " -> " + (lowerSet(EnumToString.parse(card.cardType)) ? "low" : "high"),
      () => "true"
    );
  });
  return hm;
}

bool lowerSet(type) {
  if (type == "ace" || type == "two" || type == "three" || type == "four" || type == "five" || type == "six") {
    return true;
  } return false;
}

// If a person has that card in his hand or not?
hasSameCard(suit, type, cardsList) {
  bool hasSameCard = false;
  for (var i=0; i< cardsList.length; i++) {
    if (
      EnumToString.parse(cardsList[i].cardSuit) == suit && EnumToString.parse(cardsList[i].cardType) == type
    ) {
      hasSameCard = true;
      return true;
    }
  }
  return hasSameCard;
}

// Holds a list containing currently selected set values.
  List<dynamic> buildSetWithSelectedValues (suit, selectedSet) {
    List<dynamic> tempList = new List<dynamic>();
    if (selectedSet == "L") {
      for (var i=1; i<=6; i++) {
        switch(i) {
          case 1:
            tempList.add({ "suit": suit, "type": "ace", "value": "ace", "display": "A" });
            break;
          case 2:
            tempList.add({ "suit": suit, "type": "two", "value": "two", "display": "2" });
            break;
          case 3:
            tempList.add({ "suit": suit, "type": "three", "value": "three", "display": "3" });
            break;
          case 4:
            tempList.add({ "suit": suit, "type": "four", "value": "four", "display": "4" });
            break;
          case 5:
            tempList.add({ "suit": suit, "type": "five", "value": "five", "display": "5" });
            break;
          case 6:
            tempList.add({ "suit": suit, "type": "six", "value": "six", "display": "6" });
            break;
          default:
            break;
        }
      }
    } else {
      for (var i=1; i<=6; i++) {
        switch(i) {
          case 1:
            tempList.add({ "suit": suit, "type": "eight", "value": "eight", "display": "8" });
            break;
          case 2:
            tempList.add({ "suit": suit, "type": "nine", "value": "nine", "display": "9" });
            break;
          case 3:
            tempList.add({ "suit": suit, "type": "ten", "value": "ten", "display": "10" });
            break;
          case 4:
            tempList.add({ "suit": suit, "type": "jack", "value": "jack", "display": "J" });
            break;
          case 5:
            tempList.add({ "suit": suit, "type": "king", "value": "king", "display": "K" });
            break;
          case 6:
            tempList.add({ "suit": suit, "type": "queen", "value": "queen", "display": "Q" });
            break;
          default:
            break;
        }
      }
    }
    return tempList;
  }
  
