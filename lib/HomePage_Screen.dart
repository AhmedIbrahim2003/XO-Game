import 'package:flutter/material.dart';
import 'package:xo_game/game_logic.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isTwoPlayers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation== Orientation.portrait? Column(
          children: [
            _SingleOrMultiplayer(),
            _turnPrint(),
            _expanded(context),
            _resultPrint(),
            _tryAgainButton(context)
          ],
        ):Row(
          children: [
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                _SingleOrMultiplayer(),
                _turnPrint(),
                _resultPrint(),
                _tryAgainButton(context)
              ],),
            ),
            _expanded(context)
          ],
        )
      ),
    );
  }
// test
  ElevatedButton _tryAgainButton(BuildContext context) {
    return ElevatedButton.icon(
            onPressed: () {
              setState(() {
                Player.playerX = [];
                Player.playerO = [];
                activePlayer = 'X';
                gameOver = false;
                turn = 0;
                result = '';
              });
            },
            icon: const Icon(Icons.replay),
            label: const Text("Repeat the game"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).splashColor)),
          );
  }

  Text _resultPrint() {
    return Text(
            result,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
            ),
            textAlign: TextAlign.center,
          );
  }

  Text _turnPrint() {
    return Text(
            "It's $activePlayer turn".toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
            ),
            textAlign: TextAlign.center,
          );
  }

  SwitchListTile _SingleOrMultiplayer() {
    return SwitchListTile.adaptive(
            title: const Text(
              'Turn on two player mode',
              style: TextStyle(color: Colors.white, fontSize: 28),
              textAlign: TextAlign.center,
            ),
            value: isTwoPlayers,
            onChanged: (bool newValue) {
              setState(() {
                isTwoPlayers = newValue;
              });
            },
          );
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
              child: GridView.count(
            padding: EdgeInsets.all(16),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 1.0,
            crossAxisCount: 3,
            children: List.generate(
                9,
                (index) => InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: gameOver ? null : () => _onPress(index),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(
                            child: Text(
                              Player.playerX.contains(index)
                                  ? 'X'
                                  : Player.playerO.contains(index)
                                      ? 'O'
                                      : '',
                              style: TextStyle(
                                color: Player.playerX.contains(index)
                                    ? Colors.blue
                                    : Colors.pink,
                                fontSize: 52,
                              ),
                            ),
                          )),
                    )),
          ));
  }

  _onPress(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isTwoPlayers&&!gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    return setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checKWinner();
      if(winnerPlayer != ''){
        gameOver = true;
        result = '$winnerPlayer in the winner';
      }else if (!gameOver && turn == 9){
      result = "It's Draw";}
    });
  }
}
