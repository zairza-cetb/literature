import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:literature/screens/creategame.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/logo.png', width: MediaQuery.of(context).size.height * 0.6),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: Text(
            "Introduction",
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.05,
                color: const Color(0xFF6ad1ff),
                fontWeight: FontWeight.w100),
          ),
          bodyWidget: SingleChildScrollView(
              child: Container(
                  child: Text(
            "Literature is a partnership game for six, or sometimes eight players. Each team tries to collect sets of cards by asking for them in a manner similar to the children's game known as Go Fish, Happy Families, Quartet, Authors, etc. The team dimension makes the game considerably more challenging: to be successful it is necessary to pay attention to questions asked by other players, remember them and make appropriate deductions. It is possible that the name was chosen to reflect the relationship between this game and Authors - a game with special cards in which players collect sets consisting of an author and his or her works",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'B612',
              color: const Color(0xFF6ad1ff),
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ))),
          image: _buildImage('assets/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text(
            "Players and Cards",
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.05,
                color: const Color(0xFF6ad1ff),
                fontWeight: FontWeight.w100),
          ),
          bodyWidget: SingleChildScrollView(
              child: Container(
                  child: Text(
            "The best game is for six players in two teams of three. It is also possible for eight to play, four against four. The four 8's are removed from a standard 52-card deck, leaving 48 cards, which form eight half-suits, also known as sets or books. Each suit is divided into a half-suit of low or minor cards: 2-3-4-5-6-7 and a half-suit of high or major cards: 9-10-J-Q-K-A. The objective is, as a team, to collect and claim as many as possible of these half-suits. Teams can be chosen by drawing cards from the shuffled deck, or by any other method that the players prefer. Members of the two teams sit alternately, each player sitting between two opponents.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'B612',
              color: const Color(0xFF6ad1ff),
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ))),
          image: _buildImage('assets/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text(
            "Deal",
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.05,
                color: const Color(0xFF6ad1ff),
                fontWeight: FontWeight.w100),
          ),
          bodyWidget: SingleChildScrollView(
              child: Container(
                  child: Text(
            "A dealer is chosen at random, for example by drawing cards. This player thoroughly shuffles the deck and deals out all the cards one at a time face down, so that in a six-player game each player has 8 cards, and in an eight player game 6 cards. If any card is exposed, it is a misdeal, and the dealer re-shuffles and re-deals. Once all the cards have been dealt, players may look at their cards, but they are not allowed to show any of their cards to anyone else (especially not to their teammates).",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'B612',
              color: const Color(0xFF6ad1ff),
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ))),
          image: _buildImage('assets/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text(
            "Questions",
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.05,
                color: const Color(0xFF6ad1ff),
                fontWeight: FontWeight.w100),
          ),
          bodyWidget: SingleChildScrollView(
              child: Container(
                  child: Text(
            "The dealer takes the first turn. When it is your turn, you must ask any one specific player from the other team a valid question. A question is valid if and only if it meets the following criteria:You must ask for a specific card (by value and suit). You must have another card in that half-suit in your hand. The player you ask must hold at least one card. You must not ask for a card that is in your own hand",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'B612',
              color: const Color(0xFF6ad1ff),
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ))),
          image: _buildImage('assets/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text(
            "Claiming",
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.05,
                color: const Color(0xFF6ad1ff),
                fontWeight: FontWeight.w100),
          ),
          bodyWidget: SingleChildScrollView(
              child: Container(
                  child: Text(
            "If, at your turn, you have all six cards of a half-suit in your hand, you may claim the half-suit by laying the cards down face-up to show everyone. Your team gets that half-suit. In addition, if you believe that, between you and your teammates, your team possesses an entire half-suit, you may claim it in your turn by saying 'Claim' and then naming exactly who has which cards in the half-suit. If you do so correctly, your team gets the half-suit. If your team has the half suit, but you state the location of one or more cards wrongly, the half-suit is cancelled and neither team gets it. If any member of the opposing team has a card in the half-suit you try to claim, the opposing team gets the half-suit. After any half-suit has been claimed, the players holding cards of that half-suit show them, to prove whether the claim was correct or not. The six cards are stacked in front of a member of the winning team, and the game continues with the remaining cards.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'B612',
              color: const Color(0xFF6ad1ff),
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ))),
          image: _buildImage('assets/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text(
            "Endgame",
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.05,
                color: const Color(0xFF6ad1ff),
                fontWeight: FontWeight.w100),
          ),
          bodyWidget: SingleChildScrollView(
              child: Container(
                  child: Text(
            "As the game progresses players will run out of cards, either because an opponent successfully asks for their last card or because all their remaining cards belong to a half-suit that is claimed. A player who has no cards cannot be asked for a card, so the turn cannot be given to them. It is possible to lose all your remaining cards while it is your turn as a result of a claim. In this case you pass the turn to another member of your team who still has cards. In the event that more than one player in your team has cards, you choose which of your teammates gets the turn. When one team runs out of cards entirely, no more questions may be asked. The team with all the remaining cards must then try to claim out all remaining half-suits. If the turn is with the team that has cards, the player whose turn it is must claim all the remaining sets, without consulting his partners. If the turn is with the team that has run out of cards, the player whose turn it is chooses which member of the other team must make the final claims; the player chosen must have at least one card.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'B612',
              color: const Color(0xFF6ad1ff),
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ))),
          image: _buildImage('assets/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text(
            "Irregularities",
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.05,
                color: const Color(0xFF6ad1ff),
                fontWeight: FontWeight.w100),
          ),
          bodyWidget: SingleChildScrollView(
              child: Container(
                  child: Text(
            "If a player discovers that he or she has asked an invalid question or failed to hand over a card he or she was asked for, he or she should alert all players, who, as a group, will determine how best to resolve the situation (either by throwing in that half-suit, giving the card to someone on the other team, etc.). The penalty for claiming when it is not your turn is that the half-suit is cancelled if the claimer's team has it all, or awarded to the opponents if they have any of the cards. Similarly, if you see a card in a teammate's hand, try to play as if you did not, but, if the information you inadvertantly gained cannot help but affect your play, alert the other players to come to a fair solution. If a player needs time to process information or to work out a potential claim, he or she may call 'Wait' or 'Stop' at any time. Play should pause until that player indicates that he or she is ready to continue. However, this courtesy should not be abused or used solely to break the pace of play or as an attempt to make others forget information.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'B612',
              color: const Color(0xFF6ad1ff),
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ))),
          image: _buildImage('assets/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text(
            "Scoring",
            style: TextStyle(
                fontFamily: 'B612',
                fontSize: MediaQuery.of(context).size.height * 0.05,
                color: const Color(0xFF6ad1ff),
                fontWeight: FontWeight.w100),
          ),
          bodyWidget: SingleChildScrollView(
              child: Container(
                  child: Text(
            "The game is over when all half-suits are claimed, and the team that won more half-suits are the winners. Ties, in which each team has 4 half-suits, are fairly frequent. Some of the variations described below reduce the likelihood of a tie.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'B612',
              color: const Color(0xFF6ad1ff),
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ))),
          image: _buildImage('assets/logo.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CreateGame()));
      },
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        'Skip',
        style: TextStyle(
          fontFamily: 'B612',
          color: const Color(0xFF6ad1ff),
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: const Color(0xFF6ad1ff),
      ),
      done: const Text('Done',
          style: TextStyle(
            color: const Color(0xFF6ad1ff),
            fontFamily: 'B612',
          )),
      dotsDecorator:  DotsDecorator(
        size: Size(MediaQuery.of(context).size.height * 0.01, MediaQuery.of(context).size.height * 0.01),
        color: Color(0xFFBDBDBD),
        activeSize: Size(MediaQuery.of(context).size.height * 0.04, MediaQuery.of(context).size.height * 0.018),
        activeColor: Color(0xFF6ad1ff),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.01)),
        ),
      ),
    );
  }
}
