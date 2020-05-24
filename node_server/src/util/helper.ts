import { Card, Cards, Suits } from "../types";
import { Player } from "../models/Room";

function getInitialCardList(): Card[] {
  const initialCardList: Card[] = [];
  
  Object.keys(Suits).forEach((suit) => {
    Object.keys(Cards).forEach((card) => {
      initialCardList.push({
        card: Cards[card as Cards],
        suit: Suits[suit as Suits]
      });
    });
  });

  return initialCardList;
}

function riffleShuffle(cards: Card[]): Card[] {
  const deck = cards.slice();
  const cutDeckVariant = deck.length / 2 + Math.floor(Math.random() * 9) - 4;
  const leftHalf = deck.splice(0, cutDeckVariant);
  let leftCount = leftHalf.length;
  let rightCount = deck.length - Math.floor(Math.random() * 4);
  while(leftCount > 0) {
    const takeAmount = Math.floor(Math.random() * 4);
    deck.splice(rightCount, 0, ...leftHalf.splice(leftCount, takeAmount));
    leftCount -= takeAmount;
    rightCount = rightCount - Math.floor(Math.random() * 4) + takeAmount;
  }
  deck.splice(rightCount, 0, ...leftHalf);
  return deck;
}

function divide(cards: Card[]): Card[] {
  const divided = [];
  let n = 0, offset = 1;
  while(n <= 47) {
    if(offset === 7) break;
    divided.push(cards[n]);
    if(n+6 > 47) {
      n = offset;
      offset+=1;
    } else {
      n+=6;
    }
  }
  return divided;
}

export function divideAndShuffleCards(): Card[] {
  return divide(riffleShuffle(getInitialCardList()));
}

export function divideIntoTeams(players: Player[]) {
  // Initialise teams
  players.map((value: Player, index: number) => {
    if (index % 2 == 0) {
      value["teamIdentifier"] = "red";
    } else {
      value["teamIdentifier"] = "blue";
    };
  });
  return players;
}
