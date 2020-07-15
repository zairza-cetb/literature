export enum Cards {
  ace = "ace",
  two = "two",
  three = "three",
  four = "four",
  five = "five",
  six = "six",
  eight ="eight",
  nine = "nine",
  ten = "ten",
  jack = "jack",
  queen = "queen",
  king = "king"
}

export enum Suits {
  clubs = "clubs",
  diamonds = "diamonds",
  hearts = "hearts",
  spades = "spades" 
}

export type Card = {
  suit: Suits;
  card: Cards;
}

export type Move = {
  playerId: string;
  recipientId: string;
  card: Card;
}