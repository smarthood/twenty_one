import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/resources/socket_methods.dart';
import 'package:provider/provider.dart';
import '../Widgets/Custom_Text.dart';

class TwentyoneGameBoard extends StatefulWidget {
  const TwentyoneGameBoard({Key? key}) : super(key: key);

  @override
  State<TwentyoneGameBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TwentyoneGameBoard> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    isIncButtonDisable = false;
    isDecButtonDisable = true;
    _socketMethods.tappedListener(context);
  }

  void tapped(int count, RoomDataProvider roomDataProvider) {
    _socketMethods.tapGrid(
      roomDataProvider.roomData['_id'],
      count,
    );
  }

  int count = 0;
  late bool isIncButtonDisable;
  late bool isDecButtonDisable;

  @override
  void increment() {
    setState(() {
      if (count == -1) {
        isDecButtonDisable = true;
      } else {
        isDecButtonDisable = false;
      }
      count++;
    });
    print(count);
  }

  @override
  void decrement() {
    setState(() {
      if (count <= 1) {
        isDecButtonDisable = true;
      } else {
        isDecButtonDisable = false;
      }
      count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.7,
        maxWidth: 500,
      ),
      child: AbsorbPointer(
        absorbing: roomDataProvider.roomData['turn']['socketID'] !=
            _socketMethods.socketClient.id,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => increment(),
                  iconSize: 100,
                  icon: Icon(
                    Icons.arrow_drop_up,
                  )),
              CustomText(shadows: [
                Shadow(
                  blurRadius: 40,
                  color: Colors.purple,
                )
              ], text: '$count', fontSize: 120),
              IconButton(
                  onPressed: isDecButtonDisable ? null : decrement,
                  iconSize: 100,
                  icon: Icon(
                    Icons.arrow_drop_down,
                  )),
              TextButton(
                onPressed: () {},
                child: Text("Pass"),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple),
              )
            ],
          ),
        ),
      ),
    );
  }
}
