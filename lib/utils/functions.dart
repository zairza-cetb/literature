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
